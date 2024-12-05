/// webgl.zig
///
/// Defines the external interface provided by a WebGL2 context passed under the module
///
/// Type conversion cheat sheet:
/// * Glclampf -> f32
/// * Glenum -> u32
/// * Glint -> i32 | c_uint
/// * Glsizei -> i3c20
/// * Glbitfield -> u32
/// * WebGLProgram -> c_uint
/// * String -> *const u8, c_uint (e.g., location and length of u8 array in memory buffer)
/// * WebGLUniformLocation -> i32
/// * WebGLBuffer -> u32
/// * Glsizeiptr -> *const f32, u32
/// * Gluint -> u32
/// * Glboolean -> u32
/// * Glintptr -> u32
///
/// "Object" (handle) types must persist as references in the Javascript
/// translation layer, which we have configured here to pass back u32 handles
/// (indices to an object cache) instead. From Zig's perspective, those u32
/// values are used in place of the object references. One exception is,
/// uniform and other variable locations, which are also mapped to strings
/// against specific shader modules. See `index.mjs` for more details.

// WebGLRenderingContext - Context
// getContextAttributes()		WebGLContextAttributes	The WebGLRenderingContext.getContextAttributes() method returns a WebGLContextAttributes object that contains the actual context parameters. Might return null, if the context is lost.
// isContextLost()		bool	The WebGLRenderingContext.isContextLost() method returns a boolean value indicating whether or not the WebGL context has been lost and must be re-established before rendering can resume.
// makeXRCompatible()		Promise	The WebGLRenderingContext method makeXRCompatible() ensures that the rendering context described by the WebGLRenderingContext is ready to render the scene for the immersive WebXR device on which it will be displayed. If necessary, the WebGL layer may reconfigure the context to be ready to render to a different device than it originally was.

// WebGLRenderingContext - Viewing and clipping
// scissor()	(Glint, Glint, Glsizei, Glsizei)		The WebGLRenderingContext.scissor() method of the WebGL API sets a scissor box, which limits the drawing to a specified rectangle.
// viewport()	(Glint, Glint, Glsizei, Glsizei)		The WebGLRenderingContext.viewport() method of the WebGL API sets the viewport, which specifies the affine transformation of x and y from normalized device coordinates to window coordinates.

// WebGLRenderingContext - State informration
// activeTexture()	(gl.TEXTUREi)		Selects the active texture unit.
// blendColor()	(Glclampf, Glclampf, Glclampf, Glclampf)		Sets the source and destination blending factors.
// blendEquation()	(Glenum)		Sets both the RGB blend equation and alpha blend equation to a single equation.
// blendEquationSeparate()	(Glenum, Glenum)		Sets the RGB blend equation and alpha blend equation separately.
// blendFunc()	(Glenum, Glenum)		Defines which function is used for blending pixel arithmetic.
// blendFuncSeparate()	(Glenum, Glenum, Glenum, Glenum)		Defines which function is used for blending pixel arithmetic for RGB and alpha components separately.
pub extern "gl" fn clearColor(f32, f32, f32, f32) void; // Specifies the color values used when clearing color buffers.
// clearDepth()	(Glclampf)		Specifies the depth value used when clearing the depth buffer.
// clearStencil()	(Glint)		Specifies the stencil value used when clearing the stencil buffer.
// colorMask()	(Glboolean, Glboolean, Glboolean, Glboolean)		Sets which color components to enable or to disable when drawing or rendering to a WebGLFramebuffer.
// cullFace()	(Glenum)		Specifies whether or not front- and/or back-facing polygons can be culled.
pub extern "gl" fn depthFunc(u32) void; // Specifies a function that compares incoming pixel depth to the current depth buffer value.
// depthMask()	(Glboolean)		Sets whether writing into the depth buffer is enabled or disabled.
// depthRange()	(Glclampf, Glclampf)		Specifies the depth range mapping from normalized device coordinates to window or viewport coordinates.
// disable()	(Glenum)		Disables specific WebGL capabilities for this context.
pub extern "gl" fn enable(u32) void; // Enables specific WebGL capabilities for this context.
// frontFace()	(Glenum)		Specifies whether polygons are front- or back-facing by setting a winding orientation.
// getParameter()	(Glenum)	(depends on parameter)	Returns a value for the passed parameter name.
// getError()		Glenum	Returns error information.
// hint()	(Glenum, Glenum)		Specifies hints for certain behaviors. The interpretation of these hints depend on the implementation.
// isEnabled()	(Glenum)	Glboolean	Tests whether a specific WebGL capability is enabled or not for this context.
// lineWidth()	(Glfloat)		Sets the line width of rasterized lines.
// pixelStorei()	(Glnum, Glint)		Specifies the pixel storage modes
// polygonOffset()	(Glfloat, Glfloat)		Specifies the scale factors and units to calculate depth values.
// sampleCoverage()	(Glclampf, Glboolean)		Specifies multi-sample coverage parameters for anti-aliasing effects.
// stencilFunction()	(Glenum, Glint, Gluint)		Sets the both front and back function and reference value for stencil testing.
// stencilFuncSeparate()	(Glenum, Glenum, Glint, Gluint)		Sets the front and/or back function and reference value for stencil testing.
// stencilMask()	(Gluint)		Controls enabling and disabling of both the front and back writing of individual bits in the stencil planes.
// stencilMaskSeparate()	(Glenum, Gluint)		Controls enabling and disabling of front and/or back writing of individual bits in the stencil planes.
// stencilOp()	(Glenum, Glenum, Glenum)		Sets both the front and back-facing stencil test actions.
// stencilOpSeparate()	(Glenum, Glenum, Glenum, Glenum)		Sets the front and/or back-facing stencil test actions.

// WebGLRenderingContext - Buffers
pub extern "gl" fn bindBuffer(u32, u32) void; // Binds a WebGLBuffer object to a given target.
pub extern "gl" fn bufferData(u32, *const f32, u32, u32) void; // Updates buffer data.
// bufferSubData()	(Glenum, Glintptr)		Updates buffer data starting at a passed offset.
pub extern "gl" fn createBuffer() u32; // 		WebGLBuffer	Creates a WebGLBuffer object.
// deleteBuffer()	(WebGLBuffer)		Deletes a WebGLBuffer object.
// getBufferParameter()	(Gleneum, Glenum)	(depends on parameter)	Returns information about the buffer.
// isBuffer()	(WebGLBuffer)	GLboolean	Returns a Boolean indicating if the passed buffer is valid.

// WebGLRenderingContext - Framebuffers
// bindFramebuffer()	(Glenum, WebGLFramebuffer)		Binds a WebGLFrameBuffer object to a given target.
// checkFramebufferStatus()	(Glenum)	GLenum	Returns the status of the framebuffer.
// createFramebuffer()		WebGLFramebuffer	Creates a WebGLFrameBuffer object.
// deleteFramebuffer()	(WebGLFramebuffer)		Deletes a WebGLFrameBuffer object.
// framebufferRenderbuffer()	(GLenum, Glenum, Glenum, WebGLRenderbuffer)		Attaches a WebGLRenderingBuffer object to a WebGLFrameBuffer object.
// framebufferTexture2D()	(Glenum, Glenum, Glenum, WebGLTexture, Glint)		Attaches a textures image to a WebGLFrameBuffer object.
// getFramebufferAttachmentParameter()	(Glenum, Glenum, Glenum)	(depends on parameter)	Returns information about the framebuffer.
// isFramebuffer()	(WebGLFramebuffer)	GLboolean	Returns a Boolean indicating if the passed WebGLFrameBuffer object is valid.
// readPixels()	(Glint, Glint, Glsizei, Glsizei, Glenum, Glnum, *Array, Gluint)		Reads a block of pixels from the WebGLFrameBuffer.

// WebGLRenderingContext - Renderbuffers
// bindRenderbuffer()	(Glenum, WebGLRenderbuffer)		Binds a WebGLRenderBuffer object to a given target.
// createRenderbuffer()		WebGLRenderbuffer	Creates a WebGLRenderBuffer object.
// deleteRenderbuffer()	(WebGLRenderbuffer)		Deletes a WebGLRenderBuffer object.
// getRenderbufferParameter()	(Glenum, Glenum)	(depends on parameter)	Returns information about the renderbuffer.
// isRenderbuffer()	(WebGLRenderbuffer)	GLboolean	Returns a Boolean indicating if the passed WebGLRenderingBuffer is valid.
// renderbufferStorage()	(Glenum, Glenum, Glsizei, Glsizei)		Creates a renderbuffer data store.

