# Telegram Bot Library for Zig

A lightweight, modular, and production-ready Telegram Bot API library written entirely in Zig, using only the standard library. No external dependencies.

## Features

- ✅ Full Telegram Bot API support: `sendMessage`, `sendPhoto`, `sendDocument`, `editMessageText`, `answerCallbackQuery`, `getUpdates`
- ✅ Long-polling update handler with event loop
- ✅ Inline and reply keyboards
- ✅ Structured types: `Message`, `Chat`, `User`, `CallbackQuery`, `Update`
- ✅ Custom middleware pipeline for request preprocessing
- ✅ Command router with `/command` handler registration
- ✅ Error handling via Zig’s built-in error types
- ✅ Thread-safe polling loop (single-threaded, non-blocking)
- ✅ Zero external dependencies — uses only `std`

