local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function BINVERT(left)
    local leftType = Tools.getNumericDataType(left)

    if leftType ~= ValueTypes.UNSIGNED_INTEGER then
        error({ message = "Attempted to construct SQL BINVERT expression from an expression that is not an unsigned integer", code = 106 })
    end

    return setmetatable({
        sql = string.format("~(%s)", Tools.getExpressionSQL(left)),
        returns = ValueTypes.UNSIGNED_INTEGER,
        type = ExpressionTypes.BITWISE_OPERATOR
    }, FrozenTableMetatable)
end

return BINVERT
