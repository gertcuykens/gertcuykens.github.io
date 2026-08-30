const std = @import("std");

pub const std_options: std.Options = .{
    .log_level = @enumFromInt(@intFromEnum(@import("options").log_level)),
    // .logFn = @import("options").myCustomLogFn,
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
    // std.testing.log_level = std_options.log_level;
    // std.log.info("log info.", .{});
    // std.log.debug("log debug.", .{});
    std.debug.print("\nhello debug print.\n", .{});
    try std.testing.expectEqual(@as(u8, 2), @as(u8, 1) + 1);
}

test "optional pointer field type" {
    const p: ?*const void = null;
    // const p: *const void = &{};
    const T = @Struct(
        .auto,
        null,
        &.{"field"},
        &.{?*const void},
        &.{.{ .default_value_ptr = @ptrCast(&p) }},
    );

    const instance: T = .{};
    std.debug.print("{}\n", .{@TypeOf(instance.field)});
}

test "crash" {
    var a: [32]u8 = undefined;
    var b: [32]u8 = undefined;
    for (&a, &b, 0..) |*x, *y, i| {
        x.* = @intCast(100 + i);
        y.* = @intCast(i);
    }
    std.mem.doNotOptimizeAway(&a);
    std.mem.doNotOptimizeAway(&b);
    const d: [32]u8 = @as(@Vector(32, u8), a) -% @as(@Vector(32, u8), b);
    try std.testing.expectEqual(@as(u8, 100), d[0]);
}

test "crash2" {
    var a: [32]u8 = @splat(1);
    var b: [32]u8 = @splat(0);
    std.mem.doNotOptimizeAway(&a);
    std.mem.doNotOptimizeAway(&b);
    const d: [32]u8, const over: @Vector(32, u1) = @subWithOverflow(@as(@Vector(32, u8), a), @as(@Vector(32, u8), b));
    try std.testing.expectEqual(@as(u32, 0), @as(*const u32, @ptrCast(&over)).*);
    try std.testing.expectEqual(0, @reduce(.Or, over));
    try std.testing.expectEqual(0, @as(u32, @bitCast(over)));
    try std.testing.expectEqual(@as(u8, 1), d[0]);
}

const Context = struct {
    history: std.ArrayList(u8),
    lines: std.ArrayList([]const u8),

    fn parse(ctx: *Context, allocator: std.mem.Allocator, input: []const u8) !void {
        const slice = try ctx.history.addManyAsSlice(allocator, input.len);
        @memcpy(slice, input);
        var it = std.mem.tokenizeScalar(u8, slice, '\n');
        while (it.next()) |line| {
            try ctx.lines.append(allocator, line);
        }
    }
};

test "Context.parse" {
    const input = "I'm first!\n";
    const input_two =
        \\But this text
        \\is juuuuuuuuuuuuuuuuuuuuuuuuust long enough that it
        \\causes a problem!
        \\And the problem could be that we segfault!
        \\Which is no fun to run into.
    ;
    var ctx: Context = .{
        .history = .empty,
        .lines = .empty,
    };
    const gpa = std.testing.allocator;
    defer ctx.history.deinit(gpa);
    defer ctx.lines.deinit(gpa);
    try ctx.parse(gpa, input);
    // ctx.history.lockPointers();
    // defer ctx.history.unlockPointers();
    try ctx.parse(gpa, input_two);
    try std.testing.expectEqualStrings("I'm first!", ctx.lines.items[0]);
}
