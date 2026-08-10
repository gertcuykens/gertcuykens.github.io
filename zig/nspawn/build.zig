const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const nspawn = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("nspawn.zig"),
    });

    const exe = b.addExecutable(.{ .name = "nspawn", .root_module = nspawn, .use_llvm = true });
    b.installArtifact(exe);
}
