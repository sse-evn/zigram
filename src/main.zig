// src/main.zig
const std = @import("std");
const telegram = @import("telegram.zig");
const types = @import("types.zig");

fn startHandler(msg: types.Message) void {
    _ = msg;
    std.debug.print("Start command received\n", .{});
}

fn echoHandler(msg: types.Message) void {
    _ = msg;
    std.debug.print("Echo command received\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Example usage of the library
    const token = std.os.getenv("TELEGRAM_BOT_TOKEN") orelse "YOUR_BOT_TOKEN_HERE";
    var bot = try telegram.TelegramBot.init(allocator, token);
    defer bot.deinit();

    try bot.command("/start", startHandler);
    try bot.command("/echo", echoHandler);

    try bot.startPolling();
}
