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

class Solution {
    
    /// Definition for singly-linked list.
    public class ListNode {
        public var val: Int
        public var next: ListNode?
        public init(_ val: Int) {
            self.val = val
            self.next = nil
        }
    }
    
    public func append(_ value: Int) {
        let newNode = Node(value)
        append(newNode)
    }
    
    public func reversePrint(_ head: ListNode?) -> [Int] {
        return []
    }
    
    private func append(_ node: Node) {
        let newNode = node
        if let lastNode = last {
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    public typealias Node = ListNode
    
    private var head: Node?
    
    public var last: Node? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
}



