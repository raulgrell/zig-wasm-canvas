//// src/console.zig

const std = @import("std");

// map externs to a symbol for consistent reference
const Console = struct {
    extern "Console" fn log(ptr: [*]const u8, len: usize) void;
};

// zig's internal call will include some formatting support and a string allocation
pub fn log(comptime format: []const u8, args: anytype) void {
    const formatted = std.fmt.allocPrint(std.heap.page_allocator, format, args) catch return;
    defer std.heap.page_allocator.free(formatted);
    Console.log(formatted.ptr, formatted.len);
}
