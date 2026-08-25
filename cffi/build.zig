// zig fetch --save "git+https://github.com/karlseguin/http.zig#master"
// zig fetch --save "git+https://github.com/karlseguin/pg.zig#master"
// zig fetch --save "git+https://github.com/JagritGumber/clickzig#main"

// zig run --dep options -Mroot=main.zig -Moptions=options.zig
// zig test --dep options -Mroot=main.zig -Moptions=options.zig
// zig build-lib --dep options -Mroot=math.zig -Moptions=options.zig --name gert -target aarch64-macos -lc

// zig build test -Dlog_level=debug --summary all --verbose
// zig build -Dlog_level=debug -Doptimize=Debug

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

    const math = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .root_source_file = b.path("lib/math.zig"),
        // .imports = &.{
        //     .{ .name = "pg", .module = pg_module },
        //     .{ .name = "clickzig", .module = clickzig_module },
        // },
    });

    math.addOptions("options", build_options);

    const lib = b.addLibrary(.{
        .name = "math",
        .root_module = math,
        .use_llvm = true,
        .linkage = .dynamic,
    });

    // b.installArtifact(lib);

    const i = b.addUpdateSourceFiles();
    i.addCopyFileToSource(lib.getEmittedBin(), "gert/_libmath.dylib");
    b.getInstallStep().dependOn(&i.step);

    const t = b.addTest(.{ .name = "test", .root_module = math });
    const a = b.addInstallArtifact(t, .{});

    const r = b.addRunArtifact(t);
    if (b.args) |args| {
        r.addArgs(args);
    }
    const s = b.step("test", "Run tests");
    s.dependOn(&a.step);
    s.dependOn(&r.step);
}
