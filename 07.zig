const std = @import("std");

pub fn main() !void {
    const input = @embedFile("07.txt");

    var part: [2]usize = @splat(0);
    const w = comptime std.mem.findScalar(u8, input, '\n').? + 1;
    const s = std.mem.findScalar(u8, input, 'S').?;

    var grid: [input.len]u8 = undefined;
    @memcpy(&grid, input);

    var visited: [w]usize = @splat(0);
    visited[s] = 1;

    for (w + s..grid.len - w) |i| {
        switch (grid[i - w]) {
            '|', 'S' => switch (grid[i]) {
                '^' => {
                    grid[i - 1] = '|';
                    grid[i + 1] = '|';
                    part[0] += 1;

                    const c = i % w;
                    visited[c - 1] += visited[c];
                    visited[c + 1] += visited[c];
                    visited[c] = 0;
                },
                else => grid[i] = '|',
            },
            else => {},
        }
    }

    for (visited) |e| part[1] += e;
    std.debug.print("1: {}\n2: {}\n", .{ part[0], part[1] });
}
