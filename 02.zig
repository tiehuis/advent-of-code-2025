const std = @import("std");

pub fn main() !void {
    const input = @embedFile("02.txt");

    var part1: usize = 0;
    var part2: usize = 0;

    var it = std.mem.tokenizeAny(u8, input, ",\n");
    while (it.next()) |range| {
        const index = std.mem.findScalar(u8, range, '-').?;
        const lo = try std.fmt.parseUnsigned(usize, range[0..index], 10);
        const hi = try std.fmt.parseUnsigned(usize, range[index + 1 ..], 10);

        const tens = comptime blk: {
            var a: [16]usize = @splat(1);
            for (1..16) |i| a[i] = a[i - 1] * 10;
            break :blk a;
        };

        for (lo..hi + 1) |x| {
            const len = std.math.log10(x) + 1;
            const mask = tens[len / 2];
            part1 += @intFromBool(x / mask == x % mask) * x;

            factors: for (1..len / 2 + 1) |f| {
                if (len % f != 0) continue;
                const rep = x % tens[f];
                var nx = x / tens[f];
                while (nx != 0) : (nx /= tens[f]) {
                    if (nx % tens[f] != rep) continue :factors;
                }
                part2 += x;
                break;
            }
        }
    }

    std.debug.print(
        \\1: {}
        \\2: {}
        \\
    , .{ part1, part2 });
}
