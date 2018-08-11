local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function BLSHIFT(left, right)
    local leftType = Tools.getNumericDataType(left)
    local rightType = Tools.getNumericDataType(right)

    if leftType ~= ValueTypes.UNSIGNED_INTEGER or rightType ~= ValueTypes.UNSIGNED_INTEGER then
        error({ message = "Attempted to construct SQL BLSHIFT expression from non-unsigned-integer part types", code = 104 })
    end

    return setmetatable({
        sql = string.format("(%s) << (%s)", Tools.getExpressionSQL(left), Tools.getExpressionSQL(right)),
        returns = ValueTypes.UNSIGNED_INTEGER,
        type = ExpressionTypes.BITWISE_OPERATOR
    }, FrozenTableMetatable)
end

return BLSHIFT
