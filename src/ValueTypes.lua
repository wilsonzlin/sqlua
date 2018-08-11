local Set = require('Base.DataStructure.Set')

local ValueTypes = {}

ValueTypes.UNSIGNED_INTEGER = 1
ValueTypes.SIGNED_INTEGER = 2
ValueTypes.FLOAT = 3
ValueTypes.DOUBLE = 4
ValueTypes.DECIMAL = 5
ValueTypes.STRING = 6
ValueTypes.BINARY = 7
ValueTypes.BOOLEAN = 8
ValueTypes.NULL = 9

ValueTypes.SUPERTYPES = {}
ValueTypes.SUPERTYPES.NUMBER = Set:new({ ValueTypes.UNSIGNED_INTEGER, ValueTypes.SIGNED_INTEGER, ValueTypes.FLOAT, ValueTypes.DOUBLE, ValueTypes.DECIMAL })
ValueTypes.SUPERTYPES.BINARY = Set:new({ ValueTypes.STRING, ValueTypes.BINARY })

return ValueTypes
