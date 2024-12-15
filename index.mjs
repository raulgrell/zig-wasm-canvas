/**
 * index.mjs
 */

import wasm_url from "./bin/main.wasm?url";
import WebglJlt from "./lib/WebglJlt.mjs";
import ConsoleJtl from "./lib/ConsoleJtl.mjs";

function onWindowLoad(event) {
    // instantiate JTLs
    const console_jtl = new ConsoleJtl();
    const webgl_jtl = new WebglJlt(document.querySelector("canvas").getContext("webgl2"));

    // instantiate main WASM program
    setViewportDimensions();
    fetchAndInstantiate(wasm_url, {
        "Console": console_jtl._export_api(),
        "Webgl": webgl_jtl._export_api()
    }).then(function (instance) {
        // pass back memory buffer references to JTL instances
        console_jtl.memory = instance.exports.memory;
        webgl_jtl.memory = instance.exports.memory;

        // initialize
        instance.exports.enter();

        // loop
        function step(timestamp) {
            instance.exports.step(timestamp);
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

function setViewportDimensions() {
    const canvas = document.querySelector("canvas");
    const gl = canvas.getContext("webgl2");
    const bcr = canvas.getBoundingClientRect();
    canvas.width = bcr.width;
    canvas.height = bcr.height;
    gl.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

function onWindowResize(event) {
    console.log("Window resized:", event);
    const canvas = document.querySelector("canvas");
    const gl = canvas.getContext("webgl2");
    const bcr = canvas.getBoundingClientRect();
    canvas.width = bcr.width;
    canvas.height = bcr.height;
    gl.viewport(0, 0, bcr.width, bcr.height); // TODO: should be able to use bcr for all of them
}

window.addEventListener("load", onWindowLoad);
window.addEventListener("resize", onWindowResize);
