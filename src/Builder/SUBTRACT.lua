local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function SUBTRACT(left, right)
    local leftType = Tools.getNumericDataType(left)
    local rightType = Tools.getNumericDataType(right)

    if not leftType or not rightType then
        error({ message = "Attempted to construct SQL SUBTRACT expression from non-numeric part types", code = 86 })
    end

    return setmetatable({
        sql = string.format("(%s) - (%s)", Tools.getExpressionSQL(left), Tools.getExpressionSQL(right)),
        returns = Tools.normalNumberType(leftType, rightType),
        type = ExpressionTypes.NUMERIC_OPERATOR
    }, FrozenTableMetatable)
end

return SUBTRACT
