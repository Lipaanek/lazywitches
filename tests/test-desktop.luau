-- desktop test
local lazywitches = require("../src/desktop/lazywitches")


local util = require("../src/helperUtils")

local data1 = { 
    table = {
        model = "tablemodel",
        icon = "rbxassetid://"
    },
    chair = {
        model = "chairmodel",
        icon = "rbxassetid://"
    },
}

local furnitureStruct = lazywitches.struct { model = lazywitches.string, icon = lazywitches.string }
local struct1 = lazywitches.map(lazywitches.string, furnitureStruct)

local result1 = lazywitches.deserialize(data1, struct1)
util.print_table(result1)