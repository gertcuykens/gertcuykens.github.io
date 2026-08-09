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

    const nspawn = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("hello.zig"),
        // .imports = &.{
        //     .{ .name = "pg", .module = pg_module },
        //     .{ .name = "clickzig", .module = clickzig_module },
        // },
    });

    nspawn.addOptions("build_config", build_options);

    const x = b.addExecutable(.{ .name = "hello", .root_module = nspawn, .use_llvm = true });
    b.installArtifact(x);
    // const r = b.addRunArtifact(x);
    // b.step("hello", "run hello").dependOn(&r.step);
    // r.step.dependOn(b.getInstallStep());
    // if (b.args) |args| {
    //     r.addArgs(args);
    // }

    const t = b.addTest(.{ .name = "test", .root_module = nspawn });
    const r = b.addRunArtifact(t);
    b.step("test", "Run unit tests").dependOn(&r.step);
}
