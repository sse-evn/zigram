// src/middleware.zig
const std = @import("std");
const types = @import("types.zig");

pub const MiddlewareFn = *const fn (types.Update, *anyopaque) types.Update;

pub const Middleware = struct {
    allocator: std.mem.Allocator,
    middlewares: std.ArrayList(MiddlewareFn),

    pub fn init(allocator: std.mem.Allocator) Middleware {
        return Middleware{
            .allocator = allocator,
            .middlewares = std.ArrayList(MiddlewareFn).init(allocator),
        };
    }

    pub fn deinit(self: *Middleware) void {
        self.middlewares.deinit();
    }

    pub fn add(self: *Middleware, middleware: MiddlewareFn) !void {
        try self.middlewares.append(middleware);
    }

    pub fn process(self: *Middleware, update: types.Update) types.Update {
        var current_update = update;
        for (self.middlewares.items) |mw| {
            current_update = mw(current_update, null);
        }
        return current_update;
    }
};
