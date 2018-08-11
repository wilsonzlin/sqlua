local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ValueTypes = require('Base.SQL.ValueTypes')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local CAST = {}

CAST.SIGNED_INTEGER = {
    sql = "SIGNED",
    resultingValueType = ValueTypes.SIGNED_INTEGER,
}

local function constructor(_, value, as)
    if type(as) ~= "table" or not as.sql or not as.resultingValueType then
        error({ message = "Invalid cast", code = 185 })
    end

    return setmetatable({
        sql = "CAST(" .. Tools.getExpressionSQL(value) .. " as " .. as.sql .. ")",
        returns = as.resultingValueType,
        type = ExpressionTypes.FUNCTION
    }, FrozenTableMetatable)
end

local metatable = {
    __call = constructor
}

return setmetatable(CAST, metatable)
