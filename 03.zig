const std = @import("std");

pub fn main() void {
    const input = @embedFile("03.txt");

    var part: [2]usize = @splat(0);

    var it = std.mem.tokenizeAny(u8, input, ",\n");
    while (it.next()) |bank| {
        inline for (.{ 2, 12 }, 0..) |count, j| {
            var b: [count]usize = @splat(0);
            var l: usize = 0;

            for (0..count) |c| {
                for (l..bank.len + c + 1 - count) |i| {
                    const v = bank[i] - '0';
                    if (v > b[c]) {
                        b[c] = v;
                        l = i + 1;
                    }
                }
            }

            var n: usize = 0;
            for (0..count) |c| n = n * 10 + b[c];
            part[j] += n;
        }
    }

    std.debug.print(
        \\1: {}
        \\2: {}
        \\
    , .{ part[0], part[1] });
}
