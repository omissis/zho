const std = @import("std");

const c = @cImport({
    // See https://github.com/ziglang/zig/issues/515
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("kube_config.h");
    @cInclude("apiClient.h");
    @cInclude("generic.h");
});

pub fn main() void {
    std.debug.print("ZHO - Zig Hello Operator\n", .{});

    var basePath: [*c]u8 = undefined;

    var sslConfig: [*c]c.sslConfig_t = undefined;

    var apiKeys: [*c]c.list_t = undefined;

    var rc: i64 = c.load_kube_config(&basePath, &sslConfig, &apiKeys, "./configs/kubeconfig");

    if (rc != 0) {
        std.debug.print("Cannot load kubernetes configuration.\n", .{});

        return;
    }

    std.debug.print("basePath: {s}\n", .{basePath});

    std.debug.print("sslConfig.clientCertFile fields: {s}\n", .{sslConfig.*.clientCertFile});
    std.debug.print("sslConfig.clientKeyFile fields: {s}\n", .{sslConfig.*.clientKeyFile});
    std.debug.print("sslConfig.CACertFile fields: {s}\n", .{sslConfig.*.CACertFile});
    std.debug.print("sslConfig.insecureSkipTlsVerify fields: {d}\n", .{sslConfig.*.insecureSkipTlsVerify});

    std.debug.print("apiKeys: {*}\n", .{apiKeys});
    std.debug.print("apiKeys.count: {d}\n", .{apiKeys.*.count});
}
