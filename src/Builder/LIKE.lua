local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

--[[

    NOTE: SQL patterns do not need to be escaped as a SQL string; e.g. the following is fine:

        "Margins\_per\_capita": ["50\%", "'--'", "__\%", %]

    Obviously, when **typing** the above in Lua, you'll need to double any backslashes and escape any quote marks
    You'll also need to manually escape any part of the pattern that you want to interpret as literal, as shown above

--]]
local function LIKE(subject, pattern)
    local subjectType = Tools.getExpressionType(subject)

    if subjectType ~= ExpressionTypes.COLUMN then
        error({ message = "Attempted to construct SQL LIKE expression from a non-column", code = 72 })
    end

    if subject.columnValuesType ~= ValueTypes.STRING then
        error({ message = "Attempted to construct SQL RLIKE expression from non-string column", code = 73 })
    end

    if type(pattern) ~= "string" then
        error({ message = "Attempted to construct SQL LIKE expression from non-string pattern", code = 74 })
    end

    return setmetatable({
        sql = string.format("(%s) LIKE %s", Tools.getExpressionSQL(subject), ngx.quote_sql_str(pattern)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.COMPARISON_OPERATOR
    }, FrozenTableMetatable)
end

return LIKE
