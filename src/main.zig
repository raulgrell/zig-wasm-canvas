const std = @import("std");
const enums = @import("./enums.zig");

// console API
const Imports = struct {
    extern fn jsConsoleLogWrite(ptr: [*]const u8, len: usize) void;
    extern fn jsConsoleLogFlush() void;
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

// Shaders
extern fn compileShader(source: *const u8, len: c_uint, type: c_uint) c_uint;
extern fn linkShaderProgram(vertexShaderId: c_uint, fragmentShaderId: c_uint) c_uint;

// explicit GL externs
extern fn glEnable(_: c_uint) void;
extern fn glDepthFunc(_: c_uint) void;
extern fn glClear(_: c_uint) void;
extern fn glGetAttribLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
extern fn glGetUniformLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
extern fn glUniform4fv(_: c_int, _: f32, _: f32, _: f32, _: f32) void;
extern fn glCreateBuffer() c_uint;
extern fn glBindBuffer(_: c_uint, _: c_uint) void;
extern fn glBufferData(_: c_uint, _: *const f32, _: c_uint, _: c_uint) void;
extern fn glUseProgram(_: c_uint) void;
extern fn glEnableVertexAttribArray(_: c_uint) void;
extern fn glVertexAttribPointer(_: c_uint, _: c_uint, _: c_uint, _: c_uint, _: c_uint, _: c_uint) void;

// automated GL externs
extern fn clearColor(_: f32, _: f32, _: f32, _: f32) void;
extern fn drawArrays(_: c_uint, _: c_uint, _: c_uint) void;

pub const WebGL2Context = struct {
    clearColor: ?fn (f32, f32, f32, f32) void,
    drawArrays: ?fn (u32, i32, i32) void,

    pub fn init(env: ?*anyopaque) WebGL2Context {
        const gl = @field(env, "gl");
        return WebGL2Context{
            .clearColor = @field(gl, "clearColor"),
            .drawArrays = @field(gl, "drawArrays"),
        };
    }
};

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

var program_id: c_uint = undefined;
var positionAttributeLocation: c_int = undefined;
var offsetUniformLocation: c_int = undefined;
var positionBuffer: c_uint = undefined;

export fn onInit() void {
    Console.log("timestamp: {s}\n", .{"2000-01-01T12:00:00Z"});
    clearColor(0.0, 0.0, 0.0, 1.0);
    glEnable(enums.DEPTH_TEST);
    glDepthFunc(enums.LEQUAL);
    glClear(enums.COLOR_BUFFER_BIT | enums.DEPTH_BUFFER_BIT);

    const vertex_shader_id = compileShader(&vertexShader[0], vertexShader.len, enums.VERTEX_SHADER);
    const fsId = compileShader(&fragmentShader[0], fragmentShader.len, enums.FRAGMENT_SHADER);

    program_id = linkShaderProgram(vertex_shader_id, fsId);

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = glGetAttribLocation(program_id, &a_position[0], a_position.len);
    offsetUniformLocation = glGetUniformLocation(program_id, &u_offset[0], u_offset.len);

    positionBuffer = glCreateBuffer();
    glBindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    glBufferData(enums.ARRAY_BUFFER, &positions[0], 6, enums.STATIC_DRAW);
}

var previous: c_int = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: c_int) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    glClear(enums.COLOR_BUFFER_BIT | enums.DEPTH_BUFFER_BIT);

    glUseProgram(program_id);
    glEnableVertexAttribArray(@intCast(positionAttributeLocation));
    glBindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    glVertexAttribPointer(@intCast(positionAttributeLocation), 2, enums.FLOAT, 0, 0, 0);
    glUniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    drawArrays(enums.TRIANGLES, 0, 3);
    previous = timestamp;
}