// WebGLRenderingContext - Textures
// bindTexture()	(Glenum, WebGLTexture)		Binds a WebGLTexture object to a given target.
// compressedTexImage2D()	(Glenum, Glint, Glenum, Glsizei, Glsizei, Glsizei, Glint, Glsizei, Glintptr, *Array)		Specifies a 2D texture image in a compressed format.
// compressedTexSubImage2D()	(Glenum, Glint, Glint, Glint, Glsizei, Glsizei, Glenum, Glsizei, Glintptr, *Array)		Specifies a 2D texture sub-image in a compressed format.
// copyTexImage2D()	(Glenum, Glint, Glenum, Glint, Glint, Glsizei, Glsizei, Glint)		Copies a 2D texture image.
// copyTexSubImage2D()	(Glenum, Glint, Glint, Glint, Glint, Glint, Glsizei, Glsizei)		Copies a 2D texture sub-image.
// createTexture()		WebGLTexture	Creates a WebGLTexture object.
// deleteTexture()	(WebGLTexture)		Deletes a WebGLTexture object.
// generateMipmap()	(Glenum)		Generates a set of mipmaps for a WebGLTexture object.
// getTexParameter()	(Glenum, Glenum)		Returns information about the texture.
// isTexture()	(WebGLTexture)	Glboolean	Returns a Boolean indicating if the passed WebGLTexture is valid.
// texImage2D()	(Glenum, Glint, Glenum, Glsizei, Glsizei, Glint, Glenum, Glenum, *ImageElement*, Glintptr)		Specifies a 2D texture image.
// texSubImage2d()	(Glenum, Glint, Glint, Glint, Glsizei, Glsizei, Glenum, Glenum, *Array, Glintptr)		Updates a sub-rectangle of the current WebGLTexture.
// texParameterf()	(Glenum, Glfloat, Glenum)		Sets texture parameters.
// texParameteri()	(Glenum, Glint, Glenum)		Sets texture parameters.

// WebGLRenderingContext - Programs and shaders
pub extern "gl" fn attachShader(u32, u32) void; // Attaches, to a given WebGLProgram, a given WebGLShader
// bindAttribLocation()	(WebGLProgram, Gluint, String)		Binds a generic vertex index to a named attribute variable.
pub extern "gl" fn compileShader(u32) void; // Compiles a WebGLShader.
pub extern "gl" fn createProgram() u32; // Creates a WebGLProgram.
pub extern "gl" fn createShader(u32) u32; // Creates a WebGLShader (of the given type).
// deleteProgram()	(WebGLProgram)		Deletes a WebGLProgram.
// deleteShader()	(WebGLShader)		Deletes a WebGLShader.
// detachShader()	(WebGLProgram, WebGLShader)		Detaches a WebGLShader.
// getAttachedShaders()	(WebGLProgram)	[WebGLShader]	Returns a list of WebGLShader objects attached to a WebGLProgram.
// getProgramParameter()	(WebGLProgram, Glenum)	(depends on parameter)	Returns information about the program.
// getProgramInfoLog()	(WebGLProgram)	String	Returns the information log for a WebGLProgram object.
// getShaderParameter()	(WebGLShader, Glenum)	(depends on parameter)	Returns information about the shader.
// getShaderPrecisionFormat()	(Glenum, Glenum)	WebGLShaderPrecisionFormat	Returns a WebGLShaderPrecisionFormat object describing the precision for the numeric format of the shader.
// getShaderInfoLog()	(WebGLShader)	String	Returns the information log for a WebGLShader object.
// getShaderSource()	(WebGLShader)	String	Returns the source code of a WebGLShader as a string.
// isProgram()	(WebGLProgram)	GLboolean	Returns a Boolean indicating if the passed WebGLProgram is valid.
// isShader()	(WebGLShader)	GLboolean	Returns a Boolean indicating if the passed WebGLShader is valid.
pub extern "gl" fn linkProgram(u32) void; // Links the passed WebGLProgram object.
pub extern "gl" fn shaderSource(u32, *const u8, u32) void; // Sets the source code in a WebGLShader.
pub extern "gl" fn useProgram(u32) void; // Uses the specified WebGLProgram as part the current rendering state.
// validateProgram()	(WebGLProgram)		Validates a WebGLProgram.

// WebGLRenderingContext - Uniforms and attributes
// disableVertexAttribArray()	(Gluint)		Disables a vertex attribute array at a given position.
pub extern "gl" fn enableVertexAttribArray(u32) void; // Enables a vertex attribute array at a given position.
// getActiveAttrib()	(WebGLProgram, Gluint)	WebGLActiveInfo	Returns information about an active attribute variable.
// getActiveUniform()	(WebGLProgram, Gluint)	WebGLActiveInfo	Returns information about an active uniform variable.
pub extern "gl" fn getAttribLocation(c_uint, *const u8, c_uint) c_int; //  the location of an attribute variable.
// getUniform()	(WebGLProgram, WebGLUniformLocation)	(depends on parameter)	Returns the value of a uniform variable at a given location.
pub extern "gl" fn getUniformLocation(u32, *const u8, u32) i32; // Returns the location of a uniform variable.
// getVertexAttrib()	(Gluint, Glenum)	(depends on parameter)	Returns information about a vertex attribute at a given position.
// getVertexAttribOffset()	(Gluint, Glenum)	Glintptr	Returns the address of a given vertex attribute.
// uniform[1234][fi][v]()	(WebGLUniformLocation, value*)		Specifies a value for a uniform variable.
pub extern "gl" fn uniform4fv(i32, f32, f32, f32, f32) void; // Specifies a value for a `4fv` uniform variable.
// uniformMatrix[234]fv()	(WebGLUniformLocation, Glboolean, Float32Array)		Specifies a matrix value for a uniform variable.
// vertexAttrib[1234]f[v]()	(Gluint, Number*, Float32Array)		Specifies a value for a generic vertex attribute.
pub extern "gl" fn vertexAttribPointer(u32, u32, u32, u32, u32, u32) void; // Specifies the data formats and locations of vertex attributes in a vertex attributes array.

// WebGLRenderingContext - Drawing buffers
pub extern "gl" fn clear(u32) void; // Clears specified buffers to preset values.
pub extern "gl" fn drawArrays(u32, i32, i32) void; // Renders primitives from array data.
// drawElements()	(Glenum, Glsizei, Gleenum, Glintptr)		Renders primitives from element array data.
// finish()			Blocks execution until all previously called commands are finished.
// flush()			Empties different buffer commands, causing all commands to be executed as quickly as possible.

// WebGLRenderingContext - Color spaces
// drawingBufferColorSpace	String assignment		Specifies the color space of the WebGL drawing buffer.
// unpackColorSpace()	String assignment		Specifies the color space to convert to when importing textures.

// WebGL2RenderingContext - Buffers
// bufferData()	(Glenum, Glsizeiptr, *ArrayBuffer, Glenum, Gluint, Gluint)		Initializes and creates the buffer object's data store.
// bufferSubData()	(Glenum, Glintptr, *ArrayBuffer, Gluint, Gluint)		Updates a subset of a buffer object's data store.
// copyBufferSubData()	(Glenum, Glintptr, Glsizei)		Copies part of the data of a buffer to another buffer.
// getBufferSubData()	(Glenum, Glintptr, data, Gluint, Gluint)		Reads data from a buffer and writes them to an ArrayBuffer or SharedArrayBuffer.

// WebGL2RenderingContext - Framebuffers
// blitFramebuffeer()	(Glint, Glint, Gibitfield, Glenum)		Transfers a block of pixels from the read framebuffer to the draw framebuffer.
// framebufferTextureLayer()	(Glenum, Glenum, WebGLTexture, Glint, Glint)		Attaches a single layer of a texture to a framebuffer.
// invalidateFramebuffer()	(Glenum, Glnum*)		Invalidates the contents of attachments in a framebuffer.
// invalidateSubFramebuffer()	(Glenum, Glenum*, Glint, Glint, Glsizei, Glsizei)		Invalidates portions of the contents of attachments in a framebuffer
// readBuffer()	(Glenum)		Selects a color buffer as the source for pixels.

// WebGL2RenderingContext - Renderbuffers
// getInternalFormatParameter()	(Glenum, Glenum, Glenum)	(depends on parameter)	Returns information about implementation-dependent support for internal formats.
// renderbufferStorageMultisample()	(Glenum, Glsizei, Glenum, Glsizei, Glsizei)		Creates and initializes a renderbuffer object's data store and allows specifying the number of samples to be used.

// WebGL2RenderingContext - Textures
// texStorage2D()	(Glenum, Glint, Glenum, Glsizei, Glsizei)		Specifies all levels of two-dimensional texture storage.
// texStorage3D()	(Glenum, Glint, Glenum, Glsizei, Glsizei, Glsizei)		Specifies all levels of a three-dimensional texture or two-dimensional array texture.
// texImage3D()	(Glenum, Glint, Glint, Glsizei, Glsizei, Glsizei, Glint, Glenum, Glenum, *ImageElement, data, Glintptr)		Specifies a three-dimensional texture image.
// texSubImage3D()	(Glenum, Glint, Glint, Glint, Glint, Glsizei, Glsizei, Glsizei, Glenum, Glenum, *ImageArray, data, Glintptr)		Specifies a sub-rectangle of the current 3D texture.
// copyTexSubImage3d()	(Glenum, Glint, Glint, Glint, Glint, Glint, Glint, Glsizei, Glsizei)		Copies pixels from the current WebGLFramebuffer into an existing 3D texture sub-image.
// compressedTexImage3D()	(Glenum, Glint, Glenum, Glsizei, Glsizei, Glsizei, Glint, Glsizei, Glintptr)		Specifies a three-dimensional texture image in a compressed format.
// compressedTexSubImage3D()	(Glenum, Glint, Glint, Glint, Glint, Glsizei, Glsizei, Glsizei, Glenum, Glint, Glint, data)		Specifies a three-dimensional sub-rectangle for a texture image in a compressed format.

