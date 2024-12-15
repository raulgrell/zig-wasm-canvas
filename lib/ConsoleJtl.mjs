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

import BaseJtl from "./BaseJtl.mjs";

function getStringFromBuffer(buffer, ptr, len) {
    const bytes =  new Uint8Array(buffer, ptr, len);
    const str = new TextDecoder().decode(bytes);
    return str;
}

export default class ConsoleJlt extends BaseJtl {
    constructor() {
        super();
        this.console_log_buffer = "";
    }

    assert(is_expr_true, ptr, len) {
        if (len > 0) {
            const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.assert(is_expr_true, msg);
        } else {
            console.assert(is_expr_true);
        }
    }

    clear() {
        console.clear();
    }

    count(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.count(tag);
        } else {
            console.count();
        }
    }

    countReset(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.countReset(tag);
        } else {
            console.countReset();
        }
    }
    
    debug(ptr, len) {
        const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
        console.debug(msg);
    }

    // error(ptr, len) {
    //     const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
    //     console.error(msg);
    // }

    info(ptr, len) {
        const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
        console.info(msg);
    }

    log(ptr, len) {
        const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
        console.log(msg);
    }

    // table(data, columns) {
    //     console.error("console.table() not yet implemented");
    // }

    trace() {
        console.trace();
    }

    warn(ptr, len) {
        const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
        console.warn(msg);
    }

    // dir(object) {
    //     console.error("console.dir() not yet implemented");
    // }

    // dirxml(object) {
    //     console.error("console.dirxml() not yet implemented");
    // }

    group(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.group(tag);
        } else {
            console.group();
        }
    }

    groupCollapsed(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.groupCollapsed(tag);
        } else {
            console.groupCollapsed();
        }
    }

    groupEnd() {
        console.groupEnd();
    }

    time(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.time(tag);
        } else {
            console.time();
        }
    }

    timeLog(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.timeLog(tag);
        } else {
            console.timeLog();
        }
    }

    timeEnd(ptr, len) {
        if (len > 0) {
            const tag = getStringFromBuffer(this.memory.buffer, ptr, len);
            console.timeEnd(tag);
        } else {
            console.timeEnd();
        }
    }

    exception(ptr, len) {
        const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
        console.error(msg);
    }

    // timeStamp(ptr, len) {
    //     if (len > 0) {
    //         const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
    //         console.timeStamp(msg);
    //     } else {
    //         console.timeStamp();
    //     }
    // }

    // profile(ptr, len) {
    //     if (len > 0) {
    //         const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
    //         console.profile(msg);
    //     } else {
    //         console.profile();
    //     }
    // }

    // profileEnd(ptr, len) {
    //     if (len > 0) {
    //         const msg = getStringFromBuffer(this.memory.buffer, ptr, len);
    //         console.profileEnd(msg);
    //     } else {
    //         console.profileEnd();
    //     }
    // }

    _export_api() {
        return {
            "log": this.log.bind(this),
            "assert": this.assert.bind(this),
            "clear": this.clear.bind(this),
            "count": this.count.bind(this),
            "countReset": this.countReset.bind(this),
            "debug": this.debug.bind(this),
            // "error": this.error.bind(this),
            "info": this.info.bind(this),
            "log": this.log.bind(this),
            // table
            "trace": this.trace.bind(this),
            "warn": this.warn.bind(this),
            // dir
            // dirxml
            "group": this.group.bind(this),
            "groupCollapsed": this.groupCollapsed.bind(this),
            "groupEnd": this.groupEnd.bind(this),
            "time": this.time.bind(this),
            "timeLog": this.timeLog.bind(this),
            "timeEnd": this.timeEnd.bind(this),
            "exception": this.exception.bind(this),
            // "timeStamp": this.timeStamp.bind(this),
            // "profile": this.profile.bind(this),
            // "profileEnd": this.profileEnd.bind(this)
        };
    }
}
