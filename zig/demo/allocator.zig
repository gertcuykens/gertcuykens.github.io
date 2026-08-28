const std = @import("std");
const expect = std.testing.expect;

test "page allocator slice" {
    const allocator = std.heap.page_allocator;
    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
    try expect(bytes.len == 100);
    try expect(@TypeOf(bytes) == []u8);
}

test "smp allocator slice" {
    const allocator = std.heap.smp_allocator;
    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
    try expect(bytes.len == 100);
    try expect(@TypeOf(bytes) == []u8);
}

test "smp allocator item" {
    const byte = try std.heap.smp_allocator.create(u8);
    defer std.heap.smp_allocator.destroy(byte);
    byte.* = 128;
}

// free moves pointer
test "bump allocator" {
    var buffer: [1000]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&buffer);
    const allocator = fba.allocator();
    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);
    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

// free no-op
test "arena bump allocator" {
    var arena: std.heap.ArenaAllocator = .init(std.heap.smp_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    _ = try allocator.alloc(u8, 1);
    _ = try allocator.alloc(u8, 10);
    _ = try allocator.alloc(u8, 100);
}

test "debug allocator" {
    var debug: std.heap.DebugAllocator(.{}) = .init;
    const allocator = debug.allocator();
    defer {
        // can't try in defer as defer is executed after we return
        const deinit_status = debug.deinit();
        if (deinit_status == .leak) expect(false) catch @panic("memory leak");
    }
    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
    try expect(bytes.len == 100);
}

test "test allocator" {
    const allocator = std.testing.allocator;
    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
    try expect(bytes.len == 100);
}

test "test resize" {
    const allocator = std.testing.allocator;
    var bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
    if (allocator.resize(bytes, 200)) {
        bytes.len = 200;
    } else {}
}

test "pool allocator" {
    const MySmallStruct = .{};
    const smp_allocor = std.heap.smp_allocator;
    var pool = std.heap.MemoryPool(MySmallStruct).init(smp_allocor);
    const bytes = try pool.alloc(u8, 100);
    defer pool.free(bytes);
    try expect(bytes.len == 100);
}

fn heapPointer(allocator: std.mem.Allocator) !*u8 {
    const ptr = try allocator.create(u8);
    ptr.* = 42;
    return ptr;
}

fn refPointer(ptr: *u8) void {
    ptr.* = 99;
}

// SmpAllocator manages multiple, entirely independent pools of pages based on powers-of-two size tiers (e.g., 16-byte, 32-byte, 64-byte, 128-byte, 256-byte, etc.) up to its small bucket limit.
