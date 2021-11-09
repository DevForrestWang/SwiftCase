//
//===--- LRUCache.swift - Defines the LRUCache class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/LRU%20Cache/LRUCache.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public class LRUCache<KeyType: Hashable> {
    private let maxSize: Int
    // 缓存的数据
    private var cache: [KeyType: Any] = [:]
    // 优先队列，最新的放到最开始位置
    private var priority = LinkedList<KeyType>()
    // 辅助优先队列使用
    private var key2node: [KeyType: LinkedList<KeyType>.LinkedListNode<KeyType>] = [:]

    public init(_ maxSize: Int) {
        self.maxSize = maxSize
    }

    public func get(_ key: KeyType) -> Any? {
        guard let val = cache[key] else {
            return nil
        }

        // 将使用的数据移到优先队列最前
        remove(key)
        insert(key, val: val)
        return val
    }

    public func set(_ key: KeyType, val: Any) {
        if cache[key] != nil {
            remove(key)
        } else if priority.count >= maxSize, let keyToRemove = priority.last?.value {
            remove(keyToRemove)
        }

        insert(key, val: val)
    }

    private func remove(_ key: KeyType) {
        cache.removeValue(forKey: key)
        guard let node = key2node[key] else {
            return
        }
        priority.remove(node: node)
        key2node.removeValue(forKey: key)
    }

    private func insert(_ key: KeyType, val: Any) {
        cache[key] = val
        priority.insert(key, at: 0)
        // priority 链表的节点
        guard let first = priority.first else {
            return
        }

        key2node[key] = first
    }
}
