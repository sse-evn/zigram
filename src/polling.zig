// src/polling.zig
const std = @import("std");
const types = @import("types.zig");
const api = @import("api.zig");

pub const Polling = struct {
    api_client: *api.Api,
    offset: i32 = 0,

    pub fn init(api_client: *api.Api) Polling {
        return Polling{ .api_client = api_client };
    }

    pub fn getUpdates(self: *Polling) ![]types.Update {
        const response = try self.api_client.getUpdates(self.offset, null, 30);
        defer self.api_client.http_client.allocator.free(response);

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var updates = std.ArrayList(types.Update).init(allocator);
        // Parse JSON response to get updates
        // Simplified parsing - in real implementation would use proper JSON parser
        updates;
        return updates.toOwnedSlice();
    }
};