// WebGL2RenderingContext - Programs and shaders
// getFragDataLocation()	(WebGLProgram, String)	Glint	Returns the binding of color numbers to user-defined varying out variables.

// WebGL2RenderingContext - Uniforms and attributes
// uniform[1234][fi][v]()	(WebGLUniformLocation, Number*)		Methods specifying values of uniform variables.
// uniformMatrix[234]x[234]fv()	(WebGLUniformLocation, Glboolean, Float32Array)		Methods specifying matrix values for uniform variables.
// vertexAttribI4[u]i[v]()	(Gluint, Number, *Array)		Methods specifying integer values for generic vertex attributes.
// vertexAttribIPointer()	(Gluint, Glint, Glenum, Glsizei, Glintptr)		Specifies integer data formats and locations of vertex attributes in a vertex attributes array.

// WebGL2RenderingContext - Color spaces
// drawingBufferColorSpace	String assignment		Specifies the color space of the WebGL drawing buffer.
// unpackColorSpace	String assignment		Specifies the color space to convert to when importing textures.

// WebGL2RenderingContext - Drawing buffers
// vertexAttribDivisor()	(Gluint, Gluint)		Modifies the rate at which generic vertex attributes advance when rendering multiple instances of primitives with gl.drawArraysInstanced() and gl.drawElementsInstanced().
// drawArraysInstanced()	(Glenum, Glint, Glsizei, Glsizei)		Renders primitives from array data. In addition, it can execute multiple instances of the range of elements.
// drawElementsInstanced()	(Glenum, Glsizei, Glenum, Glintptr, Glsizei)		Renders primitives from array data. In addition, it can execute multiple instances of a set of elements.
// drawRangeElements()	(Glenum, Gluint, Gluint, Glsizei, Glenum, Glintptr)		Renders primitives from array data in a given range.
// drawBuffers()	(Glenum*)		Specifies a list of color buffers to be drawn into.
// clearBuffer[fiuv]()	(Glenum, Glint, Array, Glfloat, Glint)		Clears buffers from the currently bound framebuffer.

// WebGL2RenderingContext - Query objects
// createQuery()		WebGLQuery	Creates a new WebGLQuery object.
// deleteQuery()	(WebGLQuery)		Deletes a given WebGLQuery object.
// isQuery()	(WebGLQuery)	GLboolean	Returns true if a given object is a valid WebGLQuery object.
// beginQuery()	(Glenum, WebGLQuery)		Begins an asynchronous query.
// endQuery()	(Glenum)		Marks the end of an asynchronous query.
// getQuery()	(Glenum, Glenum)	WebGLQuery	Returns a WebGLQuery object for a given target.
// getQueryParameter()	(WebGLQuery, Glnum)	(depends on parameter)	Returns information about a query.

// WebGL2RenderingContext - Sampler objects
// createSampler()		WebGLSampler	Creates a new WebGLSampler object.
// deleteSampler()	(WebGLSampler)		Deletes a given WebGLSampler object.
// bindSampler()	(Gluint, WebGLSampler)		Binds a given WebGLSampler to a texture unit.
// isSampler()	(WebGLSampler)	GLboolean	Returns true if a given object is a valid WebGLSampler object.
// samplerParameter[if]()	(WebGLSampler, Glenum, Glint)		Sets sampler parameters.
// getSamplerParameter()	(WebGLSampler, Glenum)	(depends on parameter)	Returns sampler parameter information.

// WebGL2RenderingContext - Sync objects
// fenceSync()	(Glenum, Glbitfield)	WebGLSync	Creates a new WebGLSync object and inserts it into the GL command stream.
// isSync()	(WebGLSync)	GLboolean	Returns true if the passed object is a valid WebGLSync object.
// deleteSync()	(WebGLSync)		Deletes a given WebGLSync object.
// clientWaitSync()	(WebGLSync, Glbitfield, GLint64)	GLenum	Blocks and waits for a WebGLSync object to become signaled or a given timeout to be passed.
// waitSync()	(WebGLSync, Glbitfield, GLint64)		Returns immediately, but waits on the GL server until the given WebGLSync object is signaled.
// getSyncParameter()	(WebGLSync, Glenum)	(depends on parameter)	Returns parameter information of a WebGLSync object.

// WebGL2RenderingContext - Transform feedback
// createTransformFeedback()		WebGLTransformFeedback	Creates and initializes WebGLTransformFeedback objects.
// deleteTransformFeedback()	(WebGLTransformFeedback)		Deletes a given WebGLTransformFeedback object.
// isTransformFeedback()	(WebGLTransformFeedback)	GLboolean	Returns true if the passed object is a valid WebGLTransformFeedback object.
// bindTransformFeedback()	(Glenum, WebGLTransformFeedback)		Binds a passed WebGLTransformFeedback object to the current GL state.
// beginTransformFeedback()	(Glenum)		Starts a transform feedback operation.
// endTransformFeedback()			Ends a transform feedback operation.
// transformFeedbackVaryings()	(WebGLProgram, Array, Glenum)		Specifies values to record in WebGLTransformFeedback buffers.
// getTransformFeedbackVarying()	(WebGLProgram, Gluint)	WebGLActiveInfo	Returns information about varying variables from WebGLTransformFeedback buffers.
// pauseTransformFeedback()			Pauses a transform feedback operation.
// resumeTransformFeedback()			Resumes a transform feedback operation.

// WebGL2RenderingContext - Uniform buffer objects
// bindBufferBase()	(Glenum, Gluint, WebGLBuffer)		Binds a given WebGLBuffer to a given binding point (target) at a given index.
// bindBufferRange()	(Glenum, Gluint, WebGLBuffer, Glintptr, Glsizeitptr)		Binds a range of a given WebGLBuffer to a given binding point (target) at a given index.
// getUniformIndices()	(WebGLProgram, Array)	Gluint*	Retrieves the indices of a number of uniforms within a WebGLProgram.
// getActiveUniforms()	(WebGLProgram, Gluint*, Glenum)		Retrieves information about active uniforms within a WebGLProgram.
// getUniformBlockIndex()	(WebGLProgram, String)	Gluint	Retrieves the index of a uniform block within a WebGLProgram.
// getActiveUniformBlockParameter()	(WebGLProgram, Gluint, Glenum)	(depends on parameter)	Retrieves information about an active uniform block within a WebGLProgram.
// getActiveUniformBlockName()	(WebGLProgram, Gluint)	String	Retrieves the name of the active uniform block at a given index within a WebGLProgram.
// uniformBlockBinding()	(WebGLProgram, Gluint, Gluint)		Assigns binding points for active uniform blocks.

// WebGL2RenderingContext - Vertex array objects
// createVertexArray()		WebGLVertexArrayObject	Creates a new WebGLVertexArrayObject.
// deleteVertexArray()	(WebGLVertexArrayObject)		Deletes a given WebGLVertexArrayObject.
// isVertexArray()	(WebGLVertexArrayObject)	GLboolean	Returns true if a given object is a valid WebGLVertexArrayObject.
// bindVertexArray()	(WebGLVertexArrayObject)		Binds a given WebGLVertexArrayObject to the buffer.

// WebGL 1 Enums - Clearing buffers
pub const DEPTH_BUFFER_BIT: u16 = 0x00000100;
pub const STENCIL_BUFFER_BIT: u16 = 0x00000400;
pub const COLOR_BUFFER_BIT: u16 = 0x00004000;

// WebGL 1 Enums - Rendering primitives+8*9/10.
pub const POINTS: u16 = 0x0000;
pub const LINES: u16 = 0x0001;
pub const LINE_LOOP: u16 = 0x0002;
pub const LINE_STRIP: u16 = 0x0003;
pub const TRIANGLES: u16 = 0x0004;
pub const TRIANGLE_STRIP: u16 = 0x0005;
pub const TRIANGLE_FAN: u16 = 0x0006;

// WebGL 1 Enums - Blending modes
pub const ZERO: u16 = 0;
pub const ONE: u16 = 1;
pub const SRC_COLOR: u16 = 0x0300;
pub const ONE_MINUS_SRC_COLOR: u16 = 0x0301;
pub const SRC_ALPHA: u16 = 0x0302;
pub const ONE_MINUS_SRC_ALPHA: u16 = 0x0303;
pub const DST_ALPHA: u16 = 0x0304;
pub const ONE_MINUS_DST_ALPHA: u16 = 0x0305;
pub const DST_COLOR: u16 = 0x0306;
pub const ONE_MINUS_DST_COLOR: u16 = 0x0307;
pub const SRC_ALPHA_SATURATE: u16 = 0x0308;
pub const CONSTANT_COLOR: u16 = 0x8001;
pub const ONE_MINUS_CONSTANT_COLOR: u16 = 0x8002;
pub const CONSTANT_ALPHA: u16 = 0x8003;
pub const ONE_MINUS_CONSTANT_ALPHA: u16 = 0x8004;

// WebGL 1 Enums - Blending equations
pub const FUNC_ADD: u16 = 0x8006;
pub const FUNC_SUBTRACT: u16 = 0x800A;
pub const FUNC_REVERSE_SUBTRACT: u16 = 0x800B;

