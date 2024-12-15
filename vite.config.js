/**
 * vite.config.js
 */

import fs from "fs";
import { spawn } from "child_process";
import path from "path";

const zigSourceDir = path.resolve(__dirname, "./src/");
const rootRuntimeDir = path.resolve(__dirname, "./");
const wasmOutputPath = path.resolve(__dirname, "./bin/main.wasm");
const build_args = [
    "build-exe",
    "src/main.zig",
    "-target", "wasm32-freestanding",
    "-fno-entry",
    "--export=enter",
    "--export=step",
    "--export=exit",
    `-femit-bin=${wasmOutputPath}`
];

function zigWasmPlugin() {
    return {
        name: "zig-wasm-rebuild",

        config(config, env) {
            if (!fs.existsSync(wasmOutputPath)) {
                const buildProcess = spawn("zig", build_args, {
                    cwd: rootRuntimeDir,
                    stdio: "inherit",
                    sync: true
                });
            }
        },

        configureServer(server) {
            // Check if the changed file is in the Zig source directory
            server.watcher.add(zigSourceDir);
        },

        handleHotUpdate({file, server}) {
            // on change, rebuild the WASM module and reload the appliccation
    
            if (file.endsWith(".zig")) {
                const buildProcess = spawn("zig", build_args, {
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
        }
    };
}

export default {
    plugins: [
        zigWasmPlugin()
    ]
};
