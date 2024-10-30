const std = @import("std");
const enums = @import("./enums.zig");
const gl = @import("./gl.zig");

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
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LEQUAL);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    const vertex_shader_id = gl.compileShader(&vertexShader[0], vertexShader.len, enums.VERTEX_SHADER);
    const fsId = gl.compileShader(&fragmentShader[0], fragmentShader.len, enums.FRAGMENT_SHADER);

    program_id = gl.linkShaderProgram(vertex_shader_id, fsId);
    Console.log("program id: {any}\n", .{program_id});

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = gl.getAttribLocation(program_id, &a_position[0], a_position.len);
    offsetUniformLocation = gl.getUniformLocation(program_id, &u_offset[0], u_offset.len);

    positionBuffer = gl.createBuffer();
    gl.bindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(enums.ARRAY_BUFFER, &positions[0], 6, enums.STATIC_DRAW);
}

var previous: i32 = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: i32) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    gl.clear(enums.COLOR_BUFFER_BIT | enums.DEPTH_BUFFER_BIT);

    gl.useProgram(program_id);
    gl.enableVertexAttribArray(@intCast(positionAttributeLocation));
    gl.bindBuffer(enums.ARRAY_BUFFER, positionBuffer);
    gl.vertexAttribPointer(@intCast(positionAttributeLocation), 2, enums.FLOAT, 0, 0, 0);
    gl.uniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    gl.drawArrays(enums.TRIANGLES, 0, 3);
    previous = timestamp;
}
