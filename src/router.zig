// src/router.zig
const std = @import("std");
const types = @import("types.zig");

pub const HandlerFn = *const fn (types.Message) void;

pub const Router = struct {
    allocator: std.mem.Allocator,
    commands: std.StringHashMap(HandlerFn),

    pub fn init(allocator: std.mem.Allocator) Router {
        return Router{
            .allocator = allocator,
            .commands = std.StringHashMap(HandlerFn).init(allocator),
        };
    }

    pub fn deinit(self: *Router) void {
        self.commands.deinit();
    }

    pub fn addCommand(self: *Router, command: []const u8, handler: HandlerFn) !void {
        try self.commands.put(try self.allocator.dupe(u8, command), handler);
    }

    pub fn handleUpdate(self: *Router, update: *types.Update) void {
        if (update.message) |msg| {
            if (msg.text) |text| {
                if (std.mem.startsWith(u8, text, "/")) {
                    const end = std.mem.indexOf(u8, text, " ") orelse text.len;
                    const cmd = text[0..end];
                    if (self.commands.get(cmd)) |handler| {
                        handler(msg.*);
                    }
                }
            }
        }
    }
};
