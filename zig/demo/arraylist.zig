const std = @import("std");

const Context = struct {
    history: std.ArrayList(u8),
    lines: std.ArrayList([]const u8),

    fn parse(ctx: *Context, allocator: std.mem.Allocator, input: []const u8) !void {
        const slice = try ctx.history.addManyAsSlice(allocator, input.len);
        @memcpy(slice, input);
        var it = std.mem.tokenizeScalar(u8, slice, '\n');
        while (it.next()) |line| {
            try ctx.lines.append(allocator, line);
        }
    }
};

test "Context.parse" {
    const input = "I'm first!\n";
    const input_two =
        \\But this text
        \\is juuuuuuuuuuuuuuuuuuuuuuuuust long enough that it
        \\causes a problem!
        \\And the problem could be that we segfault!
        \\Which is no fun to run into.
    ;
    var ctx: Context = .{
        .history = .empty,
        .lines = .empty,
    };
    const gpa = std.testing.allocator;
    defer ctx.history.deinit(gpa);
    defer ctx.lines.deinit(gpa);
    try ctx.parse(gpa, input);
    // ctx.history.lockPointers();
    // defer ctx.history.unlockPointers();
    try ctx.parse(gpa, input_two);
    try std.testing.expectEqualStrings("I'm first!", ctx.lines.items[0]);
}
