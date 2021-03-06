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

    var allocator = std.heap.DirectAllocator.init().allocator;

    var buf = try std.Buffer.initSize(&allocator, size); // Allocate & Pray
    defer buf.deinit();

    _ = input.read(buf.toSlice());
    var lines = std.mem.split(buf.toSlice(), "\n");
    var sum: i64 = 0;

    while (lines.next()) |line| {
        sum += try std.fmt.parseInt(i64, line, 10);
    }

    debug.warn("{}\n", sum);
}
