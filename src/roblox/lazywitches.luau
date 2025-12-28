local lazywitches = {}
lazywitches.defaultIfOptional = false

local Types = require(script.Parent.Parent.Types)

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

function lazywitches.deserialize<T>(data: any, datatype: Types.struct) : T
    local result = datatype:parse(data, "root")
    return result
end

function lazywitches.enableDefaultIfOptional(option: boolean): nil
    lazywitches.defaultIfOptional = option
end

function lazywitches.struct(fields: {any})
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

function lazywitches.list(element: any): Types.list
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

return lazywitches