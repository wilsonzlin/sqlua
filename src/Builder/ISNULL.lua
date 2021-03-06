local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function ISNULL(subject)
    local subjectType = Tools.getExpressionType(subject)

    if subjectType ~= ExpressionTypes.COLUMN then
        error({ message = "Attempted to construct SQL ISNULL expression from a non-column", code = 68 })
    end

    if not subject.nullable then
        error({ message = "Attempted to construct SQL ISNULL expression from column that cannot have NULL values", code = 69 })
    end

    return setmetatable({
        sql = string.format("(%s) IS NULL", Tools.getExpressionSQL(subject)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.COMPARISON_OPERATOR
    }, FrozenTableMetatable)
end

return ISNULL
