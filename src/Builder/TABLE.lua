local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function TABLE(table, db)
    if db and Tools.getExpressionType(db) ~= ExpressionTypes.DATABASE then
        error({ message = "Database provided is invalid", code = 87 })
    end

    if type(table) ~= "table" or table._objectType ~= "table" then
        error({ message = "Invalid table", code = 88 })
    end

    if table._objectName:find("[%c%s`]") then
        error({ message = "Invalid table name", code = 122 })
    end

    return setmetatable({
        sql = (db and (Tools.getExpressionSQL(db) .. ".") or "") .. string.format("`%s`", table._objectName),
        sqlString = ngx.quote_sql_str(table._objectName),
        rawName = table._objectName,
        type = ExpressionTypes.TABLE
    }, FrozenTableMetatable)
end

return TABLE
