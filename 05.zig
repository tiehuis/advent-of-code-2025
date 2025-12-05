const std = @import("std");

pub fn main() !void {
    const input = @embedFile("05.txt");

    var part1: usize = 0;
    var part2: usize = 0;

    const Range = struct { lo: usize, hi: usize };
    var ranges_storage: [256]Range = undefined;
    var ranges: std.ArrayList(Range) = .initBuffer(&ranges_storage);

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        const index = std.mem.findScalar(u8, line, '-') orelse break;
        const lo = try std.fmt.parseUnsigned(usize, line[0..index], 10);
        const hi = try std.fmt.parseUnsigned(usize, line[index + 1 ..], 10);

        // preserve order in ranges
        var l: usize = 0;
        var r = ranges.items.len;

        while (l < r) {
            const mid = l + (r - l) / 2;
            if (ranges.items[mid].lo < lo) l = mid + 1 else r = mid;
        }

        try ranges.insertBounded(l, .{ .lo = lo, .hi = hi });
    }

    // merge overlapping ranges in place
    {
        var i: usize = 0;
        var r = ranges.items[0];
        for (ranges.items[1..]) |n| {
            if (r.hi >= n.hi) {
                continue;
            }

            if (r.hi >= n.lo) {
                r.hi = n.hi;
                continue;
            }

            part2 += r.hi - r.lo + 1;
            ranges.items[i] = r;
            i += 1;
            r = n;
        }

        part2 += r.hi - r.lo + 1;
        ranges.items[i] = r;
        i += 1;
        ranges.items.len = i;
    }

    while (it.next()) |line| {
        const n = try std.fmt.parseUnsigned(usize, line, 10);

        for (ranges.items) |r| {
            if (n > r.hi) {
                continue;
            }

            if (r.lo <= n and n <= r.hi) {
                part1 += 1;
                break;
            }
        }
    }

    std.debug.print("1: {}\n2: {}\n", .{ part1, part2 });
}
