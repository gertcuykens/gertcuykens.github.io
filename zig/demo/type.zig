// {} struct
const Point = struct {
    x: f32,
    y: f32,
};

// .{} tuple
const p: Point = .{
    .x = 0.12,
    .y = 0.34,
};

// [_:0]{} array
const array = [_]i32{ 1, 2, 3, 4 };

// []{} slices
const slice: *const [4]i32 = &.{ 1, 2, 3, 4 };

// {} void

const std = @import("std");

fn checkVariable(comptime v: anytype) void {
    if (@TypeOf(v) == type) {
        std.debug.print("It is a Type! Detailed info: {}\n", .{@typeInfo(v)});
    } else {
        const info = @typeInfo(@TypeOf(v));
        std.debug.print("It is a Value! The value's type group is: {}\n", .{info});
    }
}
