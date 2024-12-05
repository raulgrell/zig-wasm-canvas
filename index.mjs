/**
 * index.mjs
 */

import wasm_url from "./bin/main.wasm?url";

const APP = {
    "memory": undefined,
    "canvas": document.querySelector("canvas")
};

const GL = APP.canvas.getContext("webgl2");
const OBJECT_MAP = []; // maps index/u32 against a WebGLObject reference
const LOCATION_MAP = {}; // maps program IDs to a second map of names against program locations; this prevents redundant references to identical locations, which are not strongl equivalent once passed back from the WebGL API
var CONSOLE_LOG_BUFFER = "";

// guiding facts forcing an undesired translation layer
// * every function that references a string requires an intermediate translation layer to interpret and forward the appropriate slice
// * every function that references or returns a WebGLObject of some type requires an intermediate translation layer to read/write map entries from indices
// * there are also several other functions (like `bufferData()`) that require memory copies even though strings are not involved
// * and of course there are functions (like get*Location) that have multiple requirements
const ENV = {
    "getAttribLocation": (program_id, strPtr, strLen) => { // new (breaks)
        // specifically, this breaks because the subsequent attribute "reference" (its index in the OBJECT_MAP) is actually passed directly to enableVertexAttribArray(), which needs to be overwritten
        const str = slice2string(APP, strPtr, strLen);
        if (!LOCATION_MAP.hasOwnProperty(program_id)) {
            LOCATION_MAP[program_id] = {};
        }
        if (!LOCATION_MAP[program_id].hasOwnProperty(str)) {
            const attloc = GL.getAttribLocation(OBJECT_MAP[program_id], str);
            OBJECT_MAP.push(attloc);
            LOCATION_MAP[program_id][str] = OBJECT_MAP.length - 1;
        }
        return LOCATION_MAP[program_id][str];
    },
    "getUniformLocation": (program_id, strPtr, strLen) => { // new
        const str = slice2string(APP, strPtr, strLen);
        if (!LOCATION_MAP.hasOwnProperty(program_id)) {
            LOCATION_MAP[program_id] = {};
        }
        if (!LOCATION_MAP[program_id].hasOwnProperty(str)) {
            const uniloc = GL.getUniformLocation(OBJECT_MAP[program_id], str);
            OBJECT_MAP.push(uniloc);
            LOCATION_MAP[program_id][str] = OBJECT_MAP.length - 1;
        }
        return LOCATION_MAP[program_id][str];
    },
    "vertexAttribPointer": (attr_id, size, type, normalized, stride, offset) => {
        const attr = OBJECT_MAP[attr_id];
        GL.vertexAttribPointer(attr, size, type, normalized, stride, offset);
    },
    "enableVertexAttribArray": (attr_id) => {
        const attr = OBJECT_MAP[attr_id];
        GL.enableVertexAttribArray(attr);
    },
    "createShader": (type) => {
        OBJECT_MAP.push(GL.createShader(type));
        return OBJECT_MAP.length - 1;
    },
    "shaderSource": (shader_id, strPtr, strLen) => {
        const str = slice2string(APP, strPtr, strLen);
        GL.shaderSource(OBJECT_MAP[shader_id], str);
    },
    "compileShader": (shader_id) => {
        GL.compileShader(OBJECT_MAP[shader_id]);
    },
    "createProgram": () => {
        OBJECT_MAP.push(GL.createProgram());
        return OBJECT_MAP.length - 1;
    },
    "attachShader": (program_id, shader_id) => {
        GL.attachShader(OBJECT_MAP[program_id], OBJECT_MAP[shader_id]);
    },
    "linkProgram": (program_id) => {
        GL.linkProgram(OBJECT_MAP[program_id]);
    },
    "createBuffer": () => {
        OBJECT_MAP.push(GL.createBuffer());
        return OBJECT_MAP.length - 1;
    },
    "bufferData": (type, dataPtr, count, drawType) => {
        const floats = new Float32Array(APP.memory.buffer, dataPtr, count);
        GL.bufferData(type, floats, drawType);
    },
    "useProgram": (program_id) => {
        GL.useProgram(OBJECT_MAP[program_id]);
    },
    "bindBuffer": (type, buffer_id) => {
        GL.bindBuffer(type, OBJECT_MAP[buffer_id]);
    },
    "uniform4fv": (location_id, x, y, z, w) => {
        GL.uniform4fv(OBJECT_MAP[location_id], [x, y, z, w]);
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
    setViewportFromApp(APP);
    fetchAndInstantiate(wasm_url, {
        "gl": {
            ...generateGlApi(GL),
            ...ENV
        },
        "sys": {
            "jsConsoleLogWrite": (ptr, len) => {
                CONSOLE_LOG_BUFFER += new TextDecoder().decode(new Uint8Array(APP.memory.buffer, ptr, len));
            },
            "jsConsoleLogFlush": () => {
                console.log(CONSOLE_LOG_BUFFER);
                CONSOLE_LOG_BUFFER = "";
            }
        },
        "env": {
            ...generateGlApi(GL),
            ...ENV, // some functions from GL are transcribed and therefore must override the generated API
        }
    }).then(function (instance) {
        APP.memory = instance.exports.memory;
        instance.exports.onInit();

        const onAnimationFrame = instance.exports.onAnimationFrame;

        function step(timestamp) {
            onAnimationFrame(timestamp);
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
    GL.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

function onWindowResize(event) {
    console.log("Window resized:", event);
    const bcr = APP.canvas.getBoundingClientRect();
    APP.canvas.width = bcr.width;
    APP.canvas.height = bcr.height;
    GL.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

window.addEventListener("load", onWindowLoad);
window.addEventListener("resize", onWindowResize);
