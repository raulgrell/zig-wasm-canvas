const std = @import("std");
const enums = @import("./enums.zig");

// console API
const Imports = struct {
    extern "sys" fn jsConsoleLogWrite(ptr: [*]const u8, len: usize) void;
    extern "sys" fn jsConsoleLogFlush() void;
};

pub const Console = struct {
    pub const Logger = struct {
        pub const Error = error{};
        pub const Writer = std.io.Writer(void, Error, write);

        fn write(_: void, bytes: []const u8) Error!usize {
            Imports.jsConsoleLogWrite(bytes.ptr, bytes.len);
            return bytes.len;
        }
    };

    const logger = Logger.Writer{ .context = {} };
    pub fn log(comptime format: []const u8, args: anytype) void {
        logger.print(format, args) catch return;
        Imports.jsConsoleLogFlush();
    }
};

// gl API

const WebGL2API = struct {
    extern fn clearColor(f32, f32, f32, f32) void;
    extern fn drawArrays(u32, i32, i32) void;
    extern fn enable(_: u32) void;
    extern fn depthFunc(_: u32) void;
    extern fn clear(_: u32) void;
    extern fn getAttribLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
    extern fn getUniformLocation(_: u32, _: *const u8, _: u32) i32;
    extern fn uniform4fv(_: i32, _: f32, _: f32, _: f32, _: f32) void;
    extern fn createBuffer() u32;
    extern fn bindBuffer(_: u32, _: u32) void;
    extern fn bufferData(_: u32, _: *const f32, _: u32, _: u32) void;
    extern fn useProgram(_: u32) void;
    extern fn enableVertexAttribArray(_: u32) void;
    extern fn vertexAttribPointer(_: u32, _: u32, _: u32, _: u32, _: u32, _: u32) void;
    extern fn compileShader(source: *const u8, len: u32, type: u32) u32;
    extern fn linkShaderProgram(vertexShaderId: u32, fragmentShaderId: u32) u32;
};

// Shaders

const vertexShader =
    \\attribute vec4 a_position;
    \\uniform vec4 u_offset;
    \\void main() {
    \\  gl_Position = a_position + u_offset;
    \\}
;

const fragmentShader =
    \\precision mediump float;
    \\void main() {
    \\ gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
    \\}
;

const positions: []const f32 = &.{ 0, 0, 0, 0.5, 0.7, 0 };

var program_id: u32 = undefined;
var positionAttributeLocation: i32 = undefined;
var offsetUniformLocation: i32 = undefined;
var positionBuffer: u32 = undefined;

export fn onInit() void {
    Console.log("timestamp: {s}\n", .{"2000-01-01T12:00:00Z"});
    WebGL2API.clearColor(0.0, 0.0, 0.0, 1.0);
    WebGL2API.enable(enums.DEPTH_TEST);
    WebGL2API.depthFunc(enums.LEQUAL);
    WebGL2API.clear(enums.COLOR_BUFFER_BIT | enums.DEPTH_BUFFER_BIT);

    const vertex_shader_id = WebGL2API.compileShader(&vertexShader[0], vertexShader.len, enums.VERTEX_SHADER);
    const fsId = WebGL2API.compileShader(&fragmentShader[0], fragmentShader.len, enums.FRAGMENT_SHADER);

    program_id = WebGL2API.linkShaderProgram(vertex_shader_id, fsId);
    Console.log("program id: {any}\n", .{program_id});

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = WebGL2API.getAttribLocation(program_id, &a_position[0], a_position.len);
    offsetUniformLocation = WebGL2API.getUniformLocation(program_id, &u_offset[0], u_offset.len);

    positionBuffer = WebGL2API.createBuffer();
    WebGL2API.bindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    WebGL2API.bufferData(enums.ARRAY_BUFFER, &positions[0], 6, enums.STATIC_DRAW);
}

var previous: i32 = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: i32) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    WebGL2API.clear(enums.COLOR_BUFFER_BIT | enums.DEPTH_BUFFER_BIT);

    WebGL2API.useProgram(program_id);
    WebGL2API.enableVertexAttribArray(@intCast(positionAttributeLocation));
    WebGL2API.bindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    WebGL2API.vertexAttribPointer(@intCast(positionAttributeLocation), 2, enums.FLOAT, 0, 0, 0);
    WebGL2API.uniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    WebGL2API.drawArrays(enums.TRIANGLES, 0, 3);
    previous = timestamp;
}
