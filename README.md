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

## 

The WebGL translation approach used here is a decent pattern that I wouldn't mind adapting to a variety of other browser APIs for utilization by Zig-driven WASM applications.

Consider the following subset of APIs drawn from the MDN listing (https://developer.mozilla.org/en-US/docs/Web/API):

* Console API

* Canvas API (in general--e.g., 2d rasterization)

* Clipboard API

* DOM (some limited subset)

* Fetch API (e.g., use browser as a REST provider)

* Keyboard API (e.g., direct / lower-level keydown listeners)

* SVG (e.g., 2d vectorized graphics)

* Screen Orientation API (and/or other hooks for responsive layout)

* Storage Access API / Web Storage API (session/local or other persistent buffer interfaces)

* UI Events (as an alternativee to Keyboard API?)

* Web Workers API (as a means to subthread module interfaces)

* WebGPU API (experimental and unsupported by Firefox--!?)

* WebSockets API (e.g., streaming / event-driven data)

For lack of a better name, "Web API Definition" perhaps? Image (from DOM) could also be useful.
