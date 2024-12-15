const std = @import("std");
const Console = @import("./Console.zig");
const Webgl = @import("./Webgl.zig");

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
    //Webgl.run_api_tests();

    // initialize GL API
    Webgl.clearColor(0.1, 0.1, 0.1, 1.0);
    Webgl.enable(Webgl.DEPTH_TEST);
    Webgl.depthFunc(Webgl.LEQUAL);
    Webgl.clear(Webgl.COLOR_BUFFER_BIT | Webgl.DEPTH_BUFFER_BIT);

    // create and compile vertex shader
    const vertex_shader_id = Webgl.createShader(Webgl.VERTEX_SHADER);
    Webgl.shaderSource(vertex_shader_id, &vertexShader[0], vertexShader.len);
    Webgl.compileShader(vertex_shader_id);

    // create and compile fragment shader
    const fragment_shader_id = Webgl.createShader(Webgl.FRAGMENT_SHADER);
    Webgl.shaderSource(fragment_shader_id, &fragmentShader[0], fragmentShader.len);
    Webgl.compileShader(fragment_shader_id);

    // create, populate, and link shader program
    shader_program_id = Webgl.createProgram();
    Webgl.attachShader(shader_program_id, vertex_shader_id);
    Webgl.attachShader(shader_program_id, fragment_shader_id);
    Webgl.linkProgram(shader_program_id);

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = Webgl.getAttribLocation(shader_program_id, &a_position[0], a_position.len);
    offsetUniformLocation = Webgl.getUniformLocation(shader_program_id, &u_offset[0], u_offset.len);

    positionBuffer = Webgl.createBuffer();
    Webgl.bindBuffer(Webgl.ARRAY_BUFFER, positionBuffer);
    Webgl.bufferData(Webgl.ARRAY_BUFFER, &positions[0], 6, Webgl.STATIC_DRAW);
}

var previous: i32 = 0;
var x: f32 = 0;

export fn step(timestamp: i32) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    Webgl.clear(Webgl.COLOR_BUFFER_BIT | Webgl.DEPTH_BUFFER_BIT);
    Webgl.useProgram(shader_program_id);
    Webgl.enableVertexAttribArray(@intCast(positionAttributeLocation));
    Webgl.bindBuffer(Webgl.ARRAY_BUFFER, positionBuffer);
    Webgl.vertexAttribPointer(@intCast(positionAttributeLocation), 2, Webgl.FLOAT, 0, 0, 0);
    Webgl.uniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    Webgl.drawArrays(Webgl.TRIANGLES, 0, 3);
    previous = timestamp;
}

export fn exit() void {}
