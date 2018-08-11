local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Utils = require('Base.Utils')
local Tools = require('Base.SQL.Tools')
local ValueTypes = require('Base.SQL.ValueTypes')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function AND(...)
    local sql = {}

    for _, arg in Utils.iterateArgs(...) do
        local argType = Tools.getExpressionReturnType(arg)
        if argType ~= ValueTypes.BOOLEAN then
            error({ message = "Attempted to construct SQL AND expression from non-boolean parts", code = 60 })
        end
        table.insert(sql, "(" .. Tools.getExpressionSQL(arg) .. ")")
    end

    if #sql < 2 then
        error({ message = "Not enough arguments", code = 59 })
    end

    return setmetatable({
        sql = table.concat(sql, " AND "),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.LOGICAL_OPERATOR
    }, FrozenTableMetatable)
end

return AND
