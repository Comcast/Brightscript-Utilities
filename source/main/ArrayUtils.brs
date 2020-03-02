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

function initArrayUtil() as object
    arrayUtil = {}

    'copy objects 
    arrayUtil.copyArray = function(array as object) as object

        size = array.count()
        newArray = createObject("roArray", size, false)

        for i = 0 to size - 1
            newArray[i] = array[i]
        end for 

        return newArray
    end function

    'Input:
    '   array to be sorted
    '   comparator function with signature f(a,b) as boolean
    '    with a and b of the same type as the array items
    arrayUtil.inPlaceInsertionSort = function(array as object, comparatorFunc as function) as void
        for i = 0 to array.count() - 1
            key = array[i]
            j = i - 1

            while j >= 0 and comparatorFunc(array[j], key)
                array[j + 1] = array[j]
                j--
            end while

            array[j + 1] = key
        end for
    end function

    'Input:
    '   comparator func must 
    'Output:
    '   integer index of the desired value or -1 
    arrayUtil.binarySearch = function(array as object, value as dynamic, lessThanFunc as function, equalToFunc as function) as integer
        lowerBound = 0
        upperBound = array.count()
        while lowerBound <= upperBound
            middle = lowerBound + (upperBound - 1) / 2

            if equalToFunc(array[middle], value) then return middle

            if lessThanFunc(array[middle], value)
                lowerBound = middle + 1
            else 
                upperBound = middle - 1
            end if

        end while

        return  -1

    end function


 '   arrayUtil.fisherYatesShuffle = function(array as object, randomFunc as function)
 '       size = array.count() 
 '       newArray = createObject("roArray", size, false)
 '       for i = size - 1 to 1 
'
 '           j = randomFunc(0,)
'            m.swap(array, i, j)
'        end for
'    end function

    arrayUtil.swap = function(array as object, a as integer, b as integer)
    

        tmp = array[a]
        array[a] = array[b]
        array[b] = tmp

    end function

    'Input:
    '   a - a string of the form "1234"
    '   b - a string of the form "1234"
    '
    'Output: 
    '   default  a < b
    arrayUtil.compareStringByValueLessThan = function(a as string, b as string) as boolean
        return val(a.trim()) < val(b.trim())
    end function

    'Input:
    '   a - a string of the form "1234"
    '   b - a string of the form "1234"
    '
    'Output: 
    '   default  a > b
    arrayUtil.compareStringByValueGreaterThan = function(a as string, b as string) as boolean
        return val(a.trim()) > val(b.trim())
    end function

    return arrayUtil

end function
