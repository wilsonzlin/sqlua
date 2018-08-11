local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')
local TABLE = require('Base.SQL.Builder.TABLE')

local function COLUMN(column, db)
    if db and Tools.getExpressionType(db) ~= ExpressionTypes.DATABASE then
        error({ message = "Database provided is invalid", code = 61 })
    end

    if type(column) ~= "table" or column._objectType ~= "column" then
        error({ message = "Invalid column", code = 63 })
    end

    if column.name:find("[%c%s`]") then
        error({ message = "Invalid column name", code = 14 })
    end

    local table = TABLE(column._parentTable)

    local columnValuesType
    if column.type == "integer" then
        columnValuesType = column.unsigned and ValueTypes.UNSIGNED_INTEGER or ValueTypes.SIGNED_INTEGER
    elseif column.type == "serial" then
        columnValuesType = ValueTypes.UNSIGNED_INTEGER
    elseif column.type == "string" then
        columnValuesType = ValueTypes.STRING
    elseif column.type == "binary" then
        columnValuesType = ValueTypes.BINARY
    elseif column.type == "boolean" then
        columnValuesType = ValueTypes.BOOLEAN
    elseif column.type == "code" then
        columnValuesType = ValueTypes.UNSIGNED_INTEGER
    else
        error({ message = "Unrecognised column type", code = 100 })
    end

    return setmetatable({
        sql = (db and (Tools.getExpressionSQL(db) .. ".") or "") .. Tools.getExpressionSQL(table) .. "." .. string.format("`%s`", column.name),
        sqlString = ngx.quote_sql_str(column.name),
        rawName = column.name,
        type = ExpressionTypes.COLUMN,
        nullable = rawget(column, "nullable") or false,
        columnValuesType = columnValuesType,
    }, FrozenTableMetatable)
end

return COLUMN
