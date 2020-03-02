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
function initPriorityQueue(size=10 as integer) as object
    prioQueue = {}

    prioQueue["Data"] = createObject("roArray", size, true)

    'Default comparator function object just returns true regadless of A and B
    '   Comparator function must take two indicies A and B and return boolean
    prioQueue["Comparator"] = function(A as dynamic, B as dynamic) as boolean
        return true
    end function

    '===================
    '="Private" methods=
    '===================
    prioQueue.getParent = function(node as integer) as integer
        return (node - 1)/2
    end function

    prioQueue.getLeft = function(node as integer) as integer
        return (2 * node) + 1
    end function

    prioQueue.getRight = function(node as integer) as integer
        return (2 * node) + 2
    end function

    prioQueue.hasChildren = function(node as integer) as boolean
        size = m.size()
        if node > size then return false
        if node.getLeft() > size and node.getRight() > size then return false
        return true
    end function


    'swap location A and location B in internal array
    prioQueue.swap = function(A as integer, B as integer) as void

        tmp = m["Data"][A]
        m["Data"][A] = m["Data"][B]
        m["Data"][B] = tmp

    end function

    'Top to bottom heapify
    prioQueue.heapify = function(i=(m.data.count() - 1) as integer) as void
        begin = m.getParent(i)
        while begin > -1
            m.siftDown(begin, i)
            begin--
        end while
    end function

    prioQueue.siftDown = function (begin as integer, term as integer)
        root = begin
        while m.getLeft(root) <= term

            child = m.getLeft(root)
            save = root

            if m.comparator(m.data[child], m.data[save] )
                save = child
            end if

            if child + 1 <= term and m.comparator(m.data[child + 1], m.data[save])
                save = child + 1
            end if

            if save = root
                return invalid
            else
                m.swap(root, save)
                root = save
            end if

        end while
    end function

    '==================
    '="Public" methods=
    '==================
    prioQueue.setComparator = function(comparatorFunc as function) as void
        m["Comparator"] = comparatorFunc
    end function

    prioQueue.getComparator = function() as function
        return m["Comparator"]
    end function

    prioQueue.setData = function(data as object) as void
        if type(data) = "roArray"  'exit if trying to set data to type other than array
            m["Data"] = data
            m.heapify()
        end if

    end function

    prioQueue.size = function() as integer
        return m["Data"].count()
    end function

    prioQueue.push = function(A as object) as void
        i = m.size()
        parent = m.getParent(i)
        m["Data"].push(A)
        'Heapify from the bottom up
        while i > 0 and m.comparator(m.data[i], m.data[parent])
            m.swap(parent, i)
            i = parent
            parent = m.getParent(i)
        end while
    end function

    prioQueue.pop = function() as dynamic

        headValue = m["Data"].shift()
        m.heapify()
        return headValue

    end function

    prioQueue.peek = function() as dynamic
        return m["Data"][0]
    end function

    prioQueue.remove = function(node as integer) as void
        m.swap(node, 0)
        m.pop()
        m.heapify()
    end function

    prioQueue.clear = function() as void
       m["Data"] = createObject("roArray", 10, true)
    end function

    prioQueue.toStr = function() as string
        header = "prioQueue: { "
        trailer = " }"
        spacer = ", "
        stringVal = box("")
        stringVal.appendString(header, len(header))
        sizeString = "size: " 
        sizeVal = m.size()
        sizeValString = sizeVal.toStr()
        stringVal.appendString(sizeString, len(sizeString))
        stringVal.appendString(sizeValString, len(sizeValString))
        dataHead = ", data: [ "
        stringVal.appendString(dataHead, len(dataHead))
        dataTrailer = " ]"
        for i=0 to sizeVal - 2

            valueI = m.data[i].toStr()
            stringVal.appendString(valueI, len(valueI))
            stringVal.appendString(spacer, len(spacer))
        end for
        
        valueI = m.data[sizeVal -1].toStr()
        stringVal.appendString(valueI, len(valueI))
        stringVal.appendString(dataTrailer, len(dataTrailer))
        stringVal.appendString(trailer, len(trailer))
        return stringVal.toStr()

    end function

    return prioQueue

end function
