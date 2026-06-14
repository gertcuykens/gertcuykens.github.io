const std = @import("std");
const zap = @import("zap");

fn onRequest(r: zap.Request) anyerror!void {
    if (r.path) |p| {
        std.debug.print("Incoming request path: {s}\n", .{p});
    }
    try r.sendBody("Hello World from Zap!\n");
}

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 8080,
        .on_request = onRequest,
        .log = true,
        .max_clients = 100000,
    });

    try listener.listen();
    std.debug.print("Zap server listening on http://0.0.0.0\n", .{});

    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
