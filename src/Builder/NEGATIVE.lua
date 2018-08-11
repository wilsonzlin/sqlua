local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function NEGATIVE(expression)
    local expressionType = Tools.getNumericDataType(expression)

    if not expressionType then
        error({ message = "Attempted to construct SQL NEGATIVE expression from a non-numeric expression", code = 252 })
    end

    return setmetatable({
        sql = string.format("-(%s)", Tools.getExpressionSQL(expression)),
        returns = expressionType,
        type = ExpressionTypes.NUMERIC_OPERATOR
    }, FrozenTableMetatable)
end

return NEGATIVE
