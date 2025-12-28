-- desktop luau
local lazywitches = require("../src/lazywitches")

local personSchema = lazywitches.struct {
    name = lazywitches.string,
    age = lazywitches.number:optional():default(18),
    isActive = lazywitches.boolean
}

local data = {
    name = "Alice",
    isActive = true
}

local person = lazywitches.deserialize(data, personSchema)

print("Name:", person.name)
print("Age:", person.age)
print("Active:", person.isActive)