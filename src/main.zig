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

    var basePath: [*c]u8 = null;

    var sslConfig: [*c]c.sslConfig_t = null;

    var apiKeys: [*c]c.list_t = null;

    var rc: i64 = c.load_kube_config(&basePath, &sslConfig, &apiKeys, "./configs/kubeconfig");

    if (rc != 0) {
        std.debug.print("Cannot load kubernetes configuration.\n", .{});

        return;
    }

    var apiClient: [*c]c.apiClient_t = null;

    apiClient = c.apiClient_create_with_base_path(basePath, sslConfig, apiKeys);
    if (apiClient == null) {
        std.debug.print("Cannot create a kubernetes client.\n", .{});

        return;
    }

    var genericClient: [*c]c.genericClient_t = null;

    genericClient = c.genericClient_create(apiClient, "apps", "v1", "deployments");

    var list: [*c]u8 = null;

    list = c.Generic_listNamespaced(genericClient, "default");

    std.debug.print("List: {s}\n", .{list});

    c.free(list);

    c.genericClient_free(genericClient);
    c.apiClient_free(apiClient);
    c.free_client_config(basePath, sslConfig, apiKeys);
    c.apiClient_unsetupGlobalEnv();

    std.debug.print("Great success !!!\n", .{});
}
