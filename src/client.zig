// src/client.zig
const std = @import("std");
const types = @import("types.zig");

pub const HttpClient = struct {
    allocator: std.mem.Allocator,
    token: []const u8,
    url: []const u8,

    pub fn init(allocator: std.mem.Allocator, token: []const u8) !HttpClient {
        const url = try std.fmt.allocPrint(allocator, "https://api.telegram.org/bot{s}/", .{token});
        return HttpClient{
            .allocator = allocator,
            .token = try allocator.dupe(u8, token),
            .url = url,
        };
    }

    pub fn deinit(self: *HttpClient) void {
        self.allocator.free(self.token);
        self.allocator.free(self.url);
    }

    pub fn makeRequest(self: *HttpClient, method: []const u8, params: []const u8) ![]u8 {
        var server = std.net.Address.parseIp("api.telegram.org", 443) catch unreachable;
        var stream = try server.connect();
        defer stream.close();

        const request = try std.fmt.allocPrint(self.allocator,
            \\POST /bot{s}{s} HTTP/1.1
            \\Host: api.telegram.org
            \\Content-Type: application/json
            \\Content-Length: {d}
            \\
            \\{s}
        , .{ self.token, method, params.len, params });

        try stream.writer().writeAll(request);

        var response_buffer: [4096]u8 = undefined;
        var response = std.ArrayList(u8).init(self.allocator);
        defer response.deinit();

        while (true) {
            const n = try stream.read(&response_buffer);
            if (n == 0) break;
            try response.appendSlice(response_buffer[0..n]);
        }

        const response_str = response.items;
        const body_start = std.mem.indexOf(u8, response_str, "\r\n\r\n") orelse return error.InvalidResponse;
        return self.allocator.dupe(u8, response_str[body_start + 4 ..]);
    }
};
