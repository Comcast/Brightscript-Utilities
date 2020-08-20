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
function newByteArrayReader() as object
    byteArrayReader = {}
    byteArrayReader.byteArray = invalid
    byteArrayReader.index = 0
    byteArrayReader.error = false
    byteArrayReader.reason = ""

    'check if there is an error
    byteArrayReader.isInError = function () as boolean 
        return m.error
    end function

    'clear the error state on the object
    byteArrayReader.clearError = function () as void
        m.error = false
        m.reason = ""
    end function

    byteArrayReader.getReason = function ()
        return m.reason
    end function

    'Retrieve the current index location
    byteArrayReader.getIndexLocation = function() as integer
        return m.index
    end function

    'Moves the index to the specified location in the array. 
    'Does not set array if array is larger than the length of the internal
    'Byte array
    byteArrayReader.setIndexLocation = function(index as integer) as void 
        if m.byteArray.count() <= index
            m.index = index
        else 
            m.error = true
            m.reason =  "setIndexLocation failed; Index out of bounds"
        end if
    end function

    byteArrayReader.initializeAsNewByteArray = function() as void
        m.byteArray = createObject("roByteArray")
    end function


    byteArrayReader.initializeFromByteArray = function(ba) as void
        'if the object type isn't byteArray, then don't assign
        if type(ba) <> "roByteArray"
            m.error = true
            m.reason = "setting byte array object failed; object is not byte array"
        else
            m.byteArray = ba 
        end if

    end function

    ' retrieves 4 bytes from the byte array and moves the index up 4.
    byteArrayReader.getInt32FromByteArray = function () as integer

        if m.index + 4 > m.byteArray.count()
            m.error = true
            m.reason =  "4 bytes would put index out of bounds"
            return 0
        end if

        value = 0
        value = value + m.byteArray[m.index]
        for i = 1 to 3
            value = value << 8
            value = value + m.byteArray[m.index + i] 
        end for
        m.index = m.index + 4
        return value
    end function

    ' retrieves 4 bytes from the byte array and moves the index up 4. 
    ' upcasts the return to a 64 bit 
    byteArrayReader.getInt32FromByteArrayAsInt64 =  function () as LongInteger

        if m.index + 4 > m.byteArray.count()
            m.error = true
            m.reason =  "getInt32FromByteArrayAsInt64 failed;4 bytes would put index out of bounds"
            return 0
        end if

        value = 0&
        value = value + m.byteArray[m.index]
        for i = 1 to 3
            value = value << 8
            value = value + m.byteArray[m.index + i] 
        end for
        m.index = m.index + 4
        return value
    end function

    'Retrive 8 bytes from the byte array and move the index up 8
    byteArrayReader.getInt64FromByteArray = function () as LongInteger

        if m.index + 8 > m.byteArray.count()
            m.error = true
            m.reason =  "getInt64FromByteArray failed; 8 bytes would put index out of bounds"
            return 0
        end if

        value = 0&
        value = value + m.byteArray[m.index]
        for i = 1 to 7
            value = value << 8
            value = value + m.byteArray[m.index + i]
        end for
        m.index = m.index + 8
        return value
    end function

    'retrieve one byte from array as a signed integer, range (-128, 127)
    byteArrayReader.getInt8FromByteArray = function () as integer
        if m.index + 1 > m.byteArray.count()
            m.error = true
            m.reason = "getInt8FromByteArray failed; 1 byte would put index out of bounds"
            return 0
        end if

        value = m.byteArray.GetSignedByte(m.index)
        m.index = m.index + 1
        return value
    end function

    'Retrieve one byte from array as an unsigned integer, range (0, 255)
    byteArrayReader.getUint8FromByteArray = function () as integer
        if m.index + 1 > m.byteArray.count()
            m.error = true
            m.reason = "getUint8FromByteArray failed; 1 byte would put index out of bounds"
            return 0
        end if

        value = m.byteArray[m.index]
        m.index = m.index + 1

        return value
    end function

    byteArrayReader.getUint16FromByteArray = function () as integer
        if m.index + 2 > m.byteArray.count()
            m.error = true
            m.reason = "getUInt16FromByteArray failed; 2 byte would put index out of bounds"
        end if

        value = m.byteArray[m.index]
        value = value << 8
        value = value + m.byteArray[m.index + 1]
        m.index = m.index + 2

        return value
    end function

    byteArrayReader.getInt16FromByteArray = function () as integer
        if m.index + 2 > m.byteArray.count()
            m.error = true
            m.reason = "getUInt16FromByteArray failed; 2 byte would put index out of bounds"
        end if

        value = m.byteArray[m.index]
        value = value << 8
        value = value + m.byteArray[m.index + 1]
        m.index = m.index + 2

        int16Max = 32767

        if value > int16Max
            diff = int16Max - value
            value = (diff or int16Max) and not (diff and int16Max)
        end if

        return value
    end function

    'Move index up by some 32 bit integer number of bytes
    'If out of bounds, do not set index, print error
    byteArrayReader.skipBytes = function (numberOfBytesToSkip as integer) as void
        if m.index + numberOfBytesToSkip < m.byteArray.count()
            m.index = m.index + numberOfBytesToSkip
        else 
            m.error = true
            m.reason =  "skip moves index out of range"
        end if
    end function

    'Move index back by some 32 bit integer number of bytes
    'If out of bounds do not set index
    byteArrayReader.rewindBytes = function (numberOfBytesToRewind as integer) as void
        if m.index - numberOfBytesToRewind > 0
            m.index = m.index - numberOfBytesToRewind
        else 
            m.error = true
            m.reason = "rewindBytes failed; rewind moves index out of range"
        end if
    end function

    'Grab a subarray of size `numberOfBytes from the current byte array
    'If out of bounds, do nothing.
    byteArrayReader.getBytes = function (numberOfBytes)
        newByteArray = CreateObject("roByteArray")
        if m.index + numberOfBytes <= m.byteArray.count()
            i = numberOfBytes
            while i > 0
                newByteArray.push(m.byteArray[m.index + numberOfBytes - i])
                i = i - 1
            end while
            m.index = m.index + numberOfBytes
        else 
            m.error = true 
            m.reason =  "getBytes failed; subbyte array is larger than end of array"
        end if
        return newByteArray
    end function

    return byteArrayReader
end function
