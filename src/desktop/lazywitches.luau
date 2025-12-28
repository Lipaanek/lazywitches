local lazywitches = {}
lazywitches.defaultIfOptional = true

local Types = require("../Types")

--[[
    @param kind {string}
    @param expectedType {string}

    @returns LWDefault {@link Types.LWDefault}
]]
local function createPrimitive(kind: string, expectedType: string): Types.LWDefault
    return {
        kind = kind,
        isOptional = false,
        defaultVal = nil,
        parse = function(self, value: any, path: string): any
            if typeof(value) ~= expectedType then
                if self.defaultVal ~= nil then
                    return self.defaultVal
                end
                error(path .. ": expected " .. expectedType .. ", got " .. typeof(value))
            end
            return value
        end,
        default = function(self, value: any): Types.LWDefault
            if typeof(value) ~= expectedType then
                error("Field 'LW." .. kind .. "' cannot have default as " .. typeof(value))
            end
            self.defaultVal = value
            return self
        end,
        optional = function(self): Types.LWDefault
            self.isOptional = true
            return self
        end
    } :: Types.LWDefault
end

--[[
    @param data {struct} {@link Types.struct}
    @param datatype {struct} {@link Types.struct}

    @returns any

    function turns any given data and its datastructure into usable LW data
]]
function lazywitches.deserialize(data: any, datatype: Types.struct | Types.map): any
    local result = datatype:parse(data, "root")
    return result
end

--[[
    @param option {boolean}

    @returns nil

    this function allows the user to set if the :default() option is active during :optional()
]]
function lazywitches.enableDefaultIfOptional(option: boolean): nil
    lazywitches.defaultIfOptional = option
end

--[[
    @param fields {{any}}

    @returns struct {@link Types.struct}

    this function creates a default struct
]]
function lazywitches.struct(fields: {any}): Types.struct
    return {
        kind = "struct",
        fields = fields,
        parse = function(self, value: any, path: string): any
            local out = {}
            for name: string, schema: Types.LWDefault in pairs(self.fields) do
                local fieldValue = value[name] :: any
                if fieldValue == nil then
                    if schema.isOptional then
                        if schema.defaultVal ~= nil and lazywitches.defaultIfOptional == true then
                            out[name] = schema.defaultVal
                        else
                            out[name] = nil
                        end
                    else
                        error(path .. ": cannot have nil value without optional field")
                    end
                else
                    out[name] = schema:parse(value[name], path .. "." .. name)
                end
            end
            return out
        end
    } :: Types.struct
end

lazywitches.number = createPrimitive("number", "number")
lazywitches.string = createPrimitive("string", "string")
lazywitches.boolean = createPrimitive("boolean", "boolean")
lazywitches.any = createPrimitive("any", "any")
lazywitches.instance = createPrimitive("instance", "Instance")

--[[
    @param element {Types} - all the types

    @returns list {@link Types.list}

    this function creates list for LW datastructure
]]
function lazywitches.list(element: Types.LWDefault | Types.struct | Types.map | Types.list): Types.list
    return {
        kind = "list",
        element = element,
        parse = function(self, value: any, path: string): any
            if typeof(value) ~= "table" then error(path .. ": expected list, got " .. typeof(value)) end
            local out = {}
            for i, v in ipairs(value) do
                out[i] = self.element:parse(v, path .. "[" .. i .. "]")
            end
            return out
        end
    } :: Types.list
end

--[[
    @param key {LWDefault} {@link Types.LWDefault}
    @param value {struct | LWDefault} {@link Types.struct & Types.LWDefault}

    @returns map {@link Types.map}

    this function creates Map<key, value>
]]
function lazywitches.map(key: Types.LWDefault, value: Types.struct | Types.LWDefault): Types.map
    if key.kind ~= "string" then
        error("cannot create a map with key of type: " .. key.kind)
    end

    if value == nil then
        value = key
    end

    return {
        kind = "map",
        key = key,
        value = value,

        parse = function(self, value: any, path: string): any
            if typeof(value) ~= "table" then
                error(path .. ": expected table, got " .. typeof(value))
            end

            local out = {}

            for key, val in pairs(value) do
                self.key:parse(key, path .. " (key)")

                out[key] = self.value:parse(val, path .. "." .. tostring(key))
            end

            return out
        end
    }
end

return lazywitches