// zig run hello.zig
// zig test error2.zig
// zig fetch --save "git+https://github.com/karlseguin/http.zig#master"
// zig fetch --save "git+https://github.com/karlseguin/pg.zig#master"
// zig fetch --save "git+https://github.com/JagritGumber/clickzig#main"

// zig build hello
// zig build ... --summary all --verbose

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const pg_module = b.dependency("pg", .{}).module("pg");
    // const clickzig_module = b.dependency("clickzig", .{}).module("clickzig");

    const nspawn = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("nspawn.zig"),
        // .imports = &.{
        //     .{ .name = "pg", .module = pg_module },
        //     .{ .name = "clickzig", .module = clickzig_module },
        // },
    });

    const exe = b.addExecutable(.{ .name = "nspawm", .root_module = nspawn });
    b.installArtifact(exe);

    // const exe = b.addTest(.{ .name = "test", .root_module = nspawn });
    // const run = b.addRunArtifact(exe);
    // b.step("test", "Run unit tests").dependOn(&run.step);

    // const run = b.addRunArtifact(exe);
    // b.step("nspawn", "run nspawn").dependOn(&run.step);
    // run.step.dependOn(b.getInstallStep());
    // if (b.args) |args| {
    //     run.addArgs(args);
    // }
}
