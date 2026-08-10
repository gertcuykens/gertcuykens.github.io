const std = @import("std");
const expectEqual = std.testing.expectEqual;

test {
    const a = {};
    try expectEqual(void, @TypeOf(a));
}

// blk: {
//     const d: u32 = 5;
//     const e: u32 = 100;
//     break :blk d + e;
// }

// const run = struct {
//     fn go() void {
//         return;
//     }
// }.go;
// run();

// NO Type inference
// var x T = .{}

// Type inference
// var x T = .f()
// var x T = .v
