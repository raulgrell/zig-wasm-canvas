const std = @import("std");
const ConsoleZtl = @import("./ConsoleZtl.zig");
const WebglZtl = @import("./WebglZtl.zig");

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
    \\ gl_FragColor = vec4(0.7, 0.3, 0.0, 1.0);
    \\}
;

const positions: []const f32 = &.{ 0, 0, 0, 0.5, 0.7, 0 };
var shader_program_id: u32 = undefined;
var positionAttributeLocation: i32 = undefined;
var offsetUniformLocation: i32 = undefined;
var positionBuffer: u32 = undefined;

export fn enter() void {
    // these tests must be invoked at runtime to run against the JS translation layer
    //Console.run_api_tests();
    //WebglZtl.run_api_tests();
    ConsoleZtl.log_message("Stating application entrance...", .{});

    // initialize GL API
    WebglZtl.clearColor(0.1, 0.1, 0.1, 1.0);
    WebglZtl.enable(WebglZtl.DEPTH_TEST);
    WebglZtl.depthFunc(WebglZtl.LEQUAL);
    WebglZtl.clear(WebglZtl.COLOR_BUFFER_BIT | WebglZtl.DEPTH_BUFFER_BIT);

    // create and compile vertex shader
    const vertex_shader_id = WebglZtl.createShader(WebglZtl.VERTEX_SHADER);
    WebglZtl.shaderSource(vertex_shader_id, &vertexShader[0], vertexShader.len);
    WebglZtl.compileShader(vertex_shader_id);

    // create and compile fragment shader
    const fragment_shader_id = WebglZtl.createShader(WebglZtl.FRAGMENT_SHADER);
    WebglZtl.shaderSource(fragment_shader_id, &fragmentShader[0], fragmentShader.len);
    WebglZtl.compileShader(fragment_shader_id);

    // create, populate, and link shader program
    shader_program_id = WebglZtl.createProgram();
    WebglZtl.attachShader(shader_program_id, vertex_shader_id);
    WebglZtl.attachShader(shader_program_id, fragment_shader_id);
    WebglZtl.linkProgram(shader_program_id);

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = WebglZtl.getAttribLocation(shader_program_id, &a_position[0], a_position.len);
    offsetUniformLocation = WebglZtl.getUniformLocation(shader_program_id, &u_offset[0], u_offset.len);

    positionBuffer = WebglZtl.createBuffer();
    WebglZtl.bindBuffer(WebglZtl.ARRAY_BUFFER, positionBuffer);
    WebglZtl.bufferData(WebglZtl.ARRAY_BUFFER, &positions[0], 6, WebglZtl.STATIC_DRAW);
    ConsoleZtl.log_message("Finished application entrance!", .{});
}

var previous: i32 = 0;
var x: f32 = 0;

export fn step(timestamp: i32) void {
    //ConsoleZtl.log_message("Starting application timestep...", .{});

    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    WebglZtl.clear(WebglZtl.COLOR_BUFFER_BIT | WebglZtl.DEPTH_BUFFER_BIT);
    WebglZtl.useProgram(shader_program_id);
    WebglZtl.enableVertexAttribArray(@intCast(positionAttributeLocation));
    WebglZtl.bindBuffer(WebglZtl.ARRAY_BUFFER, positionBuffer);
    WebglZtl.vertexAttribPointer(@intCast(positionAttributeLocation), 2, WebglZtl.FLOAT, 0, 0, 0);
    WebglZtl.uniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    WebglZtl.drawArrays(WebglZtl.TRIANGLES, 0, 3);
    previous = timestamp;

    //ConsoleZtl.log_message("Finished application timestep!", .{});
}

export fn exit() void {
    ConsoleZtl.log_message("Starting application exit...", .{});
    // ...
    ConsoleZtl.log_message("Finished application exit!", .{});
}
