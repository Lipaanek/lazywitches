local Types = {}

export type struct = {
    kind: string,
    fields: {any},
    parse: (...any) -> (any)
}

export type list = {
    kind: string,
    element: any,
    parse: (...any) -> (any),
}

export type LWDefault = {
    kind: string,
    defaultVal: any | nil,
    isOptional: boolean,
    optional: (self: any) -> (LWDefault),
    default: (self: any, value: any) -> (LWDefault),
    parse: (self: any, value: any, path: string) -> (any)
}

export type optional = {
    kind: string,
    field: LWDefault,
    parse: (self: any, value: any, path: string) -> (any)
}

return Types