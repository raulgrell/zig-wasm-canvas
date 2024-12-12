//// src/console.zig

const std = @import("std");

// map externs to a symbol for consistent reference
const Console = struct {
    extern "Console" fn assert(is_expr_true: bool, ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn clear() void;
    extern "Console" fn count(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn countReset(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn debug(ptr: ?[*]const u8, len: usize) void;
    //extern "Console" fn error(ptr: [*]const u8, len: usize) void;
    extern "Console" fn info(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn log(ptr: ?[*]const u8, len: usize) void;
    //extern "Console" fn table() void;
    extern "Console" fn trace() void;
    extern "Console" fn warn(ptr: ?[*]const u8, len: usize) void;
    //extern "Console" fn dir() void;
    //extern "Console" fn dirxml() void;
    extern "Console" fn group(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn groupCollapsed(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn groupEnd() void;
    extern "Console" fn time(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn timeLog(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn timeEnd(ptr: ?[*]const u8, len: usize) void;
    extern "Console" fn exception(ptr: ?[*]const u8, len: usize) void;
    // extern "Console" fn timeStamp(ptr: ?[*]const u8, len: usize) void;
    // extern "Console" fn profile(ptr: ?[*]const u8, len: usize) void;
    // extern "Console" fn profileEnd(ptr: ?[*]const u8, len: usize) void;
};

// zig's internal call will include some formatting support and a string allocation

pub fn assert(is_expr_true: bool) void {
    Console.assert(is_expr_true, null, 0);
}

pub fn assert_message(is_expr_true: bool, comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.assert(is_expr_true, formatted.ptr, formatted.len);
}

pub fn clear() void {
    Console.clear();
}

pub fn count() void {
    Console.count(null, 0);
}

pub fn count_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.count(formatted.ptr, formatted.len);
}

pub fn count_reset() void {
    Console.countReset(null, 0);
}

pub fn count_reset_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.countReset(formatted.ptr, formatted.len);
}

pub fn debug() void {
    Console.debug(null, 0);
}

pub fn debug_message(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.debug(formatted.ptr, formatted.len);
}

pub fn info() void {
    Console.info(null, 0);
}

pub fn info_message(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.info(formatted.ptr, formatted.len);
}

pub fn log() void {
    Console.log(null, 0);
}

pub fn log_message(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.log(formatted.ptr, formatted.len);
}

pub fn trace() void {
    Console.trace();
}

pub fn warn() void {
    Console.warn(null, 0);
}

pub fn warn_message(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.warn(formatted.ptr, formatted.len);
}

pub fn group() void {
    Console.group(null, 0);
}

pub fn group_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.group(formatted.ptr, formatted.len);
}

pub fn group_collapsed() void {
    Console.groupCollapsed(null, 0);
}

pub fn group_collapsed_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.groupCollapsed(formatted.ptr, formatted.len);
}

pub fn group_end() void {
    Console.groupEnd();
}

pub fn time() void {
    Console.time(null, 0);
}

pub fn time_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.time(formatted.ptr, formatted.len);
}

pub fn time_log() void {
    Console.timeLog(null, 0);
}

pub fn time_log_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.timeLog(formatted.ptr, formatted.len);
}

pub fn time_end() void {
    Console.timeEnd(null, 0);
}

pub fn time_end_tag(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.timeEnd(formatted.ptr, formatted.len);
}

pub fn exception() void {
    Console.exception(null, 0);
}

pub fn exception_message(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.exception(formatted.ptr, formatted.len);
}
