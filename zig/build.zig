// zig run hello.zig
// zig test error2.zig
// zig fetch --save "git+https://github.com/karlseguin/http.zig#master"
// zig fetch --save "git+https://github.com/karlseguin/pg.zig#master"

// zig build hello
// zig build ... --summary all --verbose

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    ///////////////////////////////////////////////////////////////////////////////////////////////

    const exe1 = b.addExecutable(.{
        .name = "hello",
        .root_module = b.createModule(.{
            .root_source_file = b.path("hello.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe1);

    const run_cmd1 = b.addRunArtifact(exe1);
    run_cmd1.step.dependOn(b.getInstallStep());

    const run_step1 = b.step("hello", "Run the app");
    run_step1.dependOn(&run_cmd1.step);

    ///////////////////////////////////////////////////////////////////////////////////////////////

    const exe2 = b.addExecutable(.{
        .name = "httpd",
        .root_module = b.createModule(.{
            .root_source_file = b.path("httpd.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const dep = b.dependency("httpz", .{
        .target = target,
        .optimize = optimize,
    });
    exe2.root_module.addImport("httpz", dep.module("httpz"));

    b.installArtifact(exe2);

    const run_cmd2 = b.addRunArtifact(exe2);
    run_cmd2.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd2.addArgs(args);
    }

    const run_step = b.step("httpd", "Run HTTP server");
    run_step.dependOn(&run_cmd2.step);

    ///////////////////////////////////////////////////////////////////////////////////////////////
    const pg_module = b.dependency("pg", .{}).module("pg");

    const unit_tests = b.addTest(.{
        .name = "test",
        .root_module = b.createModule(.{
            .root_source_file = b.path("db.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "pg", .module = pg_module },
            },
        }),
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
