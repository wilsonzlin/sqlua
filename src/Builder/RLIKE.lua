local FrozenTableMetatable = require('Base.Lua.FrozenTableMetatable')
local Tools = require('Base.SQL.Tools')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

--[[

    NOTE: Regular expressions do not need to be escaped as a SQL string; e.g. the following is fine:

        ^"Name": 'Robert\nUp\t\d',\s+[A-Z]:\\Windows\\system32\\cmd\.exe -k (\{\}){1,3}$

    Obviously, when **typing** the above in Lua, you'll need to double any backslashes and escape any quote marks
    You'll also need to manually escape any part of the regex that you want to interpret as literal, as shown above

--]]
local function RLIKE(subject, regexp)
    local subjectType = Tools.getExpressionType(subject)

    if subjectType ~= ExpressionTypes.COLUMN then
        error({ message = "Attempted to construct SQL RLIKE expression from a non-column", code = 83 })
    end

    if subject.columnValuesType ~= ValueTypes.STRING then
        error({ message = "Attempted to construct SQL RLIKE expression from non-string column", code = 84 })
    end

    if type(regexp) ~= "string" then
        error({ message = "Attempted to construct SQL RLIKE expression from non-string regular expression", code = 85 })
    end

    return setmetatable({
        sql = string.format("(%s) RLIKE %s", Tools.getExpressionSQL(subject), ngx.quote_sql_str(regexp)),
        returns = ValueTypes.BOOLEAN,
        type = ExpressionTypes.COMPARISON_OPERATOR
    }, FrozenTableMetatable)
end

return RLIKE