// WebGL 1 Enums - Getting GL parameter information
pub const BLEND_EQUATION: u16 = 0x8009;
pub const BLEND_EQUATION_RGB: u16 = 0x8009;
pub const BLEND_EQUATION_ALPHA: u16 = 0x883D;
pub const BLEND_DST_RGB: u16 = 0x80C8;
pub const BLEND_SRC_RGB: u16 = 0x80C9;
pub const BLEND_DST_ALPHA: u16 = 0x80CA;
pub const BLEND_SRC_ALPHA: u16 = 0x80CB;
pub const BLEND_COLOR: u16 = 0x8005;
pub const ARRAY_BUFFER_BINDING: u16 = 0x8894;
pub const ELEMENT_ARRAY_BUFFER_BINDING: u16 = 0x8895;
pub const LINE_WIDTH: u16 = 0x0B21;
pub const ALIASED_POINT_SIZE_RANGE: u16 = 0x846D;
pub const ALIASED_LINE_WIDTH_RANGE: u16 = 0x846E;
pub const CULL_FACE_MODE: u16 = 0x0B45;
pub const FRONT_FACE: u16 = 0x0B46;
pub const DEPTH_RANGE: u16 = 0x0B70;
pub const DEPTH_WRITEMASK: u16 = 0x0B72;
pub const DEPTH_CLEAR_VALUE: u16 = 0x0B73;
pub const DEPTH_FUNC: u16 = 0x0B74;
pub const STENCIL_CLEAR_VALUE: u16 = 0x0B91;
pub const STENCIL_FUNC: u16 = 0x0B92;
pub const STENCIL_FAIL: u16 = 0x0B94;
pub const STENCIL_PASS_DEPTH_FAIL: u16 = 0x0B95;
pub const STENCIL_PASS_DEPTH_PASS: u16 = 0x0B96;
pub const STENCIL_REF: u16 = 0x0B97;
pub const STENCIL_VALUE_MASK: u16 = 0x0B93;
pub const STENCIL_WRITEMASK: u16 = 0x0B98;
pub const STENCIL_BACK_FUNC: u16 = 0x8800;
pub const STENCIL_BACK_FAIL: u16 = 0x8801;
pub const STENCIL_BACK_PASS_DEPTH_FAIL: u16 = 0x8802;
pub const STENCIL_BACK_PASS_DEPTH_PASS: u16 = 0x8803;
pub const STENCIL_BACK_REF: u16 = 0x8CA3;
pub const STENCIL_BACK_VALUE_MASK: u16 = 0x8CA4;
pub const STENCIL_BACK_WRITEMASK: u16 = 0x8CA5;
pub const VIEWPORT: u16 = 0x0BA2;
pub const SCISSOR_BOX: u16 = 0x0C10;
pub const COLOR_CLEAR_VALUE: u16 = 0x0C22;
pub const COLOR_WRITEMASK: u16 = 0x0C23;
pub const UNPACK_ALIGNMENT: u16 = 0x0CF5;
pub const PACK_ALIGNMENT: u16 = 0x0D05;
pub const MAX_TEXTURE_SIZE: u16 = 0x0D33;
pub const MAX_VIEWPORT_DIMS: u16 = 0x0D3A;
pub const SUBPIXEL_BITS: u16 = 0x0D50;
pub const RED_BITS: u16 = 0x0D52;
pub const GREEN_BITS: u16 = 0x0D53;
pub const BLUE_BITS: u16 = 0x0D54;
pub const ALPHA_BITS: u16 = 0x0D55;
pub const DEPTH_BITS: u16 = 0x0D56;
pub const STENCIL_BITS: u16 = 0x0D57;
pub const POLYGON_OFFSET_UNITS: u16 = 0x2A00;
pub const POLYGON_OFFSET_FACTOR: u16 = 0x8038;
pub const TEXTURE_BINDING_2D: u16 = 0x8069;
pub const SAMPLE_BUFFERS: u16 = 0x80A8;
pub const SAMPLES: u16 = 0x80A9;
pub const SAMPLE_COVERAGE_VALUE: u16 = 0x80AA;
pub const SAMPLE_COVERAGE_INVERT: u16 = 0x80AB;
pub const COMPRESSED_TEXTURE_FORMATS: u16 = 0x86A3;
pub const VENDOR: u16 = 0x1F00;
pub const RENDERER: u16 = 0x1F01;
pub const VERSION: u16 = 0x1F02;
pub const IMPLEMENTATION_COLOR_READ_TYPE: u16 = 0x8B9A;
pub const IMPLEMENTATION_COLOR_READ_FORMAT: u16 = 0x8B9B;
pub const BROWSER_DEFAULT_WEBGL: u16 = 0x9244;

// WebGL 1 Enums - Buffers
pub const STATIC_DRAW: u16 = 0x88E4;
pub const STREAM_DRAW: u16 = 0x88E0;
pub const DYNAMIC_DRAW: u16 = 0x88E8;
pub const ARRAY_BUFFER: u16 = 0x8892;
pub const ELEMENT_ARRAY_BUFFER: u16 = 0x8893;
pub const BUFFER_SIZE: u16 = 0x8764;
pub const BUFFER_USAGE: u16 = 0x8765;

// WebGL 1 Enums - Vertex attributes
pub const CURRENT_VERTEX_ATTRIB: u16 = 0x8626;
pub const VERTEX_ATTRIB_ARRAY_ENABLED: u16 = 0x8622;
pub const VERTEX_ATTRIB_ARRAY_SIZE: u16 = 0x8623;
pub const VERTEX_ATTRIB_ARRAY_STRIDE: u16 = 0x8624;
pub const VERTEX_ATTRIB_ARRAY_TYPE: u16 = 0x8625;
pub const VERTEX_ATTRIB_ARRAY_NORMALIZED: u16 = 0x886A;
pub const VERTEX_ATTRIB_ARRAY_POINTER: u16 = 0x8645;
pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING: u16 = 0x889F;

// WebGL 1 Enums - Culling
pub const CULL_FACE: u16 = 0x0B44;
pub const FRONT: u16 = 0x0404;
pub const BACK: u16 = 0x0405;
pub const FRONT_AND_BACK: u16 = 0x0408;

// WebGL 1 Enums - Enabling and disabling
pub const BLEND: u16 = 0x0BE2;
pub const DEPTH_TEST: u16 = 0x0B71;
pub const DITHER: u16 = 0x0BD0;
pub const POLYGON_OFFSET_FILL: u16 = 0x8037;
pub const SAMPLE_ALPHA_TO_COVERAGE: u16 = 0x809E;
pub const SAMPLE_COVERAGE: u16 = 0x80A0;
pub const SCISSOR_TEST: u16 = 0x0C11;
pub const STENCIL_TEST: u16 = 0x0B90;

// WebGL 1 Enums - Errors
pub const NO_ERROR: u16 = 0;
pub const INVALID_ENUM: u16 = 0x0500;
pub const INVALID_VALUE: u16 = 0x0501;
pub const INVALID_OPERATION: u16 = 0x0502;
pub const OUT_OF_MEMORY: u16 = 0x0505;
pub const CONTEXT_LOST_WEBGL: u16 = 0x9242;

// WebGL 1 Enums - Front face directions
pub const CW: u16 = 0x0900;
pub const CCW: u16 = 0x0901;

// WebGL 1 Enums - Hints
pub const DONT_CARE: u16 = 0x1100;
pub const FASTEST: u16 = 0x1101;
pub const NICEST: u16 = 0x1102;
pub const GENERATE_MIPMAP_HINT: u16 = 0x8192;

// WebGL 1 Enums - Data types
pub const BYTE: u16 = 0x1400;
pub const UNSIGNED_BYTE: u16 = 0x1401;
pub const SHORT: u16 = 0x1402;
pub const UNSIGNED_SHORT: u16 = 0x1403;
pub const INT: u16 = 0x1404;
pub const UNSIGNED_INT: u16 = 0x1405;
pub const FLOAT: u16 = 0x1406;

// WebGL 1 Enums - Pixel formats
pub const DEPTH_COMPONENT: u16 = 0x1902;
pub const ALPHA: u16 = 0x1906;
pub const RGB: u16 = 0x1907;
pub const RGBA: u16 = 0x1908;
pub const LUMINANCE: u16 = 0x1909;
pub const LUMINANCE_ALPHA: u16 = 0x190A;

// WebGL 1 Enums - Pixel types
//pub const UNSIGNED_BYTE: u16 = 0x1401; // previously defined
pub const UNSIGNED_SHORT_4_4_4_4: u16 = 0x8033;
pub const UNSIGNED_SHORT_5_5_5_1: u16 = 0x8034;
pub const UNSIGNED_SHORT_5_6_5: u16 = 0x8363;

