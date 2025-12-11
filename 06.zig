const std = @import("std");

pub fn main() !void {
    const input = @embedFile("06.txt");

    var part: [2]usize = @splat(0);
    const row_w = std.mem.findScalar(u8, input, '\n').? + 1;
    const row_last = input.len / row_w - 1;

    var i: usize = 0;
    while (i < row_w) {
        const op: enum { add, mul } = switch (input[row_w * row_last + i]) {
            '+' => .add,
            '*' => .mul,
            else => break,
        };
        const offset = (std.mem.findNone(u8, input[row_w * row_last + i + 1 ..], " ") orelse break) + 1;
        const limits: [2]usize = .{ row_last, offset };

        inline for (0..2) |c| {
            var sum: usize = @intFromEnum(op);
            for (0..limits[c]) |x1| {
                var n: usize = 0;
                for (0..limits[1 - c]) |x2| {
                    const e = input[i + (if (c == 0) row_w * x1 + x2 else row_w * x2 + x1)];
                    if ('0' <= e and e <= '9') n = 10 * n + (e - '0');
                }
                if (n == 0) {} else if (op == .add) sum += n else sum *= n;
            }
            part[c] += sum;
        }
        i += offset;
    }

    std.debug.print("1: {}\n2: {}\n", .{ part[0], part[1] });
}
