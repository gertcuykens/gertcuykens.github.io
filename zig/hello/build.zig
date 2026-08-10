// zig fetch --save "git+https://github.com/karlseguin/http.zig#master"
// zig fetch --save "git+https://github.com/karlseguin/pg.zig#master"
// zig fetch --save "git+https://github.com/JagritGumber/clickzig#main"

// zig run --dep build_config -Mroot=hello.zig -Mbuild_config=config.zig
// zig test hello.zig

// zig build test --summary all --verbose
// zig build -Dlog_level=debug

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const log_level = b.option(
        std.log.Level,
        "log_level",
        "The minimum log level to compile into the application",
    ) orelse .info;
    const build_options = b.addOptions();
    build_options.addOption(std.log.Level, "log_level", log_level);

    // const pg_module = b.dependency("pg", .{}).module("pg");
    // const clickzig_module = b.dependency("clickzig", .{}).module("clickzig");

    const hello = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("hello.zig"),
        // .imports = &.{
        //     .{ .name = "pg", .module = pg_module },
        //     .{ .name = "clickzig", .module = clickzig_module },
        // },
    });

    hello.addOptions("build_config", build_options);

    const x = b.addExecutable(.{ .name = "hello", .root_module = hello, .use_llvm = true });
    b.installArtifact(x);

    // const r = b.addRunArtifact(x);
    // if (b.args) |args| { r.addArgs(args); }
    // const s = b.step("hello", "run hello")
    // s.dependOn(&r.step);
    // s.dependOn(b.getInstallStep());

    const t = b.addTest(.{ .name = "test", .root_module = hello });
    const a = b.addInstallArtifact(t, .{});

    const r = b.addRunArtifact(t);
    if (b.args) |args| {
        r.addArgs(args);
    }
    const s = b.step("test", "Run unit tests");
    s.dependOn(&a.step);
    s.dependOn(&r.step);
}
