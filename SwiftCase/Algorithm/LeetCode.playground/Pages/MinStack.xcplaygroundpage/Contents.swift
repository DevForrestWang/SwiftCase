import UIKit

//===----------------------------------------------------------------------===//
// 题目：剑指 Offer 30. 包含min函数的栈
// 描述：定义栈的数据结构，请在该类型中实现一个能够得到栈的最小元素的 min 函数在该栈中，调用 min、push 及 pop 的时间复杂度都是 O(1)。
// 示例：
// MinStack minStack = new MinStack();
// minStack.push(-2);
// minStack.push(0);
// minStack.push(-3);
// minStack.min();   --> 返回 -3
// minStack.pop();
// minStack.top();   --> 返回 0
// minStack.min();   --> 返回 -2
//
// peek、top 不改变栈的值(不删除栈顶的值)；pop会把栈顶的值删除
//===----------------------------------------------------------------------===/

class MinStack {
    init() {}

    /// 添加元素
    func push(_ value: Int) {
        if let minValue = minStackAry.first {
            if value < minValue {
                minStackAry.insert(value, at: 0)
            } else {
                minStackAry.insert(minValue, at: 0)
            }
        } else {
            minStackAry.insert(value, at: 0)
        }

        stackAry.insert(value, at: 0)
    }

    /// 弹出栈顶元素
    func pop() {
        if stackAry.count <= 0 || minStackAry.count <= 0 {
            return
        }

        stackAry.remove(at: 0)
        minStackAry.remove(at: 0)
    }

    /// 获取栈顶元素
    func top() -> Int {
        return stackAry.first ?? Int.min
    }

    /// 返回最小元素
    func min() -> Int {
        minStackAry.first ?? Int.min
    }

    var stackAry: [Int] = []
    var minStackAry: [Int] = []
}

let obj = MinStack()
obj.push(-2)
obj.push(0)
obj.push(-3)
print(obj.min())
obj.pop()
print(obj.top())
print(obj.min())
