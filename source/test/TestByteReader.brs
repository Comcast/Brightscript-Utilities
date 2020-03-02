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
