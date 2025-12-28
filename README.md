# Lazy Witches

A lightweight, efficient data serialization and deserialization library for Lua and Luau, designed for Roblox and desktop environments.

## Features

- Schema-based validation and parsing
- Support for structs, lists, and primitive types (number, string, boolean)
- Optional fields with defaults
- Type-safe with Luau
- Easy to use API

## Installation

### Roblox

Copy the `src/` directory to your Roblox project. Require the modules as needed.

Example:

```lua
local lazywitches = require(script.Parent.src.lazywitches)
```

### Desktop Luau

Clone the repository and require from the root.

```lua
local lazywitches = require("./src/lazywitches")
```

## Quick Start

Define a schema and deserialize data.

```lua
local lazywitches = require("./src/lazywitches")

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
print(person.name) -- Alice
print(person.age) -- 18 (default)
print(person.isActive) -- true
```

## API

### Primitives

- `lazywitches.number`: For numbers
- `lazywitches.string`: For strings
- `lazywitches.boolean`: For booleans
- `lazywitches.any`: For any value
- `lazywitches.instance`: For instances (ROBLOX ONLY!)

Modifiers:

- `:optional()`: Makes the field optional
- `:default(value)`: Sets default value for optional fields
- `:enableDefaultIfOptional(boolean)`: Decides if to apply default value if optional field is nil

### Structs

`lazywitches.struct(fields)`: Creates a struct schema with the given fields.

### Lists

`lazywitches.list(element)`: Creates a list schema with the given element type.

### Maps

`lazywitches.map(key, value)`: Creates a new map of Map<key, value>. It's used for repeated elements like for example list of buildings and their properties.

### Deserialization

`lazywitches.deserialize(data, schema)`: Parses the data according to the schema.

## Examples

See `examples/` for more usage examples.

## Testing

Run the tests:

For desktop: `luau tests/test.luau`

For Roblox: Run the test script in Studio.

## Comparisons

Compared to JSON libraries, Lazy Witches provides schema validation and type safety, making it more robust for data parsing in games and applications.

## License

MIT License. See LICENSE file.
