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
function prioQueueTests() 
    printHeader("Prio Queue Test")
    myPrioQueue = initPriorityQueue(5)
    beforePrioQueue(myPrioQueue)
    checkSuccess("testPush",testPush(myPrioQueue))
    beforePrioQueue(myPrioQueue)
    checkSuccess("testHeapify", testHeapify(myPrioQueue))
    beforePrioQueue(myPrioQueue)
    checkSuccess("testPop", testPop(myPrioQueue))
    beforePrioQueue(myPrioQueue)
    checkSuccess("testRemove", testRemove(myPrioQueue))
end function

function beforePrioQueue(prioQueue as object) as void
    'Max Heap
    prioQueue.comparator = function(A as integer, B as integer) as boolean
        return A > B
    end function
    prioQueue.clear()
end function

function testPush(prioQueue) as boolean
    '1,8,12,43,10,25,22
    prioQueue.push(1)
    prioQueue.push(3)
    prioQueue.push(5)
    prioQueue.push(4)
    prioQueue.push(6)
    prioQueue.push(13)
    prioQueue.push(10)
    prioQueue.push(9)
    prioQueue.push(8)
    prioQueue.push(15)
    prioQueue.push(17)
    result = true
    for each index in prioQueue.data
        result = result and (prioQueue.data[0] >= index )
    end for
    if result = false then print "Test Push Failed!"
    return result
end function

function testHeapify(prioQueue) as boolean

    array = [1, 3, 5, 4, 6, 13, 10, 9, 8, 15, 17]
    prioQueue.setData(array)
    result = true
    for each index in prioQueue.data
        result = result and (prioQueue.data[0] >= index )
        if result = false then print "value: "; index; " greater than "; prioQueue.data[0]
    end for
    if result = false then print "Test Heapify Failed! Value was: "; 
    return result 

end function

function testPop(prioQueue) as boolean

    array = [1, 3, 5, 4, 6, 13, 10, 9, 8, 15, 17]
    prioQueue.setData(array)
    maxValue = prioQueue.pop()
    nextValue = prioQueue.peek()

    if maxValue <> 17 then print "Test Pop Failed!, max value was: "; maxValue
    if nextValue <> 15 then print "Test Pop Failed! next heap head was not largest value. Value was: "; nextValue
    return maxValue = 17 and nextValue = 15
    
end function

function testRemove(prioQueue) as boolean

    array = [1, 3, 5, 4, 6, 13, 10, 9, 8, 15, 17]
    prioQueue.setData(array)
    prioQueue.remove(2)
    result = true
    queueSize = prioQueue.size()
    for i = 0 to queueSize

        leftChildIndex = prioQueue.getLeft(i)
        if leftChildIndex < queueSize
            result = result and prioQueue.data[i] > prioQueue.data[leftChildIndex]
        end if 

        rightChildIndex = prioQueue.getRight(i)
        if rightChildIndex < queueSize
            result = result and prioQueue.data[i] > prioQueue.data[rightChildIndex]
        end if 

    end for
    return result
end function    
