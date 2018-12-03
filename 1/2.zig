const std = @import("std");

const debug  = std.debug;

// Awk would be a better tool for this
pub fn main() !void {
    var input = std.os.File.openRead("input.txt") catch |err| {
        debug.warn("No input file");
        return err;
    };
    defer input.close();
    const size = try input.getEndPos();

    var direct_alloc = std.heap.DirectAllocator.init().allocator;

    var buf = try std.Buffer.initSize(&direct_alloc, size); // Allocate & Pray
    defer buf.deinit();

    _ = input.read(buf.toSlice());

    var nums = std.ArrayList(i64).init(&direct_alloc);
    var lines = std.mem.split(buf.toSlice(), "\n");
    while (lines.next()) |line| {
        var i = try std.fmt.parseInt(i64, line, 10);
        _ = nums.append(i);
    }

    var map = std.AutoHashMap(i64, void).init(&direct_alloc);
    defer map.deinit();
    var sum: i64 = 0;
    outer: while (true) {
        for (nums.toSlice()) |value| {
            if (try map.put(sum, {})) |_| break :outer;
            sum += value;
        }
    }

    debug.warn("{}\n", sum);
}
