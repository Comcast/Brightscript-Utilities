' Assumes big endianess
' that is to say msb is stored in the smallest index
'|   0   |   1   |. . .|   n   |
function newBitfieldParser() as object
    this = {}

    ' Member variables
    this["index"] = 0
    this["byteIndex"] = 0
    this["bits"] = 0
    this["data"] = invalid

    this["error"] = false
    this["reason"] = ""

    ' Private Member functions

    ' Public Member functions
    this.isInError = function()
        return m.error
    end function

    this.getIndex = function()
        return m.index 
    end function

    this.getByteIndex = function()
        return m.byteIndex
    end function

    this.getBitCount = function()
        return m.bits
    end function

    this.initialize = function(ba) as void
        m.data = ba
        m.bits = ba.count() * 8
    end function

    this.hasBits = function()
        return m.index < m.bits - 1
    end function

    this.getBit = function()
        nextBit = m.index + 1
        if nextBit >= m.bits
            m.error = true
            m.reason = "getBit next bit is out of bounds"
            return invalid
        end if

        currentByte = m.data[m.byteIndex]
        intraByteIndex = m.index mod 8
        
        bitmask = 1

        value = (currentByte >> (7 - intraByteIndex)) and bitmask
        if m.index > 0 and intraByteIndex + 1 = 8 then m.byteIndex = m.byteIndex + 1
        m.index = nextBit

        return value  

    end function

    'retrieves the bit at the current index as a boolean flag
    this.getFlag = function()
        flag = m.getBit()
        if m.isInError()
            return invalid
        end if 
        return flag = 1
    end function

    this.getBits32 = function(size as integer)
        if size > 32
            m.error = true
            m.reason = "getBits32 size is larger than a 32 bit integer can hold: " + size.toStr()
        end if

        if size >= m.bits - m.index
            m.error = true
            m.reason = "getBits32 size is larger than number of bits left in bytearray: size: " + size + " bits left " + m.bits - m.index
        end if
        value = 0

        'get all bits to next byte boundary
        while (m.index mod 8) > 0 and size > 0
            value = value << 1
            value = value or m.getBit()
            size = size - 1
        end while

        'If there are more than 8 bits left, shift bytes onto value
        while size >= 8
            value = value << 8
            value = value or m.data[m.byteIndex]
            m.byteIndex = m.byteIndex + 1
            size = size - 8
        end while

        'get any bits left over that are mid last byte
        while size > 0
            value = value << 1
            value = value or m.getBit()
            size = size - 1
        end while

        return value
    end function

    this.getBits64 = function(size as integer) as longinteger
        if size > 64
            m.error = true
            m.reason = "getBits64 size is larger than a 64 bit integer can hold: " + size.toStr()
        end if

        if size >= m.bits - m.index
            m.error = true
            m.reason = "getBits64 size is larger than number of bits left in bytearray: size: " + size + " bits left " + m.bits - m.index
        end if

        value = 0&

        'get all bits to next byte boundary
        while (m.index mod 8) > 0 and size > 0
            value = value << 1
            value = value or m.getBit()
            size = size - 1
        end while

        'If there are more than 8 bits left, shift bytes onto value
        while size >= 8
            value = value << 8
            value = value or m.data[m.byteIndex]
            m.byteIndex = m.byteIndex + 1
            size = size - 8
        end while

        'get any bits left over that are mid last byte
        while size > 0
            value = value << 1
            value = value or m.getBit()
            size = size - 1
        end while

        return value
    end function


    this.seek = function(size)
        if size > 0

            indexCopy = m.index
            'calculate bit index
            m.index = m.index + size

            'calculate byte index
            bitsLeftInByte = indexCopy mod 8
            if (bitsLeftInByte > 0 and (7 - bitsLeftInByte) < size ) then m.byteIndex = m.byteIndex + 1
            if bitsLeftInByte < size
                size = size - bitsLeftInByte
                bytes = int(size / 8)
                m.byteIndex = m.byteIndex + bytes
            end if

        else if size < 0
            print "Not Implemented"
        end if

    end function

    return this
end function
