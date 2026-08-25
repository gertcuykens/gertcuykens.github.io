const std = @import("std");

pub const std_options: std.Options = .{
    .log_level = @enumFromInt(@intFromEnum(@import("options").log_level)),
    // .logFn = @import("options").myCustomLogFn,
};

pub const Point = extern struct {
    x: i32,
    y: i32,
};

pub export fn move_point(point: *Point, dx: i32, dy: i32) void {
    point.x += dx;
    point.y += dy;
}

pub export fn sum_array(numbers: [*]const i32, length: usize) i32 {
    var total: i32 = 0;
    var i: usize = 0;
    while (i < length) : (i += 1) {
        total += numbers[i];
    }
    return total;
}

export fn multiply_array(data_ptr: [*]f64, length: usize, factor: f64) void {
    const data = data_ptr[0..length];
    for (data) |*value| {
        value.* *= factor;
    }
}

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "add" {
    try std.testing.expectEqual(add(5, 3), 8);
}

export fn count_vowels(c_str: [*:0]const u8) i32 {
    const zig_str = std.mem.span(c_str);
    var count: i32 = 0;
    for (zig_str) |char| {
        switch (char) {
            'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U' => count += 1,
            else => {},
        }
    }
    return count;
}

export fn uppercase_string(input_ptr: [*:0]const u8, output_ptr: [*]u8) void {
    const input = std.mem.span(input_ptr);
    for (input, 0..) |char, i| {
        output_ptr[i] = std.ascii.toUpper(char);
    }
    output_ptr[input.len] = 0;
}
