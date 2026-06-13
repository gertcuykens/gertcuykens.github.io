const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    try std.Io.File.stdout().writeStreamingAll(io, "Hello, World!\n");
}

test "simple math" {
    try std.testing.expectEqual(@as(u8, 2), @as(u8, 1) + 1);
}
