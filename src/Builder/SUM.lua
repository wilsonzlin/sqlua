local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ValueTypes = require('Base.SQL.ValueTypes')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function SUM(what)
    local dataType = Tools.getDataType(what)

    if not ValueTypes.SUPERTYPES.NUMBER:has(dataType) then
        error({ message = "Attempted to construct SQL SUM expression from non-numeric-type expression", code = 62 })
    end

    return setmetatable({
        sql = "SUM(" .. Tools.getExpressionSQL(what) .. ")",
        returns = dataType,
        type = ExpressionTypes.FUNCTION
    }, FrozenTableMetatable)
end

return SUM
