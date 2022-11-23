//: [Previous](@previous)

import Foundation

//===----------------------------------------------------------------------===//
// 题目：剑指 Offer 06. 从尾到头打印链表
// 描述：输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。
// 示例：
// 输入：head = [1,3,2]
// 输出：[2,3,1]
//
//===----------------------------------------------------------------------===/

/// 定义列表结构
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class LinkedList {
    public func append(_ value: Int) {
        let newNode = ListNode(value)
        append(newNode)
    }
    
    private func append(_ node: ListNode) {
        let newNode = node
        if let lastNode = last {
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    public var head: ListNode?
    
    public var last: ListNode? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
}

class Solution {
    public func reversePrint(_ head: ListNode?) -> [Int] {
        var result: [Int] = []
        guard var node = head else {
            return result
        }
        
        result.append(node.val)
        while let next = node.next {
            result.append(next.val)
            node = next
        }
        
        return result.reversed()
    }
    
    // 剑指 Offer 24. 反转链表
    // 定义一个函数，输入一个链表的头节点，反转该链表并输出反转后链表的头节点。
    //输入: 1->2->3->4->5->NULL
    //输出: 5->4->3->2->1->NULL
    func reverseList(_ head: ListNode?) -> ListNode? {
        var prev: ListNode? = nil
        var curr: ListNode? = head
        
        while (curr != nil) {
            let tmp = curr?.next // 暂存后继节点 cur.next
            curr?.next = prev    // 修改 next 引用指向
            prev = curr          // pre 暂存 cur
            curr = tmp           // cur 访问下一节点
        }
        
        return prev
    }
    
    func printList(_ head: ListNode?) {
        guard var node = head else {
            print("Na")
            return
        }
        
        var result: [Int] = []
        result.append(node.val)
        while let next = node.next {
            result.append(next.val)
            node = next
        }
        
        print(result)
    }
}

let list = LinkedList()
list.append(1)
list.append(2)
list.append(3)
list.append(4)
list.append(5)
print(Solution().reversePrint(list.head))

let sl = Solution()
sl.printList(sl.reverseList(list.head))




