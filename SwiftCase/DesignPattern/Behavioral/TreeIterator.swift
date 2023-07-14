//
//===--- TreeIterator.swift - Defines the TreeIterator class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
/*:
  ### 迭代器模式是一种行为设计模式，让你能在不暴露集合底层表现形式（列表、 栈和树等）的情况下遍历集合中所有的元素。
  ### 理论：
    1、当集合背后为复杂的数据结构，且你希望对客户端隐藏其复杂性时（出于使用便利性或安全性的考虑），可以使用迭代器模式。
    2、 使用该模式可以减少程序中重复的遍历代码。
    3、如果你希望代码能够遍历不同的甚至是无法预知的数据结构，可以使用迭代器模式。

 ### 用法
     testTreeIterator()
 */
class TreeIterator<T> {
    var value: T
    var left: TreeIterator<T>?
    var right: TreeIterator<T>?

    init(_ value: T) {
        self.value = value
    }

    typealias Block = (T) -> Void

    enum IterationType {
        case inOrder
        case preOrder
        case postOrder
    }

    func iterator(_ type: IterationType) -> AnyIterator<T> {
        var items = [T]()
        switch type {
        case .inOrder:
            inOrder { items.append($0) }
        case .preOrder:
            preOrder { items.append($0) }
        case .postOrder:
            postOrder { items.append($0) }
        }

        /// Note:
        /// AnyIterator is used to hide the type signature of an internal
        /// iterator.
        return AnyIterator(items.makeIterator())
    }

    /// 中序，值在中间
    private func inOrder(_ body: Block) {
        left?.inOrder(body)
        body(value)
        right?.inOrder(body)
    }

    // 前序
    private func preOrder(_ body: Block) {
        body(value)
        left?.inOrder(body)
        right?.inOrder(body)
    }

    /// 后序
    private func postOrder(_ body: Block) {
        left?.inOrder(body)
        right?.inOrder(body)
        body(value)
    }
}

//===----------------------------------------------------------------------===//
//                              IteratorClient
//===----------------------------------------------------------------------===//
class IteratorClient {
    func clientCode<T>(iterator: AnyIterator<T>) {
        while case let item? = iterator.next() {
            SC.log(item)
        }
    }
}
