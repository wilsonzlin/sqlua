local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function EQ(left, right)
    if not Tools.areComparable(left, right) then
        error({ message = "Attempted to construct SQL EQ expression from different, invalid or NULL part types", code = 65 })
    end

    return setmetatable({
        sql = string.format("(%s) = (%s)", Tools.getExpressionSQL(left), Tools.getExpressionSQL(right)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.COMPARISON_OPERATOR
    }, FrozenTableMetatable)
end

return EQ
