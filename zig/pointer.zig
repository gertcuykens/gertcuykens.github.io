const std = @import("std");
const expectEqual = std.testing.expectEqual;

test "" {
    var arr = [_]u8{ 10, 20, 30, 40 };

    // Coerce a slice's pointer directly into a multi-item pointer
    const many_ptr: [*]u8 = arr[0..].ptr;

    // You can now index it like an array!
    std.debug.print("Index 2: {}\n", .{many_ptr[2]}); // Prints 30

    // You can also perform raw pointer arithmetic
    const shifted_ptr = many_ptr + 1;
    std.debug.print("Shifted Index 0: {}\n", .{shifted_ptr[0]}); // Prints 20
}

test "" {
    const arr = [4]u8{ 10, 20, 30, 40 };
    // Address:  0x...1 0x...2 0x...3 0x...4
    // Value:    [ 10 ] [ 20 ] [ 30 ] [ 40 ]


    const slc1 = arr[1..3];
    const slc2: []const u8 = .{ .ptr = &arr[1], .len = 2 };

    // 1. Assert they point to the exact same memory address
    try expectEqual(slc1.ptr, slc2.ptr);

    // 2. Assert they have the exact same length
    try expectEqual((slc1.len, slc2.len);

    std.debug.print("Both slices are completely identical in memory!\n", .{});
}

// +----------------+---------------------+---------------------------+---------------------------------+
// | *T             | Single-item pointer | Exactly one item.         | Dereferencing (ptr.*) only.     |
// +----------------+---------------------+---------------------------+---------------------------------+
// | [*]T           | Multi-item pointer  | Start of a sequence.      | Arithmetic (ptr+1) & indexing.  |
// +----------------+---------------------+---------------------------+---------------------------------+
// | [*:0]T         | Sentinel-multi-ptr  | Sequence ending with 0.   | Arithmetic, indexing, scanning. |
// +----------------+---------------------+---------------------------+---------------------------------+
// | []T            | Slice               | Multi-pointer + Length.   | Safe bounds-checked indexing.   |
// +----------------+---------------------+---------------------------+---------------------------------+
// | [:0]T          | Sentinel-slice      | Multi-ptr + Len + 0 tail. | Safe indexing + safe len read.  |
// +----------------+---------------------+---------------------------+---------------------------------+

test "" {
    var array = [_]i32{ 1, 2, 3, 4 };
    var known_at_runtime_zero: usize = 0;
    _ = &known_at_runtime_zero;
    const slice = array[known_at_runtime_zero..array.len];
    const slice: []const i32 = &.{ 1, 2, 3, 4 };
}

const Point = struct { x: i32, y: i32 };

var pt = Point{ .x = 10, .y = 20 };
var ptr = &pt;
ptr.x = 30; 
pt.x = 30;

var value: i32 = 5;
const ptr = &value;
ptr.* = 10; 

