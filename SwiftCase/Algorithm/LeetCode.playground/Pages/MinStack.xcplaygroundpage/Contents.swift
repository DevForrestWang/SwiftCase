import UIKit

//===----------------------------------------------------------------------===//
// 题目：剑指 Offer 30. 包含min函数的栈
// 描述：定义栈的数据结构，请在该类型中实现一个能够得到栈的最小元素的 min 函数在该栈中，调用 min、push 及 pop 的时间复杂度都是 O(1)。
//===----------------------------------------------------------------------===/

class MinStack {
    init() {}

    func push(_: Int) {}

    func pop() {}

    func top() -> Int {}

    func min() -> Int {}
}

let obj = MinStack()
obj.push(x)
obj.pop()
let ret_3: Int = obj.top()
let ret_4: Int = obj.min()