// WebGL 1 Enums - Shaders
pub const FRAGMENT_SHADER: u16 = 0x8B30;
pub const VERTEX_SHADER: u16 = 0x8B31;
pub const COMPILE_STATUS: u16 = 0x8B81;
pub const DELETE_STATUS: u16 = 0x8B80;
pub const LINK_STATUS: u16 = 0x8B82;
pub const VALIDATE_STATUS: u16 = 0x8B83;
pub const ATTACHED_SHADERS: u16 = 0x8B85;
pub const ACTIVE_ATTRIBUTES: u16 = 0x8B89;
pub const ACTIVE_UNIFORMS: u16 = 0x8B86;
pub const MAX_VERTEX_ATTRIBS: u16 = 0x8869;
pub const MAX_VERTEX_UNIFORM_VECTORS: u16 = 0x8DFB;
pub const MAX_VARYING_VECTORS: u16 = 0x8DFC;
pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS: u16 = 0x8B4D;
pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS: u16 = 0x8B4C;
pub const MAX_TEXTURE_IMAGE_UNITS: u16 = 0x8872;
pub const MAX_FRAGMENT_UNIFORM_VECTORS: u16 = 0x8DFD;
pub const SHADER_TYPE: u16 = 0x8B4F;
pub const SHADING_LANGUAGE_VERSION: u16 = 0x8B8C;
pub const CURRENT_PROGRAM: u16 = 0x8B8D;

// WebGL 1 Enums - Depth or stencil tests
pub const NEVER: u16 = 0x0200;
pub const LESS: u16 = 0x0201;
pub const EQUAL: u16 = 0x0202;
pub const LEQUAL: u16 = 0x0203;
pub const GREATER: u16 = 0x0204;
pub const NOTEQUAL: u16 = 0x0205;
pub const GEQUAL: u16 = 0x0206;
pub const ALWAYS: u16 = 0x0207;

// WebGL 1 Enums - Stencil actions
pub const KEEP: u16 = 0x1E00;
pub const REPLACE: u16 = 0x1E01;
pub const INCR: u16 = 0x1E02;
pub const DECR: u16 = 0x1E03;
pub const INVERT: u16 = 0x150A;
pub const INCR_WRAP: u16 = 0x8507;
pub const DECR_WRAP: u16 = 0x8508;

// WebGL 1 Enums - Textures
pub const NEAREST: u16 = 0x2600;
pub const LINEAR: u16 = 0x2601;
pub const NEAREST_MIPMAP_NEAREST: u16 = 0x2700;
pub const LINEAR_MIPMAP_NEAREST: u16 = 0x2701;
pub const NEAREST_MIPMAP_LINEAR: u16 = 0x2702;
pub const LINEAR_MIPMAP_LINEAR: u16 = 0x2703;
pub const TEXTURE_MAG_FILTER: u16 = 0x2800;
pub const TEXTURE_MIN_FILTER: u16 = 0x2801;
pub const TEXTURE_WRAP_S: u16 = 0x2802;
pub const TEXTURE_WRAP_T: u16 = 0x2803;
pub const TEXTURE_2D: u16 = 0x0DE1;
pub const TEXTURE: u16 = 0x1702;
pub const TEXTURE_CUBE_MAP: u16 = 0x8513;
pub const TEXTURE_BINDING_CUBE_MAP: u16 = 0x8514;
pub const TEXTURE_CUBE_MAP_POSITIVE_X: u16 = 0x8515;
pub const TEXTURE_CUBE_MAP_NEGATIVE_X: u16 = 0x8516;
pub const TEXTURE_CUBE_MAP_POSITIVE_Y: u16 = 0x8517;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Y: u16 = 0x8518;
pub const TEXTURE_CUBE_MAP_POSITIVE_Z: u16 = 0x8519;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Z: u16 = 0x851A;
pub const MAX_CUBE_MAP_TEXTURE_SIZE: u16 = 0x851C;
pub const TEXTURE0: u16 = 0x84C0;
pub const TEXTURE1: u16 = 0x84C1;
pub const TEXTURE2: u16 = 0x84C2;
pub const TEXTURE3: u16 = 0x84C3;
pub const TEXTURE4: u16 = 0x84C4;
pub const TEXTURE5: u16 = 0x84C5;
pub const TEXTURE6: u16 = 0x84C6;
pub const TEXTURE7: u16 = 0x84C7;
pub const TEXTURE8: u16 = 0x84C8;
pub const TEXTURE9: u16 = 0x84C9;
pub const TEXTURE10: u16 = 0x84CA;
pub const TEXTURE11: u16 = 0x84CB;
pub const TEXTURE12: u16 = 0x84CC;
pub const TEXTURE13: u16 = 0x84CD;
pub const TEXTURE14: u16 = 0x84CE;
pub const TEXTURE15: u16 = 0x84CF;
pub const TEXTURE16: u16 = 0x84D0;
pub const TEXTURE17: u16 = 0x84D1;
pub const TEXTURE18: u16 = 0x84D2;
pub const TEXTURE19: u16 = 0x84D3;
pub const TEXTURE20: u16 = 0x84D4;
pub const TEXTURE21: u16 = 0x84D5;
pub const TEXTURE22: u16 = 0x84D6;
pub const TEXTURE23: u16 = 0x84D7;
pub const TEXTURE24: u16 = 0x84D8;
pub const TEXTURE25: u16 = 0x84D9;
pub const TEXTURE26: u16 = 0x84DA;
pub const TEXTURE27: u16 = 0x84DB;
pub const TEXTURE28: u16 = 0x84DC;
pub const TEXTURE29: u16 = 0x84DD;
pub const TEXTURE30: u16 = 0x84DE;
pub const TEXTURE31: u16 = 0x84DF;
pub const ACTIVE_TEXTURE: u16 = 0x84E0;
pub const REPEAT: u16 = 0x2901;
pub const CLAMP_TO_EDGE: u16 = 0x812F;
pub const MIRRORED_REPEAT: u16 = 0x8370;

// WebGL 1 Enums - Uniform types
pub const FLOAT_VEC2: u16 = 0x8B50;
pub const FLOAT_VEC3: u16 = 0x8B51;
pub const FLOAT_VEC4: u16 = 0x8B52;
pub const INT_VEC2: u16 = 0x8B53;
pub const INT_VEC3: u16 = 0x8B54;
pub const INT_VEC4: u16 = 0x8B55;
pub const BOOL: u16 = 0x8B56;
pub const BOOL_VEC2: u16 = 0x8B57;
pub const BOOL_VEC3: u16 = 0x8B58;
pub const BOOL_VEC4: u16 = 0x8B59;
pub const FLOAT_MAT2: u16 = 0x8B5A;
pub const FLOAT_MAT3: u16 = 0x8B5B;
pub const FLOAT_MAT4: u16 = 0x8B5C;
pub const SAMPLER_2D: u16 = 0x8B5E;
pub const SAMPLER_CUBE: u16 = 0x8B60;

// WebGL 1 Enums - Shader precision-specified types
pub const LOW_FLOAT: u16 = 0x8DF0;
pub const MEDIUM_FLOAT: u16 = 0x8DF1;
pub const HIGH_FLOAT: u16 = 0x8DF2;
pub const LOW_INT: u16 = 0x8DF3;
pub const MEDIUM_INT: u16 = 0x8DF4;
pub const HIGH_INT: u16 = 0x8DF5;

// WebGL 1 Enums - Framebuffers and renderbuffers
pub const FRAMEBUFFER: u16 = 0x8D40;
pub const RENDERBUFFER: u16 = 0x8D41;
pub const RGBA4: u16 = 0x8056;
pub const RGB5_A1: u16 = 0x8057;
pub const RGB565: u16 = 0x8D62;
pub const DEPTH_COMPONENT16: u16 = 0x81A5;
pub const STENCIL_INDEX8: u16 = 0x8D48;
pub const DEPTH_STENCIL: u16 = 0x84F9;
pub const RENDERBUFFER_WIDTH: u16 = 0x8D42;
pub const RENDERBUFFER_HEIGHT: u16 = 0x8D43;
pub const RENDERBUFFER_INTERNAL_FORMAT: u16 = 0x8D44;
pub const RENDERBUFFER_RED_SIZE: u16 = 0x8D50;
pub const RENDERBUFFER_GREEN_SIZE: u16 = 0x8D51;
pub const RENDERBUFFER_BLUE_SIZE: u16 = 0x8D52;
pub const RENDERBUFFER_ALPHA_SIZE: u16 = 0x8D53;
pub const RENDERBUFFER_DEPTH_SIZE: u16 = 0x8D54;
pub const RENDERBUFFER_STENCIL_SIZE: u16 = 0x8D55;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE: u16 = 0x8CD0;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME: u16 = 0x8CD1;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL: u16 = 0x8CD2;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE: u16 = 0x8CD3;
pub const COLOR_ATTACHMENT0: u16 = 0x8CE0;
pub const DEPTH_ATTACHMENT: u16 = 0x8D00;
pub const STENCIL_ATTACHMENT: u16 = 0x8D20;
pub const DEPTH_STENCIL_ATTACHMENT: u16 = 0x821A;
pub const NONE: u16 = 0;
pub const FRAMEBUFFER_COMPLETE: u16 = 0x8CD5;
pub const FRAMEBUFFER_INCOMPLETE_ATTACHMENT: u16 = 0x8CD6;
pub const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: u16 = 0x8CD7;
pub const FRAMEBUFFER_INCOMPLETE_DIMENSIONS: u16 = 0x8CD9;
pub const FRAMEBUFFER_UNSUPPORTED: u16 = 0x8CDD;
pub const FRAMEBUFFER_BINDING: u16 = 0x8CA6;
pub const RENDERBUFFER_BINDING: u16 = 0x8CA7;
pub const MAX_RENDERBUFFER_SIZE: u16 = 0x84E8;
pub const INVALID_FRAMEBUFFER_OPERATION: u16 = 0x0506;

