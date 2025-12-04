const std = @import("std");

pub fn main() void {
    const input = @embedFile("04.txt");

    var part1: usize = 0;
    var part2: usize = 0;

    const row_len = comptime std.mem.findScalar(u8, input, '\n').?;
    const border: [row_len + 1]u8 = @splat('.');
    const const_grid = border ++ input ++ border;

    var grid: [const_grid.len]u8 = undefined;
    @memcpy(grid[0..], const_grid[0..]);

    // 1.
    for (border.len..input.len + border.len) |i| {
        if (grid[i] != '@') continue;

        var c: usize = 0;
        inline for (.{
            i - border.len - 1,
            i - 1,
            i + border.len - 1,
        }) |offset| {
            for (grid[offset..][0..3]) |e| c += @intFromBool(e == '@');
        }
        if (c < 5) {
            part1 += 1;
        }
    }

    // 2.
    var removed: usize = 0;
    while (true) {
        for (border.len..input.len + border.len) |i| {
            if (grid[i] != '@') continue;

            var c: usize = 0;
            inline for (.{
                i - border.len - 1,
                i - 1,
                i + border.len - 1,
            }) |offset| {
                for (grid[offset..][0..3]) |e| c += @intFromBool(e == '@');
            }
            if (c < 5) {
                grid[i] = '.';
                removed += 1;
            }
        }

        part2 += removed;
        if (removed == 0) break;
        removed = 0;
    }

    std.debug.print("1: {}\n2: {}\n", .{ part1, part2 });
}
