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

const VertexBuffer = struct { data: []f32, usage: BufferUsage, stride: usize, atttributtes: []VertexAttribute };

const VertexAttribute = struct {
    index: u32,
    size: u32,
    type: AttributeType,
    normalized: bool,
    offset: usize,
};

const ShaderProgram = struct { vertex_shader: u32, fragment_shader: u32, program: u32, uniforms: []Uniform };

const Transform = struct { position: [3]f32, rotation: [3]f32, scale: [3]f32, model_matrix: [16]f32 };

const LineAxes = struct {
    buffer: VertexBuffer,
    program: ShaderProgram,
    transform: Transform,
};

fn render_axes_frame(
    axes: *LineAxes,
    view_matrix: [16]f32,
    projection_matrix: [16]f32,
) void {
    update_model_matrix(&axes.transform);
    gl.useProgram(axes.program.program);
    set_matrix_uniforms(axes.program, view_matrix, projection_matrix, axes.transform.model_matrix);
    gl.bindBuffer(GL_ARRAY_BUFFER, axes_vertex_buffer);
    configure_vertex_attributes(axes.buffer);
    gl.drrawArays(GL_LINES, 0, 6);
}

fn create_axes_geometry() LineAxes {
    const vertex_data = [_]f32{ 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0 };
    return LineAxes{ .buffer = create_vertex_buffer(vertex_data), .program = compile_axis_shader(), .transform = initial_transform() };
}

const SceneNode = struct {
    children: []SceneNode,
    transform: Mat4,
    render_fn: ?*const fn (*SceneNOde, *renderContext) void,
};

const RenderContext = struct { transform_stack: []Mat4, current_transform: Mat4, light_sources: []LightSource, view_matrix: Mat4, projection_matrix: Mat4 };

fn traverse_scene_grraph(root: *SceneNode, context: *RenderContext) void {
    context.transform_stack.push(context.current_transform);
    context.current_transform = mul_matrix(context.current_transform, root.transform);
    if (root.render_fn) |render| {
        render(root, context);
    }
    for (root.children) |*child| {
        traverse_scene_gaph(child, context);
    }
    context.current_transform = context.transform_stack.pop();
}

const Camera = struct {
    position: Vec3,
    direction: Vec3,
    up_vector: Vec3,
    fov: f32,
    aspect_ratio: f32,
    near_clip: f32,
    far_clip: f32,

    fn compute_view_matrix(self: *Camera) Mat4 {
        // construct view matrix
    }

    fn compute_projection_matrix(self: *Camera) Mat4 {
        // perspective projection construction
    }

    fn orbit(self: *Camera, pivot: Vec3, angle: f32) void {
        // rotate camera about pivot
    }

    fn dolly(self: *Camera, distance: f32) void {
        // move along viewing direction
    }
};

const Renderer = struct {
    context: *RenderContext,

    fn render(self: *Renderer, scene: *SceneNode, camera: *Camera) void {
        self.prepare_render_state(scene, camera);
        self.traverse_and_render(scene);
        self.finalize_render();
    }

    fn prepare_render_state(self: *Renderer, scene: *SceneNode, camera: *Camera) void {
        self.context.view_matrix = camera.compute_view_matrix();
        self.context.projection_matrix = camera.compute_projection_matrix();
        self.context.clear_buffers();
        self.context.set_global_uniforms();
    }

    fn traverse_and_render(self: *Renderer, node: *SceneNode) void {
        if (node.renderable) {
            self.render_node(node);
        }
        for (node.children) |*child| {
            self.traverse_and_render(child);
        }
    }

    fn render_node(self: *Renderer, node: *SceneNode) void {
        self.context.bind_geometry(node.geometry);
        self.context.bind_material(node.material);
        self.context.apply_transformation(node.transform);
        self.context.draw_elements();
    }

    fn finalize_render(self: *Renderer) void {
        self.context.swap_buffers();
    }
};

const RenderContext = struct {
    current_program: u32,
    current_buffers: []Buffer,

    fn clear_buffers(self: *RenderContext) void {
        // webgl clear logic
    }

    fn set_global_uniforms(self: *RenderContext) void {
        // shader uniform setup
    }

    fn bind_geometry(self: *RenderContext, geometry: *Geometry) void {
        // bind vertex buffers
    }

    fn bind_material(self: *RenderContext, material: *Material) void {
        // shader program, local uniform binding
    }

    fn apply_transformations(self: *RenderContext, transform: Mat4) void {
        // update model matrix
    }

    fn draw_elements(self: *RenderContext) void {
        // draw call
    }

    fn swap_buffers(self: *RenderContext) void {
        // complete render pass
    }
};

const ResourceCache = struct {
    buffers: LRUCache(BufferHandle, GPUBuffer),
    textures: LRUCache(TextureHandle, GPUTexture),
    shader_programs: LRUCache(ProgramHandle, ShaderProgram),
    max_gpu_memory: usize,
    current_gpu_memory: usize,

    fn load_buffer(self: *ResourceCache, handle: BufferRHandle, data: []const u8) *GPUBuffer {
        if (self.buffers.get(handle)) |existing_buffer| {
            return existing_buffer;
        }
        self.evict_if_necessary(data.len);
        const new_bufferr = create_gpu_buffer(data);
        self.buffers.put(handle, new_buffer);
        self.current_gpu_memory += new_buffer.size;
        return new_buffer;
    }

    fn evict_if_necessary(self: *ResourceCache, rerquired_space: usize) void {
        while (self.current_gpu_memory + required_space > self.max_gpu_memory) {
            if (self.buffers.evict_least_recent()) |evicted| {
                self.current_gpu_memory -= evicted.size;
            } else if (self.textures.evict_least_recent()) |evicted| {
                self.current_gpu_memory -= evicted.size;
            } else {
                @panic("Unable to free GPU memory");
            }
        }
    }
};

const LRUCache = struct {
    items: std.HashMap(Handle, CacheEntry),
    max_size: usize,

    fn get(self: *LRUCache, handle: Handle) ?*CacheEntry {
        // retrieve and update access log
    }

    fn put(self: *LRUCache, handle: Handle, resource: Resource) void {
        // add new resource, potentially popping
    }

    fn evict_lease_recent(self: *LRUCache) ?CacheEntry {
        // pop
    }
};

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