// WebGL 1 Enums - Pixel storage modes
pub const UNPACK_FLIP_Y_WEBGL: u16 = 0x9240;
pub const UNPACK_PREMULTIPLY_ALPHA_WEBGL: u16 = 0x9241;
pub const UNPACK_COLORSPACE_CONVERSION_WEBGL: u16 = 0x9243;

// WebGL 2 Enums - Getting GL parametere information
pub const READ_BUFFER: u16 = 0x0C02;
pub const UNPACK_ROW_LENGTH: u16 = 0x0CF2;
pub const UNPACK_SKIP_ROWS: u16 = 0x0CF3;
pub const UNPACK_SKIP_PIXELS: u16 = 0x0CF4;
pub const PACK_ROW_LENGTH: u16 = 0x0D02;
pub const PACK_SKIP_ROWS: u16 = 0x0D03;
pub const PACK_SKIP_PIXELS: u16 = 0x0D04;
pub const TEXTURE_BINDING_3D: u16 = 0x806A;
pub const UNPACK_SKIP_IMAGES: u16 = 0x806D;
pub const UNPACK_IMAGE_HEIGHT: u16 = 0x806E;
pub const MAX_3D_TEXTURE_SIZE: u16 = 0x8073;
pub const MAX_ELEMENTS_VERTICES: u16 = 0x80E8;
pub const MAX_ELEMENTS_INDICES: u16 = 0x80E9;
pub const MAX_TEXTURE_LOD_BIAS: u16 = 0x84FD;
pub const MAX_FRAGMENT_UNIFORM_COMPONENTS: u16 = 0x8B49;
pub const MAX_VERTEX_UNIFORM_COMPONENTS: u16 = 0x8B4A;
pub const MAX_ARRAY_TEXTURE_LAYERS: u16 = 0x88FF;
pub const MIN_PROGRAM_TEXEL_OFFSET: u16 = 0x8904;
pub const MAX_PROGRAM_TEXEL_OFFSET: u16 = 0x8905;
pub const MAX_VARYING_COMPONENTS: u16 = 0x8B4B;
pub const FRAGMENT_SHADER_DERIVATIVE_HINT: u16 = 0x8B8B;
pub const RASTERIZER_DISCARD: u16 = 0x8C89;
pub const VERTEX_ARRAY_BINDING: u16 = 0x85B5;
pub const MAX_VERTEX_OUTPUT_COMPONENTS: u16 = 0x9122;
pub const MAX_FRAGMENT_INPUT_COMPONENTS: u16 = 0x9125;
pub const MAX_SERVER_WAIT_TIMEOUT: u16 = 0x9111;
pub const MAX_ELEMENT_INDEX: u16 = 0x8D6B;

// WebGL 2 Enums - Textures
pub const RED: u16 = 0x1903;
pub const RGB8: u16 = 0x8051;
pub const RGBA8: u16 = 0x8058;
pub const RGB10_A2: u16 = 0x8059;
pub const TEXTURE_3D: u16 = 0x806F;
pub const TEXTURE_WRAP_R: u16 = 0x8072;
pub const TEXTURE_MIN_LOD: u16 = 0x813A;
pub const TEXTURE_MAX_LOD: u16 = 0x813B;
pub const TEXTURE_BASE_LEVEL: u16 = 0x813C;
pub const TEXTURE_MAX_LEVEL: u16 = 0x813D;
pub const TEXTURE_COMPARE_MODE: u16 = 0x884C;
pub const TEXTURE_COMPARE_FUNC: u16 = 0x884D;
pub const SRGB: u16 = 0x8C40;
pub const SRGB8: u16 = 0x8C41;
pub const SRGB8_ALPHA8: u16 = 0x8C43;
pub const COMPARE_REF_TO_TEXTURE: u16 = 0x884E;
pub const RGBA32F: u16 = 0x8814;
pub const RGB32F: u16 = 0x8815;
pub const RGBA16F: u16 = 0x881A;
pub const RGB16F: u16 = 0x881B;
pub const TEXTURE_2D_ARRAY: u16 = 0x8C1A;
pub const TEXTURE_BINDING_2D_ARRAY: u16 = 0x8C1D;
pub const R11F_G11F_B10F: u16 = 0x8C3A;
pub const RGB9_E5: u16 = 0x8C3D;
pub const RGBA32UI: u16 = 0x8D70;
pub const RGB32UI: u16 = 0x8D71;
pub const RGBA16UI: u16 = 0x8D76;
pub const RGB16UI: u16 = 0x8D77;
pub const RGBA8UI: u16 = 0x8D7C;
pub const RGB8UI: u16 = 0x8D7D;
pub const RGBA32I: u16 = 0x8D82;
pub const RGB32I: u16 = 0x8D83;
pub const RGBA16I: u16 = 0x8D88;
pub const RGB16I: u16 = 0x8D89;
pub const RGBA8I: u16 = 0x8D8E;
pub const RGB8I: u16 = 0x8D8F;
pub const RED_INTEGER: u16 = 0x8D94;
pub const RGB_INTEGER: u16 = 0x8D98;
pub const RGBA_INTEGER: u16 = 0x8D99;
pub const R8: u16 = 0x8229;
pub const RG8: u16 = 0x822B;
pub const R16F: u16 = 0x822D;
pub const R32F: u16 = 0x822E;
pub const RG16F: u16 = 0x822F;
pub const RG32F: u16 = 0x8230;
pub const R8I: u16 = 0x8231;
pub const R8UI: u16 = 0x8232;
pub const R16I: u16 = 0x8233;
pub const R16UI: u16 = 0x8234;
pub const R32I: u16 = 0x8235;
pub const R32UI: u16 = 0x8236;
pub const RG8I: u16 = 0x8237;
pub const RG8UI: u16 = 0x8238;
pub const RG16I: u16 = 0x8239;
pub const RG16UI: u16 = 0x823A;
pub const RG32I: u16 = 0x823B;
pub const RG32UI: u16 = 0x823C;
pub const R8_SNORM: u16 = 0x8F94;
pub const RG8_SNORM: u16 = 0x8F95;
pub const RGB8_SNORM: u16 = 0x8F96;
pub const RGBA8_SNORM: u16 = 0x8F97;
pub const RGB10_A2UI: u16 = 0x906F;
pub const TEXTURE_IMMUTABLE_FORMAT: u16 = 0x912F;
pub const TEXTURE_IMMUTABLE_LEVELS: u16 = 0x82DF;

// WebGL 2 Enums - Pixel types
pub const UNSIGNED_INT_2_10_10_10_REV: u16 = 0x8368;
pub const UNSIGNED_INT_10F_11F_11F_REV: u16 = 0x8C3B;
pub const UNSIGNED_INT_5_9_9_9_REV: u16 = 0x8C3E;
pub const FLOAT_32_UNSIGNED_INT_24_8_REV: u16 = 0x8DAD;
pub const UNSIGNED_INT_24_8: u16 = 0x84FA;
pub const HALF_FLOAT: u16 = 0x140B;
pub const RG: u16 = 0x8227;
pub const RG_INTEGER: u16 = 0x8228;
pub const INT_2_10_10_10_REV: u16 = 0x8D9F;

// WebGL 2 Enums - Queries
pub const CURRENT_QUERY: u16 = 0x8865;
pub const QUERY_RESULT: u16 = 0x8866;
pub const QUERY_RESULT_AVAILABLE: u16 = 0x8867;
pub const ANY_SAMPLES_PASSED: u16 = 0x8C2F;
pub const ANY_SAMPLES_PASSED_CONSERVATIVE: u16 = 0x8D6A;
pub const MAX_DRAW_BUFFERS: u16 = 0x8824;

// WebGL 2 Enums - Draw buffers
pub const DRAW_BUFFER0: u16 = 0x8825;
pub const DRAW_BUFFER1: u16 = 0x8826;
pub const DRAW_BUFFER2: u16 = 0x8827;
pub const DRAW_BUFFER3: u16 = 0x8828;
pub const DRAW_BUFFER4: u16 = 0x8829;
pub const DRAW_BUFFER5: u16 = 0x882A;
pub const DRAW_BUFFER6: u16 = 0x882B;
pub const DRAW_BUFFER7: u16 = 0x882C;
pub const DRAW_BUFFER8: u16 = 0x882D;
pub const DRAW_BUFFER9: u16 = 0x882E;
pub const DRAW_BUFFER10: u16 = 0x882F;
pub const DRAW_BUFFER11: u16 = 0x8830;
pub const DRAW_BUFFER12: u16 = 0x8831;
pub const DRAW_BUFFER13: u16 = 0x8832;
pub const DRAW_BUFFER14: u16 = 0x8833;
pub const DRAW_BUFFER15: u16 = 0x8834;
pub const MAX_COLOR_ATTACHMENTS: u16 = 0x8CDF;
pub const COLOR_ATTACHMENT1: u16 = 0x8CE1;
pub const COLOR_ATTACHMENT2: u16 = 0x8CE2;
pub const COLOR_ATTACHMENT3: u16 = 0x8CE3;
pub const COLOR_ATTACHMENT4: u16 = 0x8CE4;
pub const COLOR_ATTACHMENT5: u16 = 0x8CE5;
pub const COLOR_ATTACHMENT6: u16 = 0x8CE6;
pub const COLOR_ATTACHMENT7: u16 = 0x8CE7;
pub const COLOR_ATTACHMENT8: u16 = 0x8CE8;
pub const COLOR_ATTACHMENT9: u16 = 0x8CE9;
pub const COLOR_ATTACHMENT10: u16 = 0x8CEA;
pub const COLOR_ATTACHMENT11: u16 = 0x8CEB;
pub const COLOR_ATTACHMENT12: u16 = 0x8CEC;
pub const COLOR_ATTACHMENT13: u16 = 0x8CED;
pub const COLOR_ATTACHMENT14: u16 = 0x8CEE;
pub const COLOR_ATTACHMENT15: u16 = 0x8CEF;

