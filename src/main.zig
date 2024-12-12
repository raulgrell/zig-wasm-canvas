const std = @import("std");
const webgl = @import("./webgl.zig");
const Console = @import("./Console.zig");

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

fn test_console_api() void {
    // Test Console API
    Console.assert(false);
    Console.assert_message(false, "An assertion has failed", .{});
    Console.clear();
    Console.count();
    Console.count_tag("tag", .{});
    Console.count_reset();
    Console.count_reset_tag("tag", .{});
    Console.debug();
    Console.debug_message("this is a {s} message", .{"debug"});
    Console.info();
    Console.info_message("this is a {s} message", .{"info"});
    Console.log();
    Console.log_message("timestamp: {s}", .{"2000-01-01T12:00:00Z"});
    Console.trace();
    Console.warn();
    Console.warn_message("this is a {s} message", .{"warning"});
    Console.group();
    Console.group_tag("tag", .{});
    Console.group_collapsed();
    Console.group_collapsed_tag("tag", .{});
    Console.group_end();
    Console.group_end();
    Console.group_end();
    Console.group_end();
    Console.time();
    Console.time_tag("tag", .{});
    Console.time_log();
    Console.time_log_tag("tag", .{});
    Console.time_end();
    Console.time_end_tag("tag", .{});
    Console.exception();
    Console.exception_message("this is a {s} message", .{"error"});
}

export fn onInit() void {
    // these tests must be invoked at runtime to run against the JS translation layer
    test_console_api();

    // initialize GL API
    webgl.clearColor(0.1, 0.1, 0.1, 1.0);
    webgl.enable(webgl.DEPTH_TEST);
    webgl.depthFunc(webgl.LEQUAL);
    webgl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);

    // create and compile vertex shader
    const vertex_shader_id = webgl.createShader(webgl.VERTEX_SHADER);
    webgl.shaderSource(vertex_shader_id, &vertexShader[0], vertexShader.len);
    webgl.compileShader(vertex_shader_id);

    // create and compile fragment shader
    const fragment_shader_id = webgl.createShader(webgl.FRAGMENT_SHADER);
    webgl.shaderSource(fragment_shader_id, &fragmentShader[0], fragmentShader.len);
    webgl.compileShader(fragment_shader_id);

    // create, populate, and link shader program
    shader_program_id = webgl.createProgram();
    webgl.attachShader(shader_program_id, vertex_shader_id);
    webgl.attachShader(shader_program_id, fragment_shader_id);
    webgl.linkProgram(shader_program_id);

    const a_position = "a_position";
    const u_offset = "u_offset";

    positionAttributeLocation = webgl.getAttribLocation(shader_program_id, &a_position[0], a_position.len);
    offsetUniformLocation = webgl.getUniformLocation(shader_program_id, &u_offset[0], u_offset.len);

    positionBuffer = webgl.createBuffer();
    webgl.bindBuffer(webgl.ARRAY_BUFFER, positionBuffer);
    webgl.bufferData(webgl.ARRAY_BUFFER, &positions[0], 6, webgl.STATIC_DRAW);
}

var previous: i32 = 0;
var x: f32 = 0;

export fn onAnimationFrame(timestamp: i32) void {
    const delta = if (previous > 0) timestamp - previous else 0;
    x += @as(f32, @floatFromInt(delta)) / 1000.0;
    if (x > 1) x = -2;

    webgl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);

    webgl.useProgram(shader_program_id);
    webgl.enableVertexAttribArray(@intCast(positionAttributeLocation));
    webgl.bindBuffer(webgl.ARRAY_BUFFER, positionBuffer);
    webgl.vertexAttribPointer(@intCast(positionAttributeLocation), 2, webgl.FLOAT, 0, 0, 0);
    webgl.uniform4fv(offsetUniformLocation, x, 0.0, 0.0, 0.0);
    webgl.drawArrays(webgl.TRIANGLES, 0, 3);
    previous = timestamp;
}
