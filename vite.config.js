/**
 * vite.config.js
 */

import { spawn } from "child_process";
import path from "path";

function zigWasmPlugin() {
    return {
        name: "zig-wasm-rebuild",

        configureServer(server) {
            // Check if the changed file is in the Zig source directory
            const rootRuntimeDir = path.resolve(__dirname, "./");
            const zigSourceDir = path.resolve(__dirname, "./src/");
            const wasmOutputPath = path.resolve(__dirname, "./bin/main.wasm");
            server.watcher.add(zigSourceDir);

            // on change, rebuild the WASM module and reload the appliccation
            server.watcher.on("change", (file) => {
                if (file.endsWith(".zig")) {
                    const buildProcess = spawn("zig", [
                        "build-exe",
                        "src/main.zig",
                        "-target", "wasm32-freestanding",
                        "-fno-entry",
                        "--export=onInit",
                        "--export=onAnimationFrame",
                        `-femit-bin=${wasmOutputPath}`
                    ], {
                        cwd: rootRuntimeDir,
                        stdio: "inherit"
                    });

                    // trigger a full page reload if the build succeeds
                    buildProcess.on("close", (code) => {
                        if (code === 0) {
                            server.ws.send({
                                type: "full-reload"
                            });
                        }
                    });
                }
            });
        }
    };
}

export default {
    plugins: [
        zigWasmPlugin()
    ]
};
