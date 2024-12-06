/**
 * @file ConsoleJtl.mjs
 * 
 * Emerging JTL lifecycle pattern looks something like:
 * 
 * 1. JTL is instantiated
 * 
 * 1. JTL instance exports a map of bindings attached to import_object used in
 *    WASM module instantiation
 * 
 * 1. Once WASM module is instantiated, a memory buffer reference is forwarded
 *    "back" to the JTL instance
 * 
 * 1. Subsequent calls to the JTL API can reference the memory buffer reference
 *    within that instance's scope
 * 
 * 1. Ownership of the memory buffer of course still belongs to the WASM module
 *    instance
 */
export default class ConsoleJlt {
    constructor() {
        this.console_log_buffer = "";
        this.memory = undefined;
    }

    log(ptr, len) {
        const bytes = new Uint8Array(this.memory.buffer, ptr, len);
        const str = new TextDecoder().decode(bytes);
        console.log(str);
    }

    jsConsoleLogWrite(ptr, len) {
        this.console_log_buffer += new TextDecoder().decode(new Uint8Array(this.memory.buffer, ptr, len));
    }

    jsConsoleLogFlush() {
        console.log(this.console_log_buffer);
        this.console_log_buffer = "";
    }

    _export_api() {
        return {
            "jsConsoleLogWrite": this.jsConsoleLogWrite.bind(this),
            "jsConsoleLogFlush": this.jsConsoleLogFlush.bind(this),
            "log": this.log.bind(this)
        };
    }
}
