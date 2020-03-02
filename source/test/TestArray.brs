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
function arrayTests()
    
    printHeader("Array Tests")
    arrayUtil = initArrayUtil()
    checkSuccess("testInPlaceInsertionSort", testInPlaceInsertionSort(arrayUtil))
    checkSuccess("testArrayCopy", testArrayCopy(arrayUtil))
    checkSuccess("testBinarySearch", testBinarySearch(arrayUtil))

end function

function initializeTest() as object
    testObject = {}
    testObject.array = [10, 5, 15, 25, 20]
    testObject.arrayLong = []
    for i = 0 to 100
        testObject.arrayLong.push(i*5)
    end for

    testObject.basicGreaterThan = function (a as integer, b as integer) as boolean
        return a > b
    end function

    testObject.basicLessThan = function (a as integer, b as integer) as boolean
        return a < b
    end function

    testObject.basicEqualTo = function (a as integer, b as integer) as boolean
        return a = b
    end function

    return testObject
end function

function testArrayCopy(arrayUtil as object ) as boolean
    testObject = initializeTest()
    arrayCopy = arrayUtil.copyArray(testObject.array)
    result = arrayCopy[0] = testObject.array[0] and arrayCopy[1] = testObject.array[1] and arrayCopy[2] = testObject.array[2] and arrayCopy[3] = testObject.array[3]
    return result
end function

function testInPlaceInsertionSort(arrayUtil as object) as boolean
    testObject = initializeTest() 
    arrayUtil.inPlaceInsertionSort(testObject.array, testObject.basicGreaterThan)

    result = testObject.array[0] = 5 and testObject.array[1] = 10 and testObject.array[2] = 15 and testObject.array[3] = 20 and testObject.array[4] = 25
    return result
end function

function testBinarySearch(arrayUtil as object) as boolean
    testObject = initializeTest()
    index = arrayUtil.binarySearch(testObject.arrayLong, 50, testObject.basicLessThan, testObject.basicEqualTo)
    return testObject.arrayLong[index] = 50
end function

function testFisherYatesShuffle() as boolean
        
    return false

end function
