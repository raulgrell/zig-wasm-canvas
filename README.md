# zig-wasm-canvas

An example demonstrating Zig interacting with a canvas via JS. It is a port of
one of the official mozilla examples. 

https://developer.mozilla.org/en-US/docs/WebAssembly

As of Zig v0.12.0, compile with the following command:

```sh
zig build-exe main.zig -target wasm32-freestanding -fno-entry --export=onInit --export=onAnimationFrame
```
