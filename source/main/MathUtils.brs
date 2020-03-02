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
function initMathsUtil() 
    mathsUtil = {}

'== CONSTANTS =='
    mathsUtil["_32_BIT_INT_MAX"] = 2147483647%
    mathsUtil["_32_BIT_INT_MIN"] = -2147483648% 
    mathsUtil["_64_BIT_INT_MAX"] = 9223372036854775807&
    mathsUtil["_64_BIT_INT_MAX"] = -9223372036854775808&
    mathsUtil["_PI_SINGLE"] = 3.1415927410125732421875!
    mathsUtil["_PI_DOUBLE"] = 3.141592653589793115997963468544185161590576171875#
    mathsUtil["_E_SINGLE"] = 2.71828174591064453125!
    mathsUtil["_E_DOUBLE"] = 2.718281828459045090795598298427648842334747314453125#

    'ceiling function
    '    Input must be float or double returns invalid otherwise
    mathsUtil.ceiling = function (unit) as integer
        if (getInterface(unit, "ifFloat") = invalid) or (type(unit) <> "Double") return invalid 
        i = int(unit)
        if i < unit then i++
        return i
    end function

    mathsUtil.floor = function (unit) as integer
        if (getInterface(unit, "ifFloat") = invalid) or (type(unit) <> "Double") return invalid 
        return int(unit)
    end function

    mathsUtil.min = function (A, B)
        if A <= B then return A
        return B
    end function

    mathsUtil.max = function (A, B)
        if A >= B then return A
        return B
    end function 

    mathsUtil.random = function(upperBound as integer, lowerBound=0 as integer) as integer
        'shift random window over from (0, 1) -> (0, upperBound - lowerBound + 1)
        randomValue = rnd(upperBound - lowerBound + 1) 
        'reshift random window to [lowerBound, lowerBound]
        randomValue = randomValue + lowerBound - 1
        return randomValue

    end function

    mathsUtil.log = function(value as float, base as float) as float
        return log(value)/log(base)
    end function

    return mathsUtil

end function
