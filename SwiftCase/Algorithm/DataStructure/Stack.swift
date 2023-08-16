//
//===--- Stack.swift - Defines the Stack class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/9.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information:
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Stack/Stack.swift
//
//===----------------------------------------------------------------------===//

/*
 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct Stack<T> {
    fileprivate var array = [T]()

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func push(_ element: T) {
        array.append(element)
    }

    public mutating func pop() -> T? {
        return array.popLast()
    }

    public var top: T? {
        return array.last
    }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            curr.pop()
        }
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
        var s = "["
        var i = 0
        let nums = array.count - 1

        for index in array {
            s += "\(index)"
            if i != nums {
                s += ", "
            }
            i += 1
        }
        return s + "]"
    }
}
