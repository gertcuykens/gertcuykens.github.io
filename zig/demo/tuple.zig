const std = @import("std");
const expect = std.testing.expect;

test "struct-to-struct coercion silently adopts comptime defaults" {
    const A = @TypeOf(.{@as(i32, 1)}); // struct { comptime i32 = 1 }
    const C = @TypeOf(.{@as(i32, 999)}); // struct { comptime i32 = 999 }
    const c: C = .{@as(i32, 999)};
    const x: A = c; // expected: compile error (999 != default 1); actual: silent
    try expect(x[0] == 1); //the test fail, the lost value: 999 became 1

    const ATuple = struct { i32 };
    const BTuple = struct { i32 };
    if (ATuple != BTuple)
        @compileError("named tuples are the same type");

    const AStruct = struct { field: i32 };
    const BStruct = struct { field: i32 };
    if (AStruct == BStruct)
        @compileError("named struct are different types");
}
