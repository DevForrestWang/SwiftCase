//
//===--- Queue.swift - Defines the Queue class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/11.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information:
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Queue/Queue-Optimized.swift
//
//===----------------------------------------------------------------------===//

/*
 First-in first-out queue (FIFO)
 New elements are added to the end of the queue. Dequeuing pulls elements from
 the front of the queue.
 Enqueuing and dequeuing are O(1) operations.
 */

import Foundation

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0

    public var isEmpty: Bool {
        return count == 0
    }

    public var count: Int {
        return array.count - head
    }

    public mutating func enqueue(_ element: T) {
        array.append(element)
    }

    public mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else { return nil }

        array[head] = nil
        head += 1

        let percentage = Double(head) / Double(array.count)
        if array.count > 50, percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }

        return element
    }

    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex ..< endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
