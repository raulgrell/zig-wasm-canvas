/**
 * index.mjs
 */

import wasm_url from "./bin/main.wasm?url";
import WebglJlt from "./WebglJlt.mjs";
import ConsoleJtl from "./ConsoleJtl.mjs";

const APP = {
    "memory": undefined,
    "canvas": document.querySelector("canvas"),
    "gl": document.querySelector("canvas").getContext("webgl2"),
    "object_map": [], // maps index/u32 against a WebGLObject reference
    "location_map": {} // maps program IDs to a second map of names against program locations; this prevents redundant references to identical locations, which are not strongl equivalent once passed back from the WebGL API
};

const WEBGL_JLT = new WebglJlt(document.querySelector("canvas").getContext("webgl2"), undefined);

/**
 * Guiding facts forcing an undesired translation layer:
 * 
 * * Every function that references a string requires an intermediate
 *   translation layer to interpret and forward the appropriate slice
 * 
 * * Every function that references or returns a WebGLObject of some type
 *   requires an intermediate translation layer to read/write map entries from
 *   indices
 * 
 * * There are also several other functions (like `bufferData()`) that require
 *   memory copies even though strings are not involved
 * 
 * * ...And of course there are functions (like get*Location) that have
 *   multiple requirements
 */
const ENV = {
    "getAttribLocation": (program_id, strPtr, strLen) => {
        const str = slice2string(APP, strPtr, strLen);
        if (!APP.location_map.hasOwnProperty(program_id)) {
            APP.location_map[program_id] = {};
        }
        if (!APP.location_map[program_id].hasOwnProperty(str)) {
            const attloc = APP.gl.getAttribLocation(APP.object_map[program_id], str);
            APP.object_map.push(attloc);
            APP.location_map[program_id][str] = APP.object_map.length - 1;
        }
        return APP.location_map[program_id][str];
    },
    "getUniformLocation": (program_id, strPtr, strLen) => { // new
        const str = slice2string(APP, strPtr, strLen);
        if (!APP.location_map.hasOwnProperty(program_id)) {
            APP.location_map[program_id] = {};
        }
        if (!APP.location_map[program_id].hasOwnProperty(str)) {
            const uniloc = APP.gl.getUniformLocation(APP.object_map[program_id], str);
            APP.object_map.push(uniloc);
            APP.location_map[program_id][str] = APP.object_map.length - 1;
        }
        return APP.location_map[program_id][str];
    },
    "vertexAttribPointer": (attr_id, size, type, normalized, stride, offset) => {
        const attr = APP.object_map[attr_id];
        APP.gl.vertexAttribPointer(attr, size, type, normalized, stride, offset);
    },
    "enableVertexAttribArray": (attr_id) => {
        const attr = APP.object_map[attr_id];
        APP.gl.enableVertexAttribArray(attr);
    },
    "createShader": (type) => {
        APP.object_map.push(APP.gl.createShader(type));
        return APP.object_map.length - 1;
    },
    "shaderSource": (shader_id, strPtr, strLen) => {
        const str = slice2string(APP, strPtr, strLen);
        APP.gl.shaderSource(APP.object_map[shader_id], str);
    },
    "compileShader": (shader_id) => {
        APP.gl.compileShader(APP.object_map[shader_id]);
    },
    "createProgram": () => {
        APP.object_map.push(APP.gl.createProgram());
        return APP.object_map.length - 1;
    },
    "attachShader": (program_id, shader_id) => {
        APP.gl.attachShader(APP.object_map[program_id], APP.object_map[shader_id]);
    },
    "linkProgram": (program_id) => {
        APP.gl.linkProgram(APP.object_map[program_id]);
    },
    "createBuffer": () => {
        APP.object_map.push(APP.gl.createBuffer());
        return APP.object_map.length - 1;
    },
    "bufferData": (type, dataPtr, count, drawType) => {
        const floats = new Float32Array(APP.memory.buffer, dataPtr, count);
        APP.gl.bufferData(type, floats, drawType);
    },
    "useProgram": (program_id) => {
        APP.gl.useProgram(APP.object_map[program_id]);
    },
    "bindBuffer": (type, buffer_id) => {
        APP.gl.bindBuffer(type, APP.object_map[buffer_id]);
    },
    "uniform4fv": (location_id, x, y, z, w) => {
        APP.gl.uniform4fv(APP.object_map[location_id], [x, y, z, w]);
    }
};

function generateGlApi(gl) {
    const api = {};
    window.glFunctions = [];
    window.glConstants = [];
    for (const key in gl) {
        if (typeof (gl[key]) === "function") {
            api[key] = gl[key].bind(gl);
            window.glFunctions.push(key);
        } else if (typeof (gl[key]) === "number") {
            api[key] = gl[key];
            window.glConstants.push(key);
        }
    }
    return api;
}

function onWindowLoad(event) {
    const console_jtl = new ConsoleJtl();

    setViewportFromApp(APP);
    fetchAndInstantiate(wasm_url, { // this requires a significant rewrite, which will probably best line up with the API modularization
        "gl": {
            ...generateGlApi(APP.gl), // first generate API procedurally...
            ...ENV // ...then override with translation bindings where necessary
        },
        "Console": console_jtl._export_api()

    }).then(function (instance) {
        // pass back memory buffer references to JTL instances
        APP.memory = instance.exports.memory;
        console_jtl.memory = instance.exports.memory;

        // initialize
        instance.exports.onInit();

        // loop
        function step(timestamp) {
            instance.exports.onAnimationFrame(timestamp);
            window.requestAnimationFrame(step);
        }
        window.requestAnimationFrame(step);
    });
}

function fetchAndInstantiate(url, importObject) {
    return fetch(url).then(response =>
        response.arrayBuffer()
    ).then(bytes =>
        WebAssembly.instantiate(bytes, importObject)
    ).then(results =>
        results.instance
    );
}

function slice2string(app, ptr, len) {
    const bytes = new Uint8Array(app.memory.buffer, ptr, len);
    return new TextDecoder("utf-8").decode(bytes);
}

function setViewportFromApp(app) {
    const bcr = app.canvas.getBoundingClientRect();
    app.canvas.width = bcr.width;
    app.canvas.height = bcr.height;
    APP.gl.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

function onWindowResize(event) {
    console.log("Window resized:", event);
    const bcr = APP.canvas.getBoundingClientRect();
    APP.canvas.width = bcr.width;
    APP.canvas.height = bcr.height;
    APP.gl.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

window.addEventListener("load", onWindowLoad);
window.addEventListener("resize", onWindowResize);
