/// gl.zig
///
/// Defines the external interface provided by a WebGL2 context passed under the module

// functional interface
pub extern "gl" fn clearColor(f32, f32, f32, f32) void;
pub extern "gl" fn drawArrays(u32, i32, i32) void;
pub extern "gl" fn enable(_: u32) void;
pub extern "gl" fn depthFunc(_: u32) void;
pub extern "gl" fn clear(_: u32) void;
pub extern "gl" fn getAttribLocation(_: c_uint, _: *const u8, _: c_uint) c_int;
pub extern "gl" fn getUniformLocation(_: u32, _: *const u8, _: u32) i32;
pub extern "gl" fn uniform4fv(_: i32, _: f32, _: f32, _: f32, _: f32) void;
pub extern "gl" fn createBuffer() u32;
pub extern "gl" fn bindBuffer(_: u32, _: u32) void;
pub extern "gl" fn bufferData(_: u32, _: *const f32, _: u32, _: u32) void;
pub extern "gl" fn useProgram(_: u32) void;
pub extern "gl" fn enableVertexAttribArray(_: u32) void;
pub extern "gl" fn vertexAttribPointer(_: u32, _: u32, _: u32, _: u32, _: u32, _: u32) void;
pub extern "gl" fn compileShader(_: *const u8, _: u32, _: u32) u32;
pub extern "gl" fn linkShaderProgram(_: u32, _: u32) u32;

// constants / enumerations
pub const DEPTH_TEST: u16 = 0x0B71;
pub const LEQUAL: u16 = 0x0203;
pub const COLOR_BUFFER_BIT: u16 = 0x4000;
pub const DEPTH_BUFFER_BIT: u16 = 0x0100;
pub const VERTEX_SHADER: u16 = 0x8B31;
pub const FRAGMENT_SHADER: u16 = 0x8B30;
pub const ARRAY_BUFFER: u16 = 0x8892;
pub const STATIC_DRAW: u16 = 0x88E4;
pub const FLOAT: u16 = 0x1406;
pub const TRIANGLES: u16 = 0x0004;
