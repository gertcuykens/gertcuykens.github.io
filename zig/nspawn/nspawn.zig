const std = @import("std");

// extern var environ: [*:null]?[*:0]const u8;
// extern fn prctl(option: c_int, arg2: c_ulong, arg3: c_ulong, arg4: c_ulong, arg5: c_ulong) c_int;
// extern fn setuid(uid: std.os.linux.uid_t) c_int;
// extern fn setgid(gid: std.os.linux.gid_t) c_int;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 3) {
        std.log.err("Usage: {s} <machine-name> <module>\n", .{args[0]});
        return error.MissingArgument;
    }

    var machine_buf: [256]u8 = undefined;
    const machine_arg = try std.fmt.bufPrintZ(&machine_buf, "--machine={s}", .{args[1]});
    const module_arg = args[2];

    const cmd_argv = [_][:0]const u8{
        "/usr/bin/systemd-nspawn",
        machine_arg,
        "--user=odoo",
        "/usr/bin/odoo",
        "-c",
        "/etc/odoo/odoo.conf",
        "-u",
        module_arg,
        "--no-http",
        "--workers=0",
        "--stop-after-init",
    };

    var argv_ptrs: [cmd_argv.len + 1:null]?[*:0]const u8 = undefined;
    for (cmd_argv, 0..) |arg, i| {
        argv_ptrs[i] = arg.ptr;
    }
    argv_ptrs[cmd_argv.len] = null;

    const PR_SET_KEEPCAPS: c_int = 8;
    const PR_CAP_AMBIENT: c_int = 47;
    const PR_CAP_AMB_RAISE: c_ulong = 2;
    const CAP_SYS_ADMIN: c_ulong = 21;
    const CAP_NET_ADMIN: c_ulong = 12;
    const zero: c_ulong = 0;
    const one: c_ulong = 1;

    _ = std.c.prctl(PR_SET_KEEPCAPS, one, zero, zero, zero);
    _ = std.c.setgid(0);
    _ = std.c.setuid(0);
    _ = std.c.prctl(PR_CAP_AMBIENT, PR_CAP_AMB_RAISE, CAP_SYS_ADMIN, zero, zero);
    _ = std.c.prctl(PR_CAP_AMBIENT, PR_CAP_AMB_RAISE, CAP_NET_ADMIN, zero, zero);
    _ = std.c.execve(cmd_argv[0].ptr, &argv_ptrs, @ptrCast(std.c.environ));

    // const PR_SET_KEEPCAPS = 8;
    // const PR_CAP_AMBIENT = 47;
    // const PR_CAP_AMB_RAISE = 2;
    // const CAP_SYS_ADMIN = 21;
    // const CAP_NET_ADMIN = 12;

    // const PR_SET_KEEPCAPS = 8;
    // const PR_CAP_AMB_RAISE = 43;
    // const CAP_SYS_ADMIN = 21;
    // const CAP_NET_ADMIN = 12;

    // _ = prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0);
    // _ = std.c.setgid(0);
    // _ = std.c.setuid(0);
    // _ = prctl(47, PR_CAP_AMB_RAISE, CAP_SYS_ADMIN, 0, 0);
    // _ = prctl(47, PR_CAP_AMB_RAISE, CAP_NET_ADMIN, 0, 0);
    // _ = std.c.execve(cmd_argv[0].ptr, &argv_ptrs, @ptrCast(std.c.environ));

    std.log.err("Execution failed with errno: {}\n", .{std.c._errno().*});
    return error.ExecutionFailed;
}
// setcap cap_sys_admin,cap_net_admin+eip /usr/local/bin/nspawm
// getcap /usr/local/bin/nspawm
// chmod 4755
