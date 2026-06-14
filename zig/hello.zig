const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    std.log.info("Application started", .{});
    std.debug.print("Simple math debug.\n", .{});
    try std.Io.File.stdout().writeStreamingAll(io, "Hello, World!\n");
}

test "simple math" {
    std.testing.log_level = .debug;
    std.log.info("Simple math info.", .{});
    try std.testing.expectEqual(@as(u8, 2), @as(u8, 1) + 1);
}