// WebGL 2 Enums - Samplers
pub const SAMPLER_3D: u16 = 0x8B5F;
pub const SAMPLER_2D_SHADOW: u16 = 0x8B62;
pub const SAMPLER_2D_ARRAY: u16 = 0x8DC1;
pub const SAMPLER_2D_ARRAY_SHADOW: u16 = 0x8DC4;
pub const SAMPLER_CUBE_SHADOW: u16 = 0x8DC5;
pub const INT_SAMPLER_2D: u16 = 0x8DCA;
pub const INT_SAMPLER_3D: u16 = 0x8DCB;
pub const INT_SAMPLER_CUBE: u16 = 0x8DCC;
pub const INT_SAMPLER_2D_ARRAY: u16 = 0x8DCF;
pub const UNSIGNED_INT_SAMPLER_2D: u16 = 0x8DD2;
pub const UNSIGNED_INT_SAMPLER_3D: u16 = 0x8DD3;
pub const UNSIGNED_INT_SAMPLER_CUBE: u16 = 0x8DD4;
pub const UNSIGNED_INT_SAMPLER_2D_ARRAY: u16 = 0x8DD7;
pub const MAX_SAMPLES: u16 = 0x8D57;
pub const SAMPLER_BINDING: u16 = 0x8919;

// WebGL 2 Enums - Buffers
pub const PIXEL_PACK_BUFFER: u16 = 0x88EB;
pub const PIXEL_UNPACK_BUFFER: u16 = 0x88EC;
pub const PIXEL_PACK_BUFFER_BINDING: u16 = 0x88ED;
pub const PIXEL_UNPACK_BUFFER_BINDING: u16 = 0x88EF;
pub const COPY_READ_BUFFER: u16 = 0x8F36;
pub const COPY_WRITE_BUFFER: u16 = 0x8F37;
pub const COPY_READ_BUFFER_BINDING: u16 = 0x8F36;
pub const COPY_WRITE_BUFFER_BINDING: u16 = 0x8F37;

// WebGL 2 Enums - Data types
pub const FLOAT_MAT2x3: u16 = 0x8B65;
pub const FLOAT_MAT2x4: u16 = 0x8B66;
pub const FLOAT_MAT3x2: u16 = 0x8B67;
pub const FLOAT_MAT3x4: u16 = 0x8B68;
pub const FLOAT_MAT4x2: u16 = 0x8B69;
pub const FLOAT_MAT4x3: u16 = 0x8B6A;
pub const UNSIGNED_INT_VEC2: u16 = 0x8DC6;
pub const UNSIGNED_INT_VEC3: u16 = 0x8DC7;
pub const UNSIGNED_INT_VEC4: u16 = 0x8DC8;
pub const UNSIGNED_NORMALIZED: u16 = 0x8C17;
pub const SIGNED_NORMALIZED: u16 = 0x8F9C;

// WebGL 2 Enums - Vertex attributes
pub const VERTEX_ATTRIB_ARRAY_INTEGER: u16 = 0x88FD;
pub const VERTEX_ATTRIB_ARRAY_DIVISOR: u16 = 0x88FE;

// WebGL 2 Enums - Transform feedback
pub const TRANSFORM_FEEDBACK_BUFFER_MODE: u16 = 0x8C7F;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS: u16 = 0x8C80;
pub const TRANSFORM_FEEDBACK_VARYINGS: u16 = 0x8C83;
pub const TRANSFORM_FEEDBACK_BUFFER_START: u16 = 0x8C84;
pub const TRANSFORM_FEEDBACK_BUFFER_SIZE: u16 = 0x8C85;
pub const TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN: u16 = 0x8C88;
pub const MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS: u16 = 0x8C8A;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS: u16 = 0x8C8B;
pub const INTERLEAVED_ATTRIBS: u16 = 0x8C8C;
pub const SEPARATE_ATTRIBS: u16 = 0x8C8D;
pub const TRANSFORM_FEEDBACK_BUFFER: u16 = 0x8C8E;
pub const TRANSFORM_FEEDBACK_BUFFER_BINDING: u16 = 0x8C8F;
pub const TRANSFORM_FEEDBACK: u16 = 0x8E22;
pub const TRANSFORM_FEEDBACK_PAUSED: u16 = 0x8E23;
pub const TRANSFORM_FEEDBACK_ACTIVE: u16 = 0x8E24;
pub const TRANSFORM_FEEDBACK_BINDING: u16 = 0x8E25;

// WebGL 2 Enums - Framebuffers and renderbuffers
pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING: u16 = 0x8210;
pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE: u16 = 0x8211;
pub const FRAMEBUFFER_ATTACHMENT_RED_SIZE: u16 = 0x8212;
pub const FRAMEBUFFER_ATTACHMENT_GREEN_SIZE: u16 = 0x8213;
pub const FRAMEBUFFER_ATTACHMENT_BLUE_SIZE: u16 = 0x8214;
pub const FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE: u16 = 0x8215;
pub const FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE: u16 = 0x8216;
pub const FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE: u16 = 0x8217;
pub const FRAMEBUFFER_DEFAULT: u16 = 0x8218;
//pub const DEPTH_STENCIL_ATTACHMENT: u16 = 0x821A;
//pub const DEPTH_STENCIL: u16 = 0x84F9;
pub const DEPTH24_STENCIL8: u16 = 0x88F0;
pub const DRAW_FRAMEBUFFER_BINDING: u16 = 0x8CA6;
pub const READ_FRAMEBUFFER: u16 = 0x8CA8;
pub const DRAW_FRAMEBUFFER: u16 = 0x8CA9;
pub const READ_FRAMEBUFFER_BINDING: u16 = 0x8CAA;
pub const RENDERBUFFER_SAMPLES: u16 = 0x8CAB;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER: u16 = 0x8CD4;
pub const FRAMEBUFFER_INCOMPLETE_MULTISAMPLE: u16 = 0x8D56;

// WebGL 2 Enums - Uniforms
pub const UNIFORM_BUFFER: u16 = 0x8A11;
pub const UNIFORM_BUFFER_BINDING: u16 = 0x8A28;
pub const UNIFORM_BUFFER_START: u16 = 0x8A29;
pub const UNIFORM_BUFFER_SIZE: u16 = 0x8A2A;
pub const MAX_VERTEX_UNIFORM_BLOCKS: u16 = 0x8A2B;
pub const MAX_FRAGMENT_UNIFORM_BLOCKS: u16 = 0x8A2D;
pub const MAX_COMBINED_UNIFORM_BLOCKS: u16 = 0x8A2E;
pub const MAX_UNIFORM_BUFFER_BINDINGS: u16 = 0x8A2F;
pub const MAX_UNIFORM_BLOCK_SIZE: u16 = 0x8A30;
pub const MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS: u16 = 0x8A31;
pub const MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS: u16 = 0x8A33;
pub const UNIFORM_BUFFER_OFFSET_ALIGNMENT: u16 = 0x8A34;
pub const ACTIVE_UNIFORM_BLOCKS: u16 = 0x8A36;

// WebGL 2 Enums - Sync objects
pub const UNIFORM_TYPE: u16 = 0x8A37;
pub const UNIFORM_SIZE: u16 = 0x8A38;
pub const UNIFORM_BLOCK_INDEX: u16 = 0x8A3A;
pub const UNIFORM_OFFSET: u16 = 0x8A3B;
pub const UNIFORM_ARRAY_STRIDE: u16 = 0x8A3C;
pub const UNIFORM_MATRIX_STRIDE: u16 = 0x8A3D;
pub const UNIFORM_IS_ROW_MAJOR: u16 = 0x8A3E;
pub const UNIFORM_BLOCK_BINDING: u16 = 0x8A3F;
pub const UNIFORM_BLOCK_DATA_SIZE: u16 = 0x8A40;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORMS: u16 = 0x8A42;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES: u16 = 0x8A43;
pub const UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER: u16 = 0x8A44;
pub const UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER: u16 = 0x8A46;
pub const OBJECT_TYPE: u16 = 0x9112;
pub const SYNC_CONDITION: u16 = 0x9113;
pub const SYNC_STATUS: u16 = 0x9114;
pub const SYNC_FLAGS: u16 = 0x9115;
pub const SYNC_FENCE: u16 = 0x9116;
pub const SYNC_GPU_COMMANDS_COMPLETE: u16 = 0x9117;
pub const UNSIGNALED: u16 = 0x9118;
pub const SIGNALED: u16 = 0x9119;
pub const ALREADY_SIGNALED: u16 = 0x911A;
pub const TIMEOUT_EXPIRED: u16 = 0x911B;
pub const CONDITION_SATISFIED: u16 = 0x911C;
pub const WAIT_FAILED: u16 = 0x911D;
pub const SYNC_FLUSH_COMMANDS_BIT: u16 = 0x00000001;

