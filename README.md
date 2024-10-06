# zig-wasm-canvas

An example demonstrating Zig interacting with a canvas via JS. It is a port of one of the official mozilla examples. 

https://developer.mozilla.org/en-US/docs/WebAssembly

As of Zig v0.12.0, compile with the following command, which has also been verified with Zig v0.13.0:

```sh
zig build-exe src/main.zig -target wasm32-freestanding -fno-entry --export=onInit --export=onAnimationFrame
```

Once built, you may need to run a static file server to ensure local file loading issues with your browser don't prevent you from fetching the WASM module. I tend to use the following Python command, which works out of the box with most Python installations, but there are plenty of other alternatives:

```sh
python -m http.server
```
