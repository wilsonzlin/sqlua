local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')

local function DATABASE(db)
    if type(db) ~= "table" or db._objectType ~= "database" then
        error({ message = "Invalid database", code = 253 })
    end

    if db._objectName:find("[%c%s`]") then
        error({ message = "Invalid database name", code = 123 })
    end

    return setmetatable({
        sql = string.format("`%s`", db._objectName),
        sqlString = ngx.quote_sql_str(db._objectName),
        rawName = db._objectName,
        type = ExpressionTypes.DATABASE
    }, FrozenTableMetatable)
end

return DATABASE
