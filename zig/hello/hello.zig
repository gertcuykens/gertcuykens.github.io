const std = @import("std");
const build_config = @import("build_config");

pub const std_options: std.Options = .{
    .log_level = @enumFromInt(@intFromEnum(build_config.log_level)),
};

pub fn main(init: std.process.Init) !void {
    std.log.debug("log debug.", .{});
    std.log.info("log info.", .{});

    var x: [:0]const u8 = "";
    x = "hello";
    std.debug.print("x.ptr={s} x.len={d}.\n", .{ x.ptr, x.len });

    var y: ?[*:0]const u8 = null;
    y = x.ptr;

    var slice: [:0]const u8 = undefined;
    if (y) |ptr| {
        std.debug.print("y={s}.\n", .{ptr});
        slice = std.mem.span(ptr);
        std.debug.print("String is: {s}, length: {d}\n", .{ slice, slice.len });
    } else {
        std.debug.print("String is null\n", .{});
    }

    var a: [5]u8 = undefined;
    std.mem.copyForwards(u8, &a, slice);
    std.debug.print("buffer={s}\n", .{a});

    var z: c_int = 42;
    z += 1;
    std.debug.print("z={d}.\n", .{z});
    std.debug.assert(z == 43);

    const io = init.io;
    try std.Io.File.stdout().writeStreamingAll(io, "Hello, World!\n");
}

test "hello" {
    // std.testing.log_level = .info;
    // std.log.info("log info.", .{});
    // std.log.debug("log debug.", .{});
    try std.testing.expectEqual(@as(u8, 2), @as(u8, 1) + 1);
}
