local ExpressionTypes = {}

ExpressionTypes.LOGICAL_OPERATOR = 1
ExpressionTypes.COMPARISON_OPERATOR = 2
ExpressionTypes.NUMERIC_OPERATOR = 3
ExpressionTypes.BITWISE_OPERATOR = 4

ExpressionTypes.DATABASE = 32
ExpressionTypes.TABLE = 33
ExpressionTypes.COLUMN = 34

ExpressionTypes.FUNCTION = 64
ExpressionTypes.NUMBER_LITERAL = 65
ExpressionTypes.STRING_LITERAL = 66
ExpressionTypes.BINARY_LITERAL = 67 -- 0x00, x'00', 0b00, b'00'
ExpressionTypes.BOOLEAN_LITERAL = 68
ExpressionTypes.NULL_LITERAL = 69

return ExpressionTypes
