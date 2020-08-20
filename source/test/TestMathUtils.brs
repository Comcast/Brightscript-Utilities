function mathUtilTests()
    printHeader("Math Utils")
    mathsUtil = initMathsUtil()
    checkSuccess("xorTest", xorTest(mathsUtil))
end function

function xorTest(mathsUtil)
    shouldBe2 = mathsUtil.xor(3, 1)
    shouldBe0 = mathsUtil.xor(255, 255)
    return shouldBe2 = 2 and shouldBe0 = 0
end function
