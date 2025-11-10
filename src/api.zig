// src/api.zig
const std = @import("std");
const client = @import("client.zig");
const types = @import("types.zig");

pub const Api = struct {
    http_client: client.HttpClient,

    pub fn init(allocator: std.mem.Allocator, token: []const u8) !Api {
        return Api{
            .http_client = try client.HttpClient.init(allocator, token),
        };
    }

    pub fn deinit(self: *Api) void {
        self.http_client.deinit();
    }

    pub fn sendMessage(self: *Api, chat_id: i64, text: []const u8, reply_markup: ?[]const u8) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.writer().print("{{\"chat_id\":{},\"text\":\"{s}\",", .{ chat_id, text });
        if (reply_markup) |markup| {
            try json.writer().print("\"reply_markup\":{s}", .{markup});
        } else {
            try json.append('}');
        }

        return self.http_client.makeRequest("sendMessage", json.items);
    }

    pub fn sendPhoto(self: *Api, chat_id: i64, photo: []const u8, caption: ?[]const u8) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.writer().print("{{\"chat_id\":{},\"photo\":\"{s}\",", .{ chat_id, photo });
        if (caption) |cap| {
            try json.writer().print("\"caption\":\"{s}\"}}", .{cap});
        } else {
            try json.append('}');
        }

        return self.http_client.makeRequest("sendPhoto", json.items);
    }

    pub fn sendDocument(self: *Api, chat_id: i64, document: []const u8, caption: ?[]const u8) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.writer().print("{{\"chat_id\":{},\"document\":\"{s}\",", .{ chat_id, document });
        if (caption) |cap| {
            try json.writer().print("\"caption\":\"{s}\"}}", .{cap});
        } else {
            try json.append('}');
        }

        return self.http_client.makeRequest("sendDocument", json.items);
    }

    pub fn editMessageText(self: *Api, chat_id: i64, message_id: i32, text: []const u8, reply_markup: ?[]const u8) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.writer().print("{{\"chat_id\":{},\"message_id\":{},\"text\":\"{s}\",", .{ chat_id, message_id, text });
        if (reply_markup) |markup| {
            try json.writer().print("\"reply_markup\":{s}}}", .{markup});
        } else {
            try json.append('}');
        }

        return self.http_client.makeRequest("editMessageText", json.items);
    }

    pub fn answerCallbackQuery(self: *Api, callback_query_id: []const u8, text: ?[]const u8, show_alert: bool) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.writer().print("{{\"callback_query_id\":\"{s}\",", .{callback_query_id});
        if (text) |t| {
            try json.writer().print("\"text\":\"{s}\",\"show_alert\":{}", .{ t, show_alert });
        } else {
            try json.writer().print("\"show_alert\":{}}}", .{show_alert});
        }

        return self.http_client.makeRequest("answerCallbackQuery", json.items);
    }

    pub fn getUpdates(self: *Api, offset: ?i32, limit: ?i32, timeout: ?i32) ![]u8 {
        var json = std.ArrayList(u8).init(self.http_client.allocator);
        defer json.deinit();

        try json.append('{');
        if (offset) |off| try json.writer().print("\"offset\":{},", .{off});
        if (limit) |lim| try json.writer().print("\"limit\":{},", .{lim});
        if (timeout) |to| try json.writer().print("\"timeout\":{}", .{to});
        try json.append('}');

        return self.http_client.makeRequest("getUpdates", json.items);
    }
};
