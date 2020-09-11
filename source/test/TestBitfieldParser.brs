function bitfieldParserTests()
    printHeader("Test Bitfield Parser")
    checkSuccess("Test bitfield parser creation", testCreatebitfieldParser() )
    checkSuccess("Test Bitfield parser Initialization", testBitfieldParserInitialization())
    checkSuccess("Test Bitfield Parser GetBit", testGetBit())
    checkSuccess("Test get bits stored in 32 bit int with perfect byte boundaries", testGetBits32_perfect_bytes())
    checkSuccess("Test get bits stored in 32 bit int intra byte from the front perfect boundary back", testGetBits32_intraByte_front())
    checkSuccess("Test get bits stored in 32 bit int perfect boundary front intra byte back", testGetBits32_intraByte_back())
    checkSuccess("test get bits stored in 32 bit int intra boundary for both", testGetBits32_intraByte_both())
    checkSuccess("test get bits strored in 32 bit in with intra bytes no middle",getBits32_intraByte_no_middle())
    checkSuccess("Test get bits stored in 64 bit int with perfect byte boundaries", testGetBits64_perfect_bytes())
    checkSuccess("Test get bits stored in 64 bit int intra byte from the front perfect boundary back", testGetBits64_intraByte_front())
    checkSuccess("Test get bits stored in 64 bit int perfect boundary front intra byte back", testGetBits64_intraByte_back())
    checkSuccess("test get bits stored in 64 bit int intra boundary for both", testGetBits64_intraByte_both())
    checkSuccess("test get bits strored in 64 bit in with intra bytes no middle",getBits64_intraByte_no_middle())
    checkSuccess("Test get bits stored in a 64 bit int - larger than 32 bits", getBits64_large())
    checkSuccess("Test bitfield seek positive", testSeek_positive())
end function

function initializeBitfieldTestVector()
    scte35Message = "/DBQAAFyPWVA///wBQb+czRpoAA6AhRDVUVJXhYcln+/AQVDMDMyMDUAAAIiQ1VFSV4WHqZ/3wAB7acqAQ5FUDAyNzkwNzMyMDU5MyADZF+5Ei4="
    ba = createObject("roByteArray")
    ba.fromBase64String(scte35Message)
    return ba
end function

function testCreatebitfieldParser()
   bitfieldParser = newBitfieldParser()
   return bitfieldParser.index = 0 and bitfieldParser.byteIndex = 0 and bitfieldParser.bits = 0 and bitfieldParser.data = invalid
end function

function testBitfieldParserInitialization()
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    return bitfieldParser.index = 0 and bitfieldParser.byteIndex = 0 and bitfieldParser.bits = 664 and bitfieldParser.data <> invalid
end function

'parses the entire string one bit at a time
function testGetBit()
    expected = [1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,1,0,0,0,1,1,1,1,0,1,0,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,0,0,1,1,0,0,1,1,0,1,0,0,0,1,1,0,1,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,1,1,1,0,0,0,0,1,0,1,1,0,0,0,0,1,1,1,0,0,1,0,0,1,0,1,1,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,1,1,1,0,0,0,0,1,0,1,1,0,0,0,0,1,1,1,1,0,1,0,1,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1,0,1,1,0,1,0,0,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,0,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,1,0,0,1,1,1,0,0,1,0,0,1,1,0,0,0,0,0,0,1,1,0,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,1,0,1,0,0,1,1,1,0,0,1,0,0,1,1,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,1,0,0,0,1,0,1,1,1,1,1,1,0,1,1,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1,1,1]
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    resultArray = []
    while bitfieldParser.hasBits()
        value = bitfieldParser.getBit()
        if value = invalid then stop
        resultArray.push(value)
    end while
    result = true
    for i = 0 to resultArray.count() - 1
        if resultArray[i] <> expected[i]
            print "Failed at - Index:"; i; " values - expected: "; expected[i]; " actual: "; resultArray[i]
        end if
        result = result and resultArray[i] = expected[i]
    end for
    return result
end function

function testGetBits32_perfect_bytes()
    expected = 16527440
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    result = bitfieldParser.getBits32(24)
    return expected = result
end function

function testGetBits32_intraByte_front()
    expected = 1847376
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    'Three bits in 
    bitfieldParser.getBit()
    bitfieldParser.getBit()
    bitfieldParser.getBit()
    'End on same boundary as above
    result = bitfieldParser.getBits32(21)

    return expected = result 
end function

function testGetBits32_intraByte_back()

    expected = 2065930
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    result = bitfieldParser.getBits32(21)
    return expected = result 

end function

function testGetBits32_intraByte_both()
    expected = 197888
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)

    for i = 0 to 8
        bitfieldParser.getBit()
    end for

    result = bitfieldParser.getBits32(19)

    return expected = result 
end function

function getBits32_intraByte_no_middle()
    expected = 773
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    for i = 0 to 8
        bitfieldParser.getBit()
    end for
    result = bitfieldParser.getBits32(11)
    return expected = result 
end function

'64 bit integer container
function testGetBits64_perfect_bytes()
    expected = 16527440&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    result = bitfieldParser.getBits64(24)
    return expected = result
end function

function testGetBits64_intraByte_front()
    expected = 1847376&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    'Three bits in 
    bitfieldParser.getBit()
    bitfieldParser.getBit()
    bitfieldParser.getBit()
    'End on same boundary as above
    result = bitfieldParser.getBits64(21)

    return expected = result 
end function

function testGetBits64_intraByte_back()

    expected = 2065930&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    result = bitfieldParser.getBits64(21)
    return expected = result 

end function

function testGetBits64_intraByte_both()
    expected = 197888&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)

    for i = 0 to 8
        bitfieldParser.getBit()
    end for

    result = bitfieldParser.getBits64(19)

    return expected = result 
end function

function getBits64_intraByte_no_middle()
    expected = 773&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    for i = 0 to 8
        bitfieldParser.getBit()
    end for
    result = bitfieldParser.getBits64(11)
    return expected = result 
end function

function getBits64_large()
    '011000001010000000000000000000101110010001111010110010
    expected = 6799379918298802&
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    for i = 0 to 8
        bitfieldParser.getBit()
    end for
    result = bitfieldParser.getBits64(54)
    return result = expected
end function

'Seek
function testSeek_positive()
    testVector = initializeBitfieldTestVector()
    bitfieldParser = newBitfieldParser()
    bitfieldParser.initialize(testVector)
    for i = 0 to 5 
        bitfieldParser.getBit()
    end for
    'bit 6 byte 0
    bitfieldParser.seek(23) 'bit 29 byte 3
    bitfieldParser.seek(2)  'bit 31 byte 3
    bitfieldParser.seek(2)  'bit 33 byte 4
    bitfieldParser.seek(2)  'bit 35 byte 4
    bitfieldParser.seek(2)  'bit 37 byte 4
    bitfieldParser.seek(4)  'bit 41 byte 5
    return bitfieldParser.getIndex() = 41 and bitfieldParser.getByteIndex() = 5
end function
