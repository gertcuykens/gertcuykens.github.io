// zig fetch --save "git+https://github.com/karlseguin/http.zig#master"
// zig fetch --save "git+https://github.com/karlseguin/pg.zig#master"
// zig fetch --save "git+https://github.com/JagritGumber/clickzig#main"

// zig run --dep options -Mroot=main.zig -Moptions=options.zig
// zig test --dep options -Mroot=main.zig -Moptions=options.zig --test-filter "hello"
// zig test main.zig --test-filter "hello"

// zig build test -Dlog_level=debug --summary all --verbose
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

    const main = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("main.zig"),
        // .imports = &.{
        //     .{ .name = "pg", .module = pg_module },
        //     .{ .name = "clickzig", .module = clickzig_module },
        // },
    });

    main.addOptions("options", build_options);

    const x = b.addExecutable(.{ .name = "main", .root_module = main, .use_llvm = true });
    b.installArtifact(x);

    // const r = b.addRunArtifact(x);
    // if (b.args) |args| { r.addArgs(args); }
    // const s = b.step("main", "run main")
    // s.dependOn(&r.step);
    // s.dependOn(b.getInstallStep());

    const t = b.addTest(.{ .name = "test", .root_module = main });
    const a = b.addInstallArtifact(t, .{});

    const r = b.addRunArtifact(t);
    if (b.args) |args| {
        r.addArgs(args);
    }
    const s = b.step("test", "Run unit tests");
    s.dependOn(&a.step);
    s.dependOn(&r.step);
}
