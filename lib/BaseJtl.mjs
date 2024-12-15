/**
 * lib/BaseJttl.mjs
 * 
 * Guiding facts forcing an undesired translation layer:
 * 
 * * Every function that references a string requires an intermediate
 *   translation layer to interpret and forward the appropriate slice
 * 
 * * Every function that references or returns a WebGLObject of some type
 *   requires an intermediate translation layer to read/write map entries from
 *   indices
 * 
 * * There are also several other functions (like `bufferData()`) that require
 *   memory copies even though strings are not involved
 * 
 * * ...And of course there are functions (like get*Location) that have
 *   multiple requirements
 */

export default class BaseJtl {
    constructor() {
        this.memory = undefined;
    }

    _export_api() {
        return {};
    }
}
