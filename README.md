# zig-wasm-canvas

You can run the web application itself via Vite for HMR support, which now also includes automatic rebuilds (and reloads) of the WASM module when the Zig source is changed:

```sh
yarn install
yarn run dev
```

## Background

An example demonstrating Zig interacting with a canvas via JS. It was originally a port from one of the official Mozilla examples. 

https://developer.mozilla.org/en-US/docs/WebAssembly

This particular project was forked from the following port as a starting point for a testbed for Zig bindings to the WebGL API (and potentially others):

https://github.com/raulgrell/zig-wasm-webgl

As of Zig v0.13.0, the WASM module can be compiled directly with the following command:

```sh
zig build-exe src/main.zig -target wasm32-freestanding -fno-entry --export=onInit --export=onAnimationFrame -femit-bin=bin/main.wasm
```

## Notes For Future Me

The WebGL translation approach used here is a decent pattern that I wouldn't mind adapting to a variety of other browser APIs for utilization by Zig-driven WASM applications (although I would want to add more bindings first and probably organize the Javascript translation layer into its own module for each API).

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

* WebSockets API (e.g., streaming / event-driven data)

For lack of a better name, "Web API Definition" perhaps? Image (from DOM) could also be useful. Of courrse, a lot of this would be more intelligently handled by using a WebIDL specification to drive a comptime build of the bindings automatically--which would be amazing, but beyond my current Zig skill level. Doing so with the Javascript translation layer (with the appropriate object reference management) would be easier, and probably help the eventual transition to WebGPU. Another possibility may be to, cough, *borrow* some part of the implementation (either side) from the Emscripten equivalents.

## Documentation

As part of an effort to capture the full extend of the bindings and enumerations that might be required (after all, there's a specification, right?), you can view two CSVs under the `docs/webgl/` folder:

* [bindings.csv](./docs/web/bindings.csv) is a table of all WebGL (including WebGL2 and extensions) function calls, including their parameters and return types (in GL types) as well as a brief description and categorization from MDN

* [enums.csv](./docs/web/enums.csv) is a table of all WebGL (including WebGL2 and extensions) enumeration values, including their enunmeration names and hex values, as well as a brief description and categorization from MDN
