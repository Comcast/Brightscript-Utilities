'****************************************************************************
'* Licensed under the Apache License, Version 2.0 (the "License");          *
'* you may not use this file except in compliance with the License.         *
'* You may obtain a copy of the License at                                  *
'* http://www.apache.org/licenses/LICENSE-2.0                               *
'* Unless required by applicable law or agreed to in writing, software      *
'* distributed under the License is distributed on an "AS IS" BASIS,        *
'* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
'* See the License for the specific language governing permissions and      *
'* limitations under the License.                                           *
'****************************************************************************
function byteArrayTests()
    printHeader("Byte Array Tests")
    checkSuccess("testInitializationWithValidByteArray", testInitializationWithValidByteArray())
    checkSuccess("testInitializationWithInvalidByteArray", testInitializationWithInvalidByteArray())
    checkSuccess("testInitializationWithNewByteArray", testInitializationWithNewByteArray())
    checkSuccess("testRead32BitInteger", testRead32BitInteger())
    checkSuccess("testRead32BitIntegerOutOfBounds", testRead32BitIntegerOutOfBounds())
    checkSuccess("testgetInt32FromByteArrayAsInt64", testgetInt32FromByteArrayAsInt64())
    checkSuccess("testgetInt32FromByteArrayAsInt64OutOfBounds", testgetInt32FromByteArrayAsInt64OutOfBounds())
    checkSuccess("testGetInt64FromByteArray", testGetInt64FromByteArray())
    checkSuccess("testGetInt16FromByteArrayNegative", testGetInt16FromByteArrayNegative())
    checkSuccess("testGetInt16FromByteArrayPositive", testGetInt16FromByteArrayPositive())
    checkSuccess("testGetInt16FromByteArrayInt16Max", testGetInt16FromByteArrayInt16Max())
    checkSuccess("testGetInt16FromByteArrayInt16Min", testGetInt16FromByteArrayInt16Min())
    checkSuccess("testGetUint16FromByteArray", testGetUint16FromByteArray())
    checkSuccess("testGetUint8FromByteArray", testGetUint8FromByteArray())
    checkSuccess("testGetInt8FromByteArray", testGetInt8FromByteArray())
end function

function testInitializationWithValidByteArray() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(1)
    byteArray.push(2)
    byteArray.push(3)
    byteArrayReader.initializeFromByteArray(byteArray)
    return type(byteArrayReader.byteArray) = "roByteArray"
end function

function testInitializationWithInvalidByteArray() as boolean

    byteArrayReader = newByteArrayReader()
    byteArray = invalid
    byteArrayReader.initializeFromByteArray(invalid)
    return byteArrayReader.byteArray = invalid and byteArrayReader.isInError() = true

end function

function testInitializationWithNewByteArray() as boolean
    byteArrayReader = newByteArrayReader()
    byteArrayReader.initializeAsNewByteArray()
    return type(byteArrayReader.byteArray) = "roByteArray" and byteArrayReader.isInError() = false
end function

function testRead32BitInteger() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(1) '0000 0001
    byteArray.push(4) '0000 0100
    byteArray.push(16)'0001 0000
    byteArray.push(64)'0100 0000
    '0000 0001 0000 0100 0001 0000 0100 0000
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt32FromByteArray()
    return result = 17043520 and byteArrayReader.index = 4 and byteArrayReader.isInError() = false
end function

function testRead32BitIntegerOutOfBounds() as boolean

    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(0)
    byteArray.push(0)
    byteArray.push(0)
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt32FromByteArray()
    return result = 0 and byteArrayReader.index = 0 and byteArrayReader.isInError() = true

end function

function testgetInt32FromByteArrayAsInt64() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(1)
    byteArray.push(4)
    byteArray.push(16)
    byteArray.push(64)
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt32FromByteArrayAsInt64()
    return result = 17043520& and byteArrayReader.index = 4 and type(result) = "LongInteger" and byteArrayReader.isInError() = false
end function

function testgetInt32FromByteArrayAsInt64OutOfBounds() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(0)
    byteArray.push(0)
    byteArray.push(0)
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt32FromByteArray()
    return result = 0 and byteArrayReader.index = 0 and byteArrayReader.isInError() = true

    
end function

function testGetInt64FromByteArray() as boolean

    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(1)   '0000 0001
    byteArray.push(2)   '0000 0010
    byteArray.push(4)   '0000 0100
    byteArray.push(8)   '0000 1000

    byteArray.push(13)  '0000 1101
    byteArray.push(53)  '0011 0101
    byteArray.push(255) '1111 1111
    byteArray.push(15)  '0000 1111
    '0000 0001 0000 0010 0000 0100 0000 1000 0000 1101 0011 0101 1111 1111 0000 1111
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt64FromByteArray()
    return result = 72624976619241231& and byteArrayReader.index = 8 and byteArrayReader.isInError() = false

end function

function testGetInt16FromByteArrayNegative() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(-82) '1101 0001
    byteArray.push(19) '1110 1100

    '1111 1111 1111 1111 1010 1110 0001 0011
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt16FromByteArray()
    return result = -20973 and byteArrayReader.index = 2 and byteArrayReader.isInError() = false
end function

function testGetInt16FromByteArrayPositive() as boolean
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(63)    '0011 1111
    byteArray.push(-31)   '1110 0001

    '0000 0000 0000 0000 0011 1111 1110 0001
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt16FromByteArray()
    return result = 16353 and byteArrayReader.index = 2 and byteArrayReader.isInError() = false
end function 

function testGetInt16FromByteArrayInt16Max() as boolean
    INT16_MAX = 32767
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(127) '0111 1111
    byteArray.push(-1)  '1111 1111
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt16FromByteArray()
    return result = INT16_MAX and byteArrayReader.index = 2 and byteArrayReader.isInError() = false
end function

function testGetInt16FromByteArrayInt16Min() as boolean
    INT16_MIN = -32768
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(-128) '1000 0000
    byteArray.push(0)  '0000 0000
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt16FromByteArray()
    return result = INT16_MIN and byteArrayReader.index = 2 and byteArrayReader.isInError() = false
end function

function testGetUint16FromByteArray() as boolean
    expected = 44563
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(-82)  '10101110
    byteArray.push(19)   '00010011
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getUint16FromByteArray()
    return result = expected and byteArrayReader.index = 2 and byteArrayReader.isInError() = false
end function 

function testGetUint8FromByteArray() as boolean
    expected = 200
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(-56)    '11001000
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getUint8FromByteArray()
    return result = expected and byteArrayReader.index = 1 and byteArrayReader.isInError() = false
end function

function testGetInt8FromByteArray() as boolean
    expected = -56
    byteArrayReader = newByteArrayReader()
    byteArray = createobject("roByteArray")
    byteArray.push(-56)    '11001000
    byteArrayReader.initializeFromByteArray(byteArray)
    result = byteArrayReader.getInt8FromByteArray()
    return result = expected and byteArrayReader.index = 1 and byteArrayReader.isInError() = false
end function
