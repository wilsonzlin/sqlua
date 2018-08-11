local Utils = require('Base.Utils')
local ExpressionTypes = require('Base.SQL.ExpressionTypes')
local ValueTypes = require('Base.SQL.ValueTypes')

local Tools = {}

function Tools.getExpressionType(expression)
    if expression == ngx.null then
        return ExpressionTypes.NULL_LITERAL
    end

    local expressionType = type(expression)

    if expressionType == "table" then
        return expression.type
    end

    if expressionType == "string" then
        return ExpressionTypes.STRING_LITERAL
    end

    if expressionType == "number" then
        return ExpressionTypes.NUMBER_LITERAL
    end

    if expressionType == "boolean" then
        return ExpressionTypes.BOOLEAN_LITERAL
    end

    error({ message = "Unrecognised SQL expression type", code = 55 })
end

function Tools.getExpressionReturnType(expression)
    if expression == ngx.null then
        return ValueTypes.NULL
    end

    local expressionType = type(expression)

    if expressionType == "table" then
        return expression.returns
    end

    if expressionType == "string" then
        return ValueTypes.STRING
    end

    if expressionType == "number" then
        if math.floor(expression) == expression then
            return expression < 0 and ValueTypes.SIGNED_INTEGER or ValueTypes.UNSIGNED_INTEGER
        end
        return ValueTypes.DOUBLE
    end

    if expressionType == "boolean" then
        return ValueTypes.BOOLEAN
    end

    error({ message = "Unrecognised SQL expression type", code = 56 })
end

function Tools.getExpressionSQL(...)
    local sqlExpressions = {}

    for _, expression in Utils.iterateArgs(...) do
        local sql

        if expression == ngx.null then
            sql = "NULL"
        else
            local expressionType = type(expression)

            if expressionType == "table" then
                sql = expression.sql

            elseif expressionType == "string" then
                sql = ngx.quote_sql_str(expression)

            elseif expressionType == "number" then
                sql = tostring(expression)

            elseif expressionType == "boolean" then
                sql = expression and "TRUE" or "FALSE"

            else
                error({ message = "Unrecognised SQL expression type", code = 57 })
            end
        end

        table.insert(sqlExpressions, sql)
    end

    return unpack(sqlExpressions)
end

function Tools.getDataType(expression)
    local expressionType = Tools.getExpressionType(expression)

    if expressionType == ExpressionTypes.DATABASE or expressionType == ExpressionTypes.TABLE then
        error({ message = "Attempted to get data type of database or table", code = 153 })
    end

    if expressionType == ExpressionTypes.COLUMN then
        return expression.columnValuesType
    end

    return (Tools.getExpressionReturnType(expression))
end

-- WARNING: This function returns nil while getDataType throws an exception
function Tools.getNumericDataType(expression)
    local expressionType = Tools.getExpressionType(expression) == ExpressionTypes.COLUMN and expression.columnValuesType or Tools.getExpressionReturnType(expression)

    -- Expressions that don't have a return value (e.g. tables and databases) or return NULL are not numeric
    if not expressionType or expressionType == ValueTypes.NULL or not ValueTypes.SUPERTYPES.NUMBER:has(expressionType) then
        return nil
    end

    return expressionType
end

-- Used to check if one value can be compared to the other
function Tools.areComparable(left, right)
    local leftType = Tools.getExpressionType(left) == ExpressionTypes.COLUMN and left.columnValuesType or Tools.getExpressionReturnType(left)
    local rightType = Tools.getExpressionType(right) == ExpressionTypes.COLUMN and right.columnValuesType or Tools.getExpressionReturnType(right)

    -- Expressions that don't have a return value (e.g. tables and databases) or return NULL cannot be compared
    if not leftType or not rightType or leftType == ValueTypes.NULL or rightType == ValueTypes.NULL then
        return false
    end

    if ValueTypes.SUPERTYPES.NUMBER:has(leftType) then
        return (ValueTypes.SUPERTYPES.NUMBER:has(rightType))
    end

    if ValueTypes.SUPERTYPES.BINARY:has(leftType) then
        return (ValueTypes.SUPERTYPES.BINARY:has(rightType))
    end

    return leftType == rightType
end

-- Used to check if one value can be used to substitute the other (e.g. when updating columns or inserting rows)
function Tools.areCompatible(left, right)
    local leftIsCol = Tools.getExpressionType(left) == ExpressionTypes.COLUMN
    local rightIsCol = Tools.getExpressionType(right) == ExpressionTypes.COLUMN

    local leftType = leftIsCol and left.columnValuesType or Tools.getExpressionReturnType(left)
    local rightType = rightIsCol and right.columnValuesType or Tools.getExpressionReturnType(right)

    -- Expressions that don't have a return value (e.g. tables and databases)
    if not leftType or not rightType then
        return false
    end

    if (leftIsCol and left.nullable or leftType == ValueTypes.NULL) and (rightIsCol and right.nullable or rightType == ValueTypes.NULL) then
        return true
    end

    if ValueTypes.SUPERTYPES.NUMBER:has(leftType) then
        return (ValueTypes.SUPERTYPES.NUMBER:has(rightType))
    end

    if ValueTypes.SUPERTYPES.BINARY:has(leftType) then
        return (ValueTypes.SUPERTYPES.BINARY:has(rightType))
    end

    return leftType == rightType
end

-- Used to get the resulting number type when one value operates on the other
function Tools.normalNumberType(left, right)
    if not (ValueTypes.SUPERTYPES.NUMBER:has(left) and ValueTypes.SUPERTYPES.NUMBER:has(right)) then
        error({ message = "Attempted to normalise at least one non-numeric type to a numeric type", code = 240 })
    end

    if left == ValueTypes.DOUBLE or right == ValueTypes.DOUBLE then
        return ValueTypes.DOUBLE
    end

    if left == ValueTypes.FLOAT or right == ValueTypes.FLOAT then
        return ValueTypes.FLOAT
    end

    if left == ValueTypes.DECIMAL or right == ValueTypes.DECIMAL then
        return ValueTypes.DECIMAL
    end

    if left == ValueTypes.SIGNED_INTEGER or right == ValueTypes.SIGNED_INTEGER then
        return ValueTypes.SIGNED_INTEGER
    end

    return ValueTypes.UNSIGNED_INTEGER
end

return Tools
