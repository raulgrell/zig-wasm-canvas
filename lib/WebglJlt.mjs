/**
 * webgl.jlt.mjs
 */
import BaseJtl from "./BaseJtl.mjs";

/**
 * Returns a String parsed from the given slice of a memory buffer.
 * 
 * @param {*} memory_buffer
 * @param {Number} offset 
 * @param {Number} length 
 * @returns {String}
 */
function slice2string(memory_buffer, offset, length) {
    const bytes = new Uint8Array(memory_buffer, offset, length);
    return new TextDecoder("utf-8").decode(bytes);
}

export default class WebglJlt extends BaseJtl {
    /**
     * The pattern emerging here is that a JLT holds three things in state:
     * 
     * 1. The LHS ("passive") context (already instantiated)
     * 
     * 2. The RHS ("active") context (to be instantiated with this API)
     * 
     * 3. Maps needed to translate references between the two
     * 
     * The remaining API exposed for binding to either side consists of enumerations/constants and "naked" function bindings that require no translation
     * 
     * A full API (as a map) can then be exported/exposed by this model to either side as needed
     * 
     * @param {WebGL2RenderingContext} webgl_context 
     */
    constructor(webgl_context) {
        super();
        this.gl = webgl_context;
        this.object_map = [];
        this.location_map = {};
    }

    getAttribLocation(program_id, strPtr, strLen) {
        const str = slice2string(this.memory.buffer, strPtr, strLen);
        if (!this.location_map.hasOwnProperty(program_id)) {
            this.location_map[program_id] = {};
        }
        if (!this.location_map[program_id].hasOwnProperty(str)) {
            const attloc = this.gl.getAttribLocation(this.object_map[program_id], str);
            this.object_map.push(attloc);
            this.location_map[program_id][str] = this.object_map.length - 1;
        }
        return this.location_map[program_id][str];
    }

    getUniformLocation(program_id, strPtr, strLen) {
        const str = slice2string(this.memory.buffer, strPtr, strLen);
        if (!this.location_map.hasOwnProperty(program_id)) {
            this.location_map[program_id] = {};
        }
        if (!this.location_map[program_id].hasOwnProperty(str)) {
            const uniloc = this.gl.getUniformLocation(this.object_map[program_id], str);
            this.object_map.push(uniloc);
            this.location_map[program_id][str] = this.object_map.length - 1;
        }
        return this.location_map[program_id][str];
    }

    vertexAttribPointer(attr_id, size, type, normalized, stride, offset) {
        const attr = this.object_map[attr_id];
        this.gl.vertexAttribPointer(attr, size, type, normalized, stride, offset);
    }

    enableVertexAttribArray(attr_id) {
        const attr = this.object_map[attr_id];
        this.gl.enableVertexAttribArray(attr);
    }

    createShader(type) {
        this.object_map.push(this.gl.createShader(type));
        return this.object_map.length - 1;
    }

    shaderSource(shader_id, strPtr, strLen) {
        const str = slice2string(this.memory.buffer, strPtr, strLen);
        this.gl.shaderSource(this.object_map[shader_id], str);
    }

    compileShader(shader_id) {
        this.gl.compileShader(this.object_map[shader_id]);
    }

    createProgram() {
        this.object_map.push(this.gl.createProgram());
        return this.object_map.length - 1;
    }

    attachShader(program_id, shader_id) {
        this.gl.attachShader(this.object_map[program_id], this.object_map[shader_id]);
    }

    linkProgram(program_id) {
        this.gl.linkProgram(this.object_map[program_id]);
    }

    createBuffer() {
        this.object_map.push(this.gl.createBuffer());
        return this.object_map.length - 1;
    }

    bufferData(type, dataPtr, count, drawType) {
        const floats = new Float32Array(this.memory.buffer, dataPtr, count);
        this.gl.bufferData(type, floats, drawType);
    }

    useProgram(program_id) {
        this.gl.useProgram(this.object_map[program_id]);
    }

    bindBuffer(type, buffer_id) {
        this.gl.bindBuffer(type, this.object_map[buffer_id]);
    }

    uniform4fv(location_id, x, y, z, w) {
        this.gl.uniform4fv(this.object_map[location_id], [x, y, z, w]);
    }

    _export_api() {
        return {
            "getAttribLocation": this.getAttribLocation.bind(this),
            "getUniformLocation": this.getUniformLocation.bind(this),
            "vertexAttribPointer": this.vertexAttribPointer.bind(this),
            "enableVertexAttribArray": this.enableVertexAttribArray.bind(this),
            "createShader": this.createShader.bind(this),
            "shaderSource": this.shaderSource.bind(this),
            "compileShader": this.compileShader.bind(this),
            "createProgram": this.createProgram.bind(this),
            "attachShader": this.attachShader.bind(this),
            "linkProgram": this.linkProgram.bind(this),
            "createBuffer": this.createBuffer.bind(this),
            "bufferData": this.bufferData.bind(this),
            "useProgram": this.useProgram.bind(this),
            "bindBuffer": this.bindBuffer.bind(this),
            "uniform4fv": this.uniform4fv.bind(this),

            // some stateless/referenceless methods can be passed directly from the web API
            "clearColor": this.gl.clearColor.bind(this.gl),
            "enable": this.gl.enable.bind(this.gl),
            "depthFunc": this.gl.depthFunc.bind(this.gl),
            "clear": this.gl.clear.bind(this.gl),
            "drawArrays": this.gl.drawArrays.bind(this.gl)
        };
    }
}
