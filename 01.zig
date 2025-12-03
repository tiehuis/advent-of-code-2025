const std = @import("std");

pub fn main() void {
    const input = @embedFile("01.txt");

    var part1: usize = 0;
    var part2: usize = 0;
    var dial: isize = 50;

    var i: usize = 0;
    while (i + 1 < input.len) {
        const l = input[i..][0..];
        const d2 = l[3] == '\n';
        const d3 = l[4] == '\n';
        const m2: usize = @intFromBool(d2 or d3);
        const m3: usize = @intFromBool(d3);

        var n: usize = l[1] -| '0';
        n = (9 * m2 + 1) * n + m2 * (l[2] -| '0');
        n = (9 * m3 + 1) * n + m3 * (l[3] -| '0');

        const rot: isize = (l[0] >> 1) & 1;
        const delta = @as(isize, @intCast(n)) * (1 - (2 * rot));
        const diff = @divTrunc((dial + delta) + (rot * -100), 100);

        part2 += @abs(diff);
        part2 -= @intFromBool(delta < 0 and dial == 0);
        dial = @mod(dial + delta, 100);
        part1 += @intFromBool(dial == 0);
        i += 3 + m2 + m3;
    }

    std.debug.print(
        \\1: {}
        \\2: {}
        \\
    , .{ part1, part2 });
}
