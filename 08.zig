const std = @import("std");

pub fn main() !void {
    @setEvalBranchQuota(30_000);
    const input = @embedFile("08.txt");
    const connections = 1000;

    var part: [2]usize = .{ 1, 0 };
    const Coord = @Vector(3, f32);
    const boxes_count = comptime std.mem.countScalar(u8, input, '\n');
    var boxes: [boxes_count]Coord = undefined;

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var bi: usize = 0;
    while (it.next()) |line| : (bi += 1) {
        var j: usize = 0;
        var c: [3]f32 = @splat(0);

        for (line) |e| {
            if ('0' <= e and e <= '9') {
                c[j] *= 10;
                c[j] += @floatFromInt(e - '0');
            }
            j += @intFromBool(e == ',');
        }

        boxes[bi] = c;
    }

    var dist: [boxes_count * (boxes_count / 2)]f32 = undefined;
    var dist_index: [dist.len]usize = undefined;
    var dist_k: usize = 0;
    for (0..boxes.len) |i| {
        for (i + 1..boxes.len) |j| {
            const p = boxes[i];
            const q = boxes[j];
            dist[dist_k] = @sqrt(@reduce(.Add, (p - q) * (p - q)));
            dist_index[dist_k] = (i << 16) + j;
            dist_k += 1;
        }
    }

    var c: [boxes_count]usize = @splat(0);
    var cn: usize = 1;
    var min_bound: f32 = 0;

    var loop: usize = 1;
    while (true) : (loop += 1) {
        var min_d = std.math.inf(f32);
        var min_i: usize = 0;
        var min_j: usize = 0;

        for (&dist, &dist_index) |d, joint_i| {
            if (d < min_d and d > min_bound) {
                min_d = d;
                min_i = joint_i >> 16;
                min_j = joint_i & 0xffff;
            }
        }
        min_bound = min_d;

        if (c[min_i] == 0 and c[min_j] == 0) {
            cn += 1;
            c[min_i] = cn;
            c[min_j] = cn;
        } else if (c[min_i] == 0) {
            c[min_i] = c[min_j];
        } else if (c[min_j] == 0) {
            c[min_j] = c[min_i];
        } else if (c[min_i] != c[min_j]) {
            const min = @min(c[min_i], c[min_j]);
            const max = @max(c[min_i], c[min_j]);
            for (0..c.len) |i| {
                if (c[i] == min) c[i] = max;
            }
        }

        // part 1
        if (loop == connections) {
            var conn: [connections]usize = @splat(0);
            for (&c) |e| conn[e] += 1;

            for (0..3) |_| {
                const i = std.mem.findMax(usize, conn[1..]);
                part[0] *= conn[1 + i];
                conn[1 + i] = 0;
            }
        }

        // part 2
        if (std.mem.allEqual(usize, c[1..], c[0])) {
            part[1] = @intFromFloat(boxes[min_i][0]);
            part[1] *= @intFromFloat(boxes[min_j][0]);
            break;
        }
    }

    std.debug.print("1: {}\n2: {}\n", .{ part[0], part[1] });
}
