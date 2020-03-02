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
function stringsTest() 
    printHeader("Strings Test")
    stringsUtil = initializeStringsUtil()
    checkSuccess("testBooleanToStringTrue", testBooleanToStringTrue(stringsUtil))
    checkSuccess("testBooleanToStringFalse", testBooleanToStringFalse(stringsUtil))
end function

function testBooleanToStringTrue(stringsUtil as object) as boolean
    result = stringsUtil.booleanToString(true)
    return result = "True"
end function

function testBooleanToStringFalse(stringsUtil as object) as boolean
    result = stringsUtil.booleanToString(false)
    return result = "False"
end function
