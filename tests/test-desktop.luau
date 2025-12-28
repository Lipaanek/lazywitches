-- desktop test
local lazywitches = require("../src/desktop/lazywitches")


local util = require("../src/helperUtils")

local data1 = { 
    players = {
        { id = 5, isAlive = true },
        { id = 56, isAlive = false }
    }
}

local data2 = {
    isAlive = true,
}

local struct1 = lazywitches.struct { players = lazywitches.list( lazywitches.struct { id = lazywitches.number, isAlive = lazywitches.boolean } ) }
local struct2 = lazywitches.struct { id = lazywitches.number:optional():default(0), isAlive = lazywitches.boolean:optional() }

lazywitches.enableDefaultIfOptional(true) -- if optional is turned on and the value does not exist, then default gets applied

local result1 = lazywitches.deserialize(data1, struct1)
local result2 = lazywitches.deserialize(data2, struct2)
util.print_table(result1)
util.print_table(result2)