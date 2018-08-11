local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local function NOT(subject)
    local subjectType = Tools.getExpressionReturnType(subject)

    if subjectType ~= ValueTypes.BOOLEAN then
        error({ message = "Attempted to construct SQL NOT expression from a non-boolean", code = 264 })
    end

    return setmetatable({
        sql = string.format("NOT (%s)", Tools.getExpressionSQL(subject)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.LOGICAL_OPERATOR
    }, FrozenTableMetatable)
end

return NOT
