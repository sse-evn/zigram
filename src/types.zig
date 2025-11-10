// src/types.zig
const std = @import("std");

pub const User = struct {
    id: i64,
    is_bot: bool,
    first_name: []const u8,
    last_name: ?[]const u8 = null,
    username: ?[]const u8 = null,
    language_code: ?[]const u8 = null,

    pub fn deinit(self: *User, allocator: std.mem.Allocator) void {
        allocator.free(self.first_name);
        if (self.last_name) |name| allocator.free(name);
        if (self.username) |name| allocator.free(name);
        if (self.language_code) |code| allocator.free(code);
    }
};

pub const Chat = struct {
    id: i64,
    type: []const u8,
    title: ?[]const u8 = null,
    username: ?[]const u8 = null,
    first_name: ?[]const u8 = null,
    last_name: ?[]const u8 = null,

    pub fn deinit(self: *Chat, allocator: std.mem.Allocator) void {
        allocator.free(self.type);
        if (self.title) |title| allocator.free(title);
        if (self.username) |username| allocator.free(username);
        if (self.first_name) |name| allocator.free(name);
        if (self.last_name) |name| allocator.free(name);
    }
};

pub const Message = struct {
    message_id: i32,
    from: ?*User = null,
    chat: *Chat,
    date: i32,
    text: ?[]const u8 = null,
    caption: ?[]const u8 = null,

    pub fn deinit(self: *Message, allocator: std.mem.Allocator) void {
        if (self.from) |user| {
            user.deinit(allocator);
            allocator.destroy(user);
        }
        self.chat.deinit(allocator);
        allocator.destroy(self.chat);
        if (self.text) |txt| allocator.free(txt);
        if (self.caption) |cap| allocator.free(cap);
    }
};

pub const CallbackQuery = struct {
    id: []const u8,
    from: *User,
    message: ?*Message = null,
    data: []const u8,

    pub fn deinit(self: *CallbackQuery, allocator: std.mem.Allocator) void {
        allocator.free(self.id);
        self.from.deinit(allocator);
        allocator.destroy(self.from);
        if (self.message) |msg| {
            msg.deinit(allocator);
            allocator.destroy(msg);
        }
        allocator.free(self.data);
    }
};

pub const InlineKeyboardButton = struct {
    text: []const u8,
    callback_data: ?[]const u8 = null,
    url: ?[]const u8 = null,
};

pub const ReplyKeyboardMarkup = struct {
    keyboard: [][]const InlineKeyboardButton,
    resize_keyboard: bool = true,
    one_time_keyboard: bool = false,
};

pub const InlineKeyboardMarkup = struct {
    inline_keyboard: [][]const InlineKeyboardButton,
};

pub const Update = struct {
    update_id: i32,
    message: ?*Message = null,
    edited_message: ?*Message = null,
    callback_query: ?*CallbackQuery = null,

    pub fn deinit(self: *Update, allocator: std.mem.Allocator) void {
        if (self.message) |msg| {
            msg.deinit(allocator);
            allocator.destroy(msg);
        }
        if (self.edited_message) |msg| {
            msg.deinit(allocator);
            allocator.destroy(msg);
        }
        if (self.callback_query) |query| {
            query.deinit(allocator);
            allocator.destroy(query);
        }
    }
};

pub const ApiResponse = struct {
    ok: bool,
    result: ?[]u8 = null,
    description: ?[]u8 = null,

    pub fn deinit(self: *ApiResponse, allocator: std.mem.Allocator) void {
        if (self.result) |res| allocator.free(res);
        if (self.description) |desc| allocator.free(desc);
    }
};
