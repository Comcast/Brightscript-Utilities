
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
function initializeUrlUtils() as object
    UrlUtils = {}
    UrlUtils.invalidString = "null"
    UrlUtils.skipFunctions = true

    'Input:
    '   Associative Array of Objects to be concatenated
    '    e.g. {
    '           a: v1,
    '           b: v2,
    '           c: v3
    '          }
    'Output:
    '   formatted query string e.g.
    '    "a=v1&b=v2&c=v3"
    '
    ' Will only add keys that implement the ifToStr interface
    UrlUtils.concatAaQueryParamList = function(AA)
        if type(AA) <> "roAssociativeArray" then return ""

        outString = ""
        keys = AA.keys()
        length = keys.count() - 1

        for i = 0 to length - 1

            key = keys[i]
            value = AA[key]
            if value = invalid 
                outString = outString + key.toStr() + "=" + m.invalidString + "&"
            else if getInterface(value, "ifFunction") <> invalid and m.skipFunctions

            else if getInterface(key, "ifToStr") <> invalid and getInterface(value, "ifToStr") <> invalid
                outString = outString + key.toStr() + "=" + value.toStr() + "&"
            end if

        end for

        key = keys[length]
        value = AA[key]

        if value = invalid 
            outString = outString + key.toStr() + "=" + m.invalidString
        else if getInterface(key, "ifToStr") <> invalid and getInterface(value, "ifToStr") <> invalid
            outString = outString + key.toStr() + "=" + value.toStr()
        end if

        return outString
    end function
    return UrlUtils
end function
