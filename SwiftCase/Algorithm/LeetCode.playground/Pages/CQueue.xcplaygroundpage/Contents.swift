import UIKit

//===----------------------------------------------------------------------===//
// 题目：剑指 Offer 09. 用两个栈实现队列
// 描述：用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead ，分别完成在队列尾部插入整数和在队列头部删除整数的功能。(若队列中没有元素，deleteHead 操作返回 -1 )
//===----------------------------------------------------------------------===/
class CQueue {
    init() {}

    func appendTail(_ value: Int) {
        inArray.append(value)
    }

    func deleteHead() -> Int {
        if outArray.count <= 0 {
            if inArray.count <= 0 {
                return -1
            }
        }

        in2Out()
        return outArray.remove(at: 0)
    }

    private func in2Out() {
        while inArray.count > 0 {
            outArray.append(inArray.remove(at: 0))
        }
    }

    var inArray: [Int] = []
    var outArray: [Int] = []
}

let obj = CQueue()
obj.appendTail(3)
obj.appendTail(1)
obj.appendTail(2)
print(obj.deleteHead())
print(obj.deleteHead())
print(obj.deleteHead())
print(obj.deleteHead())
