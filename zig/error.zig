const std = @import("std");
const expectEqual = std.testing.expectEqual;
const MathErrors = error{ DivisionByZero, Overflow };
const NetworkErrors = error{ Timeout, Disconnected };

fn GenericMaybe(comptime T: type, comptime E: type) type {
    if (@typeInfo(E) != .error_set) {
        @compileError("The second argument (E) must be an 'error' set type, but found: " ++ @typeName(E));
    }

    const t_info = @typeInfo(T);
    if (t_info == .error_set or t_info == .error_union) {
        @compileError("The first argument (T) cannot be an error type, but found: " ++ @typeName(T));
    }

    if (t_info == .void) {
        @compileError("The first argument (T) cannot be 'void'.");
    }

    return union(enum) {
        ok: T,
        err: E,

        const Self = @This();

        pub fn unwrap(self: Self) E!T {
            switch (self) {
                .ok => |value| return value,
                .err => |err| return err,
            }
        }

        pub fn map(self: Self, comptime ReturnType: type, func: anytype) GenericMaybe(ReturnType, E) {
            const OutputContainer = GenericMaybe(ReturnType, E);

            switch (self) {
                .ok => |value| {
                    const transformed = func(value);
                    return OutputContainer{ .ok = transformed };
                },
                .err => |err| return OutputContainer{ .err = err },
            }
        }

        pub fn andThen(self: Self, comptime ReturnType: type, func: anytype) GenericMaybe(ReturnType, E) {
            const OutputContainer = GenericMaybe(ReturnType, E);

            switch (self) {
                .ok => |value| return func(value),
                .err => |err| return OutputContainer{ .err = err },
            }
        }

        pub fn orElse(self: Self, fallback_func: anytype) Self {
            switch (self) {
                .ok => return self,
                .err => |err| return fallback_func(err),
            }
        }

    };
}

test "generic payload and errors" {
    const MathResult = GenericMaybe(u8, MathErrors);
    const NetworkResult = GenericMaybe(f32, NetworkErrors);

    var c = MathResult{ .ok = 42 };

    switch (c) {
        .ok => |*value| value.* += 1,
        .err => |err| std.debug.print("Math error: {}\n", .{err}),
    }

    try expectEqual(@as(u8, 43), c.ok);

    const e = MathResult{ .err = MathErrors.DivisionByZero };
    try expectEqual(MathErrors.DivisionByZero, e.err);

    const net_err = NetworkResult{ .err = NetworkErrors.Timeout };
    try expectEqual(NetworkErrors.Timeout, net_err.err);
}

fn double(val: u8) u16 {
    return @as(u16, val) * 2;
}

test "unwrap and map" {
    const MyResult = GenericMaybe(u8, MathErrors);

    var success = MyResult{ .ok = 21 };
    const failure = MyResult{ .err = MathErrors.Overflow };

    const val = try success.unwrap();
    try expectEqual(@as(u8, 21), val);

    if (failure.unwrap()) |_| {
        @panic("Should have failed!");
    } else |err| {
        try expectEqual(MathErrors.Overflow, err);
    }

    const mapped_result = success.map(u16, double);
    try expectEqual(@as(u16, 42), try mapped_result.unwrap());
}

fn checkedDivideByTwo(val: u8) GenericMaybe(u8, MathErrors) {
    if (val == 0) {
        return GenericMaybe(u8, MathErrors){ .err = MathErrors.DivisionByZero };
    }
    return GenericMaybe(u8, MathErrors){ .ok = val / 2 };
}

test "andThen chaining" {
    const MyResult = GenericMaybe(u8, MathErrors);
    const start = MyResult{ .ok = 40 };
    const final_success = start
        .andThen(u8, checkedDivideByTwo)
        .andThen(u8, checkedDivideByTwo);

    try expectEqual(@as(u8, 10), try final_success.unwrap());

    const start_zero = MyResult{ .ok = 0 };
    const final_failure = start_zero
        .andThen(u8, checkedDivideByTwo)
        .andThen(u8, checkedDivideByTwo);

    if (final_failure.unwrap()) |_| {
        @panic("Should have failed!");
    } else |err| {
        try expectEqual(MathErrors.DivisionByZero, err);
    }
}

fn handleDivisionByZero(err: MathErrors) GenericMaybe(u8, MathErrors) {
    const Container = GenericMaybe(u8, MathErrors);
    switch (err) {
        .DivisionByZero => return Container{ .ok = 0 },
        .Overflow => return Container{ .err = MathErrors.Overflow },
    }
}

test "orElse recovery" {
    const MyResult = GenericMaybe(u8, MathErrors);
    const initial_failure = MyResult{ .err = MathErrors.DivisionByZero };
    const recovered = initial_failure.orElse(handleDivisionByZero);

    try expectEqual(@as(u8, 0), try recovered.unwrap());

    const unrecoverable_failure = MyResult{ .err = MathErrors.Overflow };
    const still_failed = unrecoverable_failure.orElse(handleDivisionByZero);

    if (still_failed.unwrap()) |_| {
        @panic("Should have failed!");
    } else |err| {
        try expectEqual(MathErrors.Overflow, err);
    }

    const fine = MyResult{ .ok = 42 };
    const bypassed = fine.orElse(handleDivisionByZero);

    try expectEqual(@as(u8, 42), try bypassed.unwrap());
}

