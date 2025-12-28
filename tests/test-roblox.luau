-- roblox test
local lazywitches = require(script.Parent.Parent.roblox.lazywitches)

local util = require(script.Parent.Parent.helperUtils)

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

local data2 = {
    model = Instance.new("Part")
}

local furnitureStruct = lazywitches.struct { model = lazywitches.string, icon = lazywitches.string }
local struct1 = lazywitches.map(lazywitches.string, furnitureStruct)

local struct2 = lazywitches.struct { model = lazywitches.instance }

local result1 = lazywitches.deserialize(data1, struct1)
util.print_table(result1)

local result2 = lazywitches.deserialize(data2, struct2)
util.print_table(result2)