// WebGL 2 Enums - Miscellaneous constants
pub const COLOR: u16 = 0x1800;
pub const DEPTH: u16 = 0x1801;
pub const STENCIL: u16 = 0x1802;
pub const MIN: u16 = 0x8007;
pub const MAX: u16 = 0x8008;
pub const DEPTH_COMPONENT24: u16 = 0x81A6;
pub const STREAM_READ: u16 = 0x88E1;
pub const STREAM_COPY: u16 = 0x88E2;
pub const STATIC_READ: u16 = 0x88E5;
pub const STATIC_COPY: u16 = 0x88E6;
pub const DYNAMIC_READ: u16 = 0x88E9;
pub const DYNAMIC_COPY: u16 = 0x88EA;
pub const DEPTH_COMPONENT32F: u16 = 0x8CAC;
pub const DEPTH32F_STENCIL8: u16 = 0x8CAD;
pub const INVALID_INDEX: u16 = 0xFFFFFFFF;
pub const TIMEOUT_IGNORED: u16 = -1;
pub const MAX_CLIENT_WAIT_TIMEOUT_WEBGL: u16 = 0x9247;

// Extension Enums - ANGLE_instanced_arrays
pub const VERTEX_ATTRIB_ARRAY_DIVISOR_ANGLE: u16 = 0x88FE;

// Extension Enums - WEBGL_debug_renderer_info
pub const UNMASKED_VENDOR_WEBGL: u16 = 0x9245;
pub const UNMASKED_RENDERER_WEBGL: u16 = 0x9246;

// Extension Enums - EXT_texture_filter_anisotropic
pub const MAX_TEXTURE_MAX_ANISOTROPY_EXT: u16 = 0x84FF;
pub const TEXTURE_MAX_ANISOTROPY_EXT: u16 = 0x84FE;

// Extension Enums - WEBGL_compressed_texturee_s3tc
pub const COMPRESSED_RGB_S3TC_DXT1_EXT: u16 = 0x83F0;
pub const COMPRESSED_RGBA_S3TC_DXT1_EXT: u16 = 0x83F1;
pub const COMPRESSED_RGBA_S3TC_DXT3_EXT: u16 = 0x83F2;
pub const COMPRESSED_RGBA_S3TC_DXT5_EXT: u16 = 0x83F3;

// Extension Enums - WEBGL_compressed_texture_etc
pub const COMPRESSED_R11_EAC: u16 = 0x9270;
pub const COMPRESSED_SIGNED_R11_EAC: u16 = 0x9271;
pub const COMPRESSED_RG11_EAC: u16 = 0x9272;
pub const COMPRESSED_SIGNED_RG11_EAC: u16 = 0x9273;
pub const COMPRESSED_RGB8_ETC2: u16 = 0x9274;
pub const COMPRESSED_RGBA8_ETC2_EAC: u16 = 0x9275;
pub const COMPRESSED_SRGB8_ETC2: u16 = 0x9276;
pub const COMPRESSED_SRGB8_ALPHA8_ETC2_EAC: u16 = 0x9277;
pub const COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2: u16 = 0x9278;
pub const COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2: u16 = 0x9279;

// Extension Enums - WEBGL_compressed_texture_pvrtc
pub const COMPRESSED_RGB_PVRTC_4BPPV1_IMG: u16 = 0x8C00;
pub const COMPRESSED_RGBA_PVRTC_4BPPV1_IMG: u16 = 0x8C02;
pub const COMPRESSED_RGB_PVRTC_2BPPV1_IMG: u16 = 0x8C01;
pub const COMPRESSED_RGBA_PVRTC_2BPPV1_IMG: u16 = 0x8C03;

// Extension Enums - WEBGL_compressed_texture_etc1
pub const COMPRESSED_RGB_ETC1_WEBGL: u16 = 0x8D64;

// Extension Enums - WEBGL_depth_texture
pub const UNSIGNED_INT_24_8_WEBGL: u16 = 0x84FA;

// Extension Enums - OES_texture_half_float
pub const HALF_FLOAT_OES: u16 = 0x8D61;

// Extension Enums - WEEBGL_color_buffer_float
pub const RGBA32F_EXT: u16 = 0x8814;
pub const RGB32F_EXT: u16 = 0x8815;
pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE_EXT: u16 = 0x8211;
pub const UNSIGNED_NORMALIZED_EXT: u16 = 0x8C17;

// Extension Enums - EXT_blend_minmax
pub const MIN_EXT: u16 = 0x8007;
pub const MAX_EXT: u16 = 0x8008;

// Extension Enums - EXT_sRGB
pub const SRGB_EXT: u16 = 0x8C40;
pub const SRGB_ALPHA_EXT: u16 = 0x8C42;
pub const SRGB8_ALPHA8_EXT: u16 = 0x8C43;
pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING_EXT: u16 = 0x8210;

// Extension Enums - OES_standard_derivatives
pub const FRAGMENT_SHADER_DERIVATIVE_HINT_OES: u16 = 0x8B8B;

// Extension Enums - WEBGL_draw_buffers
pub const COLOR_ATTACHMENT0_WEBGL: u16 = 0x8CE0;
pub const COLOR_ATTACHMENT1_WEBGL: u16 = 0x8CE1;
pub const COLOR_ATTACHMENT2_WEBGL: u16 = 0x8CE2;
pub const COLOR_ATTACHMENT3_WEBGL: u16 = 0x8CE3;
pub const COLOR_ATTACHMENT4_WEBGL: u16 = 0x8CE4;
pub const COLOR_ATTACHMENT5_WEBGL: u16 = 0x8CE5;
pub const COLOR_ATTACHMENT6_WEBGL: u16 = 0x8CE6;
pub const COLOR_ATTACHMENT7_WEBGL: u16 = 0x8CE7;
pub const COLOR_ATTACHMENT8_WEBGL: u16 = 0x8CE8;
pub const COLOR_ATTACHMENT9_WEBGL: u16 = 0x8CE9;
pub const COLOR_ATTACHMENT10_WEBGL: u16 = 0x8CEA;
pub const COLOR_ATTACHMENT11_WEBGL: u16 = 0x8CEB;
pub const COLOR_ATTACHMENT12_WEBGL: u16 = 0x8CEC;
pub const COLOR_ATTACHMENT13_WEBGL: u16 = 0x8CED;
pub const COLOR_ATTACHMENT14_WEBGL: u16 = 0x8CEE;
pub const COLOR_ATTACHMENT15_WEBGL: u16 = 0x8CEF;
pub const DRAW_BUFFER0_WEBGL: u16 = 0x8825;
pub const DRAW_BUFFER1_WEBGL: u16 = 0x8826;
pub const DRAW_BUFFER2_WEBGL: u16 = 0x8827;
pub const DRAW_BUFFER3_WEBGL: u16 = 0x8828;
pub const DRAW_BUFFER4_WEBGL: u16 = 0x8829;
pub const DRAW_BUFFER5_WEBGL: u16 = 0x882A;
pub const DRAW_BUFFER6_WEBGL: u16 = 0x882B;
pub const DRAW_BUFFER7_WEBGL: u16 = 0x882C;
pub const DRAW_BUFFER8_WEBGL: u16 = 0x882D;
pub const DRAW_BUFFER9_WEBGL: u16 = 0x882E;
pub const DRAW_BUFFER10_WEBGL: u16 = 0x882F;
pub const DRAW_BUFFER11_WEBGL: u16 = 0x8830;
pub const DRAW_BUFFER12_WEBGL: u16 = 0x8831;
pub const DRAW_BUFFER13_WEBGL: u16 = 0x8832;
pub const DRAW_BUFFER14_WEBGL: u16 = 0x8833;
pub const DRAW_BUFFER15_WEBGL: u16 = 0x8834;
pub const MAX_COLOR_ATTACHMENTS_WEBGL: u16 = 0x8CDF;
pub const MAX_DRAW_BUFFERS_WEBGL: u16 = 0x8824;

// Extension Enums - OES_vertex_array_object
pub const VERTEX_ARRAY_BINDING_OES: u16 = 0x85B5;

// Extension Enums - EXT_disjoint_timer_queery
pub const QUERY_COUNTER_BITS_EXT: u16 = 0x8864;
pub const CURRENT_QUERY_EXT: u16 = 0x8865;
pub const QUERY_RESULT_EXT: u16 = 0x8866;
pub const QUERY_RESULT_AVAILABLE_EXT: u16 = 0x8867;
pub const TIME_ELAPSED_EXT: u16 = 0x88BF;
pub const TIMESTAMP_EXT: u16 = 0x8E28;
pub const GPU_DISJOINT_EXT: u16 = 0x8FBB;
