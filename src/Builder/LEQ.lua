local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function LEQ(left, right)
    local leftType = Tools.getNumericDataType(left)
    local rightType = Tools.getNumericDataType(right)

    if not leftType or not rightType then
        error({ message = "Attempted to construct SQL LEQ expression from non-numeric part types", code = 71 })
    end

    return setmetatable({
        sql = string.format("(%s) <= (%s)", Tools.getExpressionSQL(left), Tools.getExpressionSQL(right)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.COMPARISON_OPERATOR
    }, FrozenTableMetatable)
end

return LEQ
