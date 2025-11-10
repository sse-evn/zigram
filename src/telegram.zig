// src/telegram.zig
const std = @import("std");
const api_mod = @import("api.zig");
const router_mod = @import("router.zig");
const middleware_mod = @import("middleware.zig");
const polling_mod = @import("polling.zig");
const types = @import("types.zig");

pub const TelegramBot = struct {
    allocator: std.mem.Allocator,
    api: api_mod.Api,
    router: router_mod.Router,
    middleware: middleware_mod.Middleware,
    polling: polling_mod.Polling,

    pub fn init(allocator: std.mem.Allocator, token: []const u8) !TelegramBot {
        var bot = TelegramBot{
            .allocator = allocator,
            .api = try api_mod.Api.init(allocator, token),
            .router = router_mod.Router.init(allocator),
            .middleware = middleware_mod.Middleware.init(allocator),
            .polling = undefined,
        };
        bot.polling = polling_mod.Polling.init(&bot.api);
        return bot;
    }

    pub fn deinit(self: *TelegramBot) void {
        self.router.deinit();
        self.middleware.deinit();
        self.api.deinit();
    }

    pub fn command(self: *TelegramBot, cmd: []const u8, handler: router_mod.HandlerFn) !void {
        try self.router.addCommand(cmd, handler);
    }

    pub fn startPolling(self: *TelegramBot) !void {
        while (true) {
            const updates = try self.polling.getUpdates();
            for (updates) |*update| {
                const processed_update = self.middleware.process(update.*);
                self.router.handleUpdate(&processed_update);
            }
        }
    }

    pub fn sendMessage(self: *TelegramBot, chat_id: i64, text: []const u8, reply_markup: ?[]const u8) ![]u8 {
        return self.api.sendMessage(chat_id, text, reply_markup);
    }

    pub fn sendPhoto(self: *TelegramBot, chat_id: i64, photo: []const u8, caption: ?[]const u8) ![]u8 {
        return self.api.sendPhoto(chat_id, photo, caption);
    }

    pub fn sendDocument(self: *TelegramBot, chat_id: i64, document: []const u8, caption: ?[]const u8) ![]u8 {
        return self.api.sendDocument(chat_id, document, caption);
    }

    pub fn editMessageText(self: *TelegramBot, chat_id: i64, message_id: i32, text: []const u8, reply_markup: ?[]const u8) ![]u8 {
        return self.api.editMessageText(chat_id, message_id, text, reply_markup);
    }

    pub fn answerCallbackQuery(self: *TelegramBot, callback_query_id: []const u8, text: ?[]const u8, show_alert: bool) ![]u8 {
        return self.api.answerCallbackQuery(callback_query_id, text, show_alert);
    }
};
