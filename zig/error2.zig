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
        .DivisionByZero => @as(u8, 0),
        .Overflow => return err,
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

// ============================================================================
// 1. Using 'catch' to return safely from an entire function
// ============================================================================
// Instead of crashing or bubbling up an error, you can catch it and safely 
// return an early, valid fallback value from the function block.
fn parseAge(input: []const u8) u8 {
    // If std.fmt.parseInt fails, the catch block executes instantly 
    // and forces an early return from parseAge with a safe default of 0.
    const age = std.fmt.parseInt(u8, input, 10) catch |err| {
        std.debug.print("Parsing failed with error: {}.\n", .{err});
        return 0; 
    };
    return age;
}

// ============================================================================
// 2. Chaining multiple optional values using native 'orelse'
// ============================================================================
// You can chain multiple 'orelse' expressions back-to-back. Zig evaluates 
// them left-to-right, dropping through until it finds the first non-null value.
fn getFallbackConfig(env: ?[]const u8, file: ?[]const u8) []const u8 {
    // 1. Tries 'env'
    // 2. If 'env' is null, falls back to 'file'
    // 3. If 'file' is null, falls back to a hardcoded string literal
    return env orelse file orelse "default_localhost";
}

// ============================================================================
// 3. 'while' loops that unwrap optionals continuously (Stream Reading)
// ============================================================================
// This mock stream simulates an input source (like a file or socket iterator) 
// that returns an optional value (?u8). It yields bytes until it runs dry (null).
const MockStream = struct {
    bytes: []const u8,
    index: usize = 0,

    // Returns a byte (?u8) or null when the stream finishes
    fn next(self: *MockStream) ?u8 {
        if (self.index >= self.bytes.len) return null;
        const byte = self.bytes[self.index];
        self.index += 1;
        return byte;
    }
};

test "testing all 3 native patterns" {
    // --- Test 1: Catch Early Return ---
    try expectEqual(@as(u8, 25), parseAge("25"));
    try expectEqual(@as(u8, 0), parseAge("not_a_number")); // Safely handled inside parseAge

    // --- Test 2: Chaining orelse ---
    const primary: ?[]const u8 = null;
    const secondary: ?[]const u8 = "file_config";
    const final_config = getFallbackConfig(primary, secondary);
    try expectEqual("file_config", final_config);

    const ultimate_fallback = getFallbackConfig(null, null);
    try expectEqual("default_localhost", ultimate_fallback);

    // --- Test 3: While loop optional unwrapping ---
    var stream = MockStream{ .bytes = "Zig" };
    var checksum: u32 = 0;

    // The loop evaluates 'stream.next()'. 
    // If it's a value, it safely unwraps it into 'byte' and executes the body.
    // The moment 'stream.next()' returns null, the loop cleanly terminates.
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

    /// Returns a byte, an error, or null when the stream is exhausted.
    /// The return type is an Error Union of an Optional Type: StreamError!?u8
    fn next(self: *ErrorStream) StreamError!?u8 {
        if (self.index >= self.bytes.len) return null;
        
        const byte = self.bytes[self.index];
        self.index += 1;

        // Simulate encountering a corrupted byte in the stream
        if (byte == 'X') return StreamError.BadChecksum;

        return byte;
    }
};

test "while loops with error unions" {
    // ============================================================================
    // Pattern 1: Bubble up errors immediately (Standard Idiomatic Way)
    // ============================================================================
    // Placing 'try' or letting the while loop natively unpack 'StreamError!?u8'.
    // If an error occurs, the loop instantly aborts and the test fails.
    var stream_clean = ErrorStream{ .bytes = "Zig" };
    var sum_clean: u32 = 0;

    // This loops unwraps the optional '?u8'. If an error is returned by next(),
    // the execution halts and bubbles the error out of the test block.
    while (try stream_clean.next()) |byte| {
        sum_clean += byte;
    }
    try expectEqual(@as(u32, 298), sum_clean);

    // ============================================================================
    // Pattern 2: Intercept and Handle Errors inside the loop (Resilient Stream)
    // ============================================================================
    // If you want the loop to survive the error and keep processing subsequent items,
    // you must use 'catch' on the expression result inside or inline.
    var stream_dirty = ErrorStream{ .bytes = "ZiXg" }; // Contains an error token 'X'
    var sum_dirty: u32 = 0;
    var error_count: u32 = 0;

    // We pull the raw Error Union into the loop condition
    while (stream_dirty.next()) |maybe_byte| {
        // Now we unwrap the error union using 'catch'
        const byte = maybe_byte catch |err| {
            std.debug.print("Recovered from error: {}\n", .{err});
            error_count += 1;
            continue; // Skip this corrupt iteration and continue the loop!
        };

        // If it was null, the 'maybe_byte' wrapper was a success, but containing null.
        // We break manually when the stream signals it is finished.
        if (byte == null) break;

        sum_dirty += byte.?;
    }

    try expectEqual(@as(u32, 1), error_count);
    try expectEqual(@as(u32, 298), sum_dirty); // Successfully added 'Z' + 'i' + 'g' while ignoring 'X'!
}

