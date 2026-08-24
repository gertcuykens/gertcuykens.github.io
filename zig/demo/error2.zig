const std = @import("std");
const expectEqual = std.testing.expectEqual;
const MathErrors = error{ DivisionByZero, Overflow };

fn nativeDivideByTwo(val: u8) MathErrors!u8 {
    if (val == 0) return MathErrors.DivisionByZero;
    return val / 2;
}

fn double(val: u8) u16 {
    return @as(u16, val) * 2;
}

// const value = parseNumber("catch is always used for errors") catch 0;

// const x = try foo();
// const x = foo() catch |err| { return err; };

// var optional: ?u8 = 42;
// if (optional) |*copy| { copy.* += 1;};

test "zig native error and optional handling" {
    const runChain = struct {
        fn go(start: u8) MathErrors!u8 {
            const first = try nativeDivideByTwo(start);
            const second = try nativeDivideByTwo(first);
            return second;
        }
    }.go;

    const success_val = try runChain(40);
    try expectEqual(@as(u8, 10), success_val);

    if (runChain(0)) |_| {
        @panic("Should have failed!");
    } else |err| {
        try expectEqual(MathErrors.DivisionByZero, err);
    }

    const initial_failure = nativeDivideByTwo(0);
    const recovered = initial_failure catch |err| switch (err) {
        MathErrors.DivisionByZero => @as(u8, 0),
        MathErrors.Overflow => return err,
    };

    try expectEqual(@as(u8, 0), recovered);

    var optional_val: ?u8 = 42;
    if (optional_val) |*value| {
        value.* += 1;
    }
    try expectEqual(@as(u8, 43), optional_val.?);

    const null_val: ?u8 = null;
    const final_fallback = null_val orelse 100;
    try expectEqual(@as(u8, 100), final_fallback);
}

const ConfigError = error{ MissingKey, InvalidValue };

fn parseAge(input: []const u8) u8 {
    const age = std.fmt.parseInt(u8, input, 10) catch |err| {
        std.debug.print("Parsing failed with error: {}.\n", .{err});
        return 0;
    };
    return age;
}

fn getFallbackConfig(env: ?[]const u8, file: ?[]const u8) []const u8 {
    return env orelse file orelse "default_localhost";
}

const MockStream = struct {
    bytes: []const u8,
    index: usize = 0,

    fn next(self: *MockStream) ?u8 {
        if (self.index >= self.bytes.len) return null;
        const byte = self.bytes[self.index];
        self.index += 1;
        return byte;
    }
};

test "testing all 3 native patterns" {
    try expectEqual(@as(u8, 25), parseAge("25"));
    try expectEqual(@as(u8, 0), parseAge("not_a_number")); // Safely handled inside parseAge

    const primary: ?[]const u8 = null;
    const secondary: ?[]const u8 = "file_config";
    const final_config = getFallbackConfig(primary, secondary);
    try expectEqual("file_config", final_config);

    const ultimate_fallback = getFallbackConfig(null, null);
    try expectEqual("default_localhost", ultimate_fallback);

    var stream = MockStream{ .bytes = "Zig" };
    var checksum: u32 = 0;

    while (stream.next()) |byte| {
        checksum += byte;
    }

    // 'Z' (90) + 'i' (105) + 'g' (103) = 298
    try expectEqual(@as(u32, 298), checksum);
}

const StreamError = error{
    BadChecksum,
    StreamCorrupted,
};

const ErrorStream = struct {
    bytes: []const u8,
    index: usize = 0,

    fn next(self: *ErrorStream) StreamError!?u8 {
        if (self.index >= self.bytes.len) return null;

        const byte = self.bytes[self.index];
        self.index += 1;

        if (byte == 'X') return StreamError.BadChecksum;

        return byte;
    }
};

const NextByteAction = union(enum) {
    byte: u8,
    skip,
    end,
};

fn nextByteAction(stream: *ErrorStream, error_count: *u32) NextByteAction {
    const maybe_byte = stream.next() catch |err| {
        std.debug.print("Recovered from error: {}\n", .{err});
        error_count.* += 1;
        return .skip;
    };

    return if (maybe_byte) |byte| .{ .byte = byte } else .end;
}

test "while loops with error unions" {
    var stream_clean = ErrorStream{ .bytes = "Zig" };
    var sum_clean: u32 = 0;

    while (try stream_clean.next()) |byte| {
        sum_clean += byte;
    }
    try expectEqual(@as(u32, 298), sum_clean);

    var stream_dirty = ErrorStream{ .bytes = "ZiXg" }; // Contains an error token 'X'
    var sum_dirty: u32 = 0;
    var error_count: u32 = 0;

    while (true) {
        switch (nextByteAction(&stream_dirty, &error_count)) {
            .byte => |byte| sum_dirty += byte,
            .skip => continue,
            .end => break,
        }
    }

    try expectEqual(@as(u32, 1), error_count);
    try expectEqual(@as(u32, 298), sum_dirty); // Successfully added 'Z' + 'i' + 'g' while ignoring 'X'!
}
