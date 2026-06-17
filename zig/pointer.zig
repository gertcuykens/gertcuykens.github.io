const std = @import("std");
const expectEqual = std.testing.expectEqual;

test "a" {
    var arr = [_]u8{ 10, 20, 30, 40 };

    // Coerce a slice's pointer directly into a multi-item pointer
    const many_ptr: [*]u8 = arr[0..].ptr;

    // You can now index it like an array!
    std.debug.print("Index 2: {}\n", .{many_ptr[2]}); // Prints 30

    // You can also perform raw pointer arithmetic
    const shifted_ptr = many_ptr + 1;
    std.debug.print("Shifted Index 0: {}\n", .{shifted_ptr[0]}); // Prints 20
}

test "b" {
    const arr = [4]u8{ 10, 20, 30, 40 };
    // Address:  0x...1 0x...2 0x...3 0x...4
    // Value:    [ 10 ] [ 20 ] [ 30 ] [ 40 ]

    const slc1 = arr[1..3];
    const slc2 = arr[1..3];
    // const slc2: []const u8 = .{ .ptr = &arr[1], .len = 2 };

    try expectEqual(slc1.ptr, slc2.ptr);
    try expectEqual(slc1.len, slc2.len);

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

test "c" {
    var array = [_]i32{ 1, 2, 3, 4 };
    var known_at_runtime_zero: usize = 0;
    _ = &known_at_runtime_zero;
    const slice = array[known_at_runtime_zero..array.len];
    const ptr: *const [4]i32 = &.{ 1, 2, 3, 4 };
    try expectEqual(slice[0], ptr[0]);
    std.debug.print(" {} - {}\n", .{ slice[0], ptr[0] });
}

test "d" {
    const Point = struct { x: i32, y: i32 };
    var p = Point{ .x = 10, .y = 20 };
    p.x = 30;

    var ptr1 = &p;
    ptr1.x = 30;

    var value: i32 = 5;
    const ptr2 = &value;
    ptr2.* = 10;
}

test "Dereference * Unwrap ? Adress &" {
    var b: ?i32 = 42;
    // b must be optional
    if (b) |*box| {
        const value = box.*;
        std.debug.print(" {}\n", .{value});
    }
    if (b) |box| {
        const value = box;
        std.debug.print(" {}\n", .{value});
    }
    // Panics if b is null
    std.debug.print(" {}\n", .{b.?});

    const p: *?i32 = &b;
    if (p.*) |value| {
        std.debug.print(" {}\n", .{value});
    }

    var v: i32 = 42;
    // not valid p must be optional
    // const p: *i32 = &v;
    // if (p) |ptr| {
    //     const value = ptr.*;
    //     std.debug.print(" {}\n", .{value});
    // }

    const optr: ?*i32 = &v;
    if (optr) |ptr| {
        const value = ptr.*;
        std.debug.print(" {}\n", .{value});
    }
    // ?*i32 no extra byte needed same size as *i32, null = 0x...0
    // *?i32 extra byte needed 16 bytes (8 for 64bit pointer + 8 for 64 bit data)
}

// two values |val, index| or |err, trace| only when using a for loop or a catch block.
// try built-in shortcut for catch |err| return err;
