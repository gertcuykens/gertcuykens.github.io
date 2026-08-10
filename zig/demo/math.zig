const std = @import("std");

const allocator = std.heap.page_allocator;

export fn alloc(size: usize) ?[*]u8 {
    const buffer = allocator.alloc(u8, size) catch return null;
    return buffer.ptr;
}

export fn free(ptr: [*]u8, size: usize) void {
    const slice = ptr[0..size];
    allocator.free(slice);
}

export fn sumStringChars(ptr: [*]const u8, len: usize) u32 {
    const slice = ptr[0..len];
    var sum: u32 = 0;
    for (slice) |char| {
        sum += char;
    }
    return sum;
}

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

export fn sub(a: i32, b: i32) i32 {
    return a - b;
}
