//
//===--- SkipList.swift - Defines the SkipList class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/20.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Skip-List/SkipList.swift
//
// skip list visualization:
// https://cmps-people.ok.ubc.ca/ylucet/DS/SkipList.html
//
//===----------------------------------------------------------------------===//

import Foundation
import GRPC

//===----------------------------------------------------------------------===//
//                              SkipList
//===----------------------------------------------------------------------===//
public class DataNode<Key: Comparable, Payload> {
    public typealias Node = DataNode<Key, Payload>

    var data: Payload?
    fileprivate var key: Key?
    var next: Node?
    var down: Node?

    public init(key: Key, data: Payload) {
        self.key = key
        self.data = data
    }

    public init(asHead _: Bool) {}
}

open class SkipList<Key: Comparable, Payload> {
    public typealias Node = DataNode<Key, Payload>

    fileprivate(set) var head: Node?

    public init() {}
}

// MARK: - Search lanes for a node with a given key

extension SkipList {
    func findNode(key: Key) -> Node? {
        var currentNode: Node? = head
        var isFound: Bool = false

        while !isFound {
            if let node = currentNode {
                switch node.next {
                case .none:
                    currentNode = node.down
                case let .some(value) where value.key != nil:

                    if value.key == key {
                        isFound = true
                        break
                    } else {
                        if key < value.key! {
                            currentNode = node.down
                        } else {
                            currentNode = node.next
                        }
                    }
                default:
                    continue
                }
            } else {
                break
            }
        }

        if isFound {
            return currentNode
        } else {
            return nil
        }
    }

    func search(key: Key) -> Payload? {
        guard let node = findNode(key: key) else {
            return nil
        }

        return node.next!.data
    }
}

// MARK: - Insert a node into lanes depending on skip list status ( bootstrap base-layer if head is empty / start insertion from current head ).

extension SkipList {
    private func bootstrapBaseLayer(key: Key, data: Payload) {
        head = Node(asHead: true)
        var node = Node(key: key, data: data)
        head!.next = node
        var currentTopNode = node

        while coinFlip() {
            let newHead = Node(asHead: true)
            node = Node(key: key, data: data)
            node.down = currentTopNode
            newHead.next = node
            newHead.down = head
            head = newHead
            currentTopNode = node
        }
    }

    private func insertItem(key: Key, data: Payload) {
        var stack = Stack<Node>()
        var currentNode: Node? = head

        while currentNode != nil {
            if let nextNode = currentNode!.next {
                if nextNode.key! > key {
                    stack.push(currentNode!)
                    currentNode = currentNode!.down
                } else {
                    currentNode = nextNode
                }
            } else {
                stack.push(currentNode!)
                currentNode = currentNode!.down
            }
        }

        let itemAtLayer = stack.pop()
        var node = Node(key: key, data: data)
        node.next = itemAtLayer!.next
        itemAtLayer!.next = node
        var currentTopNode = node

        while coinFlip() {
            if stack.isEmpty {
                let newHead = Node(asHead: true)

                node = Node(key: key, data: data)
                node.down = currentTopNode
                newHead.next = node
                newHead.down = head
                head = newHead
                currentTopNode = node
            } else {
                let nextNode = stack.pop()

                node = Node(key: key, data: data)
                node.down = currentTopNode
                node.next = nextNode!.next
                nextNode!.next = node
                currentTopNode = node
            }
        }
    }

    private func coinFlip() -> Bool {
        return arc4random_uniform(2) == 1
    }

    public func insert(key: Key, data: Payload) {
        if head != nil {
            if let node = findNode(key: key) {
                // replace, in case of key already exists.
                var currentNode = node.next
                while currentNode != nil, currentNode!.key == key {
                    currentNode!.data = data
                    currentNode = currentNode!.down
                }
            } else {
                insertItem(key: key, data: data)
            }
        } else {
            bootstrapBaseLayer(key: key, data: data)
        }
    }
}

// MARK: - Remove a node with a given key. First, find its position in layers at the top, then remove it from each lane by traversing down to the base layer.

public extension SkipList {
    func remove(key: Key) {
        guard let item = findNode(key: key) else {
            return
        }

        var currentNode = Optional(item)
        while currentNode != nil {
            let node = currentNode!.next

            if node!.key != key {
                currentNode = node
                continue
            }

            let nextNode = node!.next
            currentNode!.next = nextNode
            currentNode = currentNode!.down
        }
    }
}

// MARK: - Get associated payload from a node with a given key.

public extension SkipList {
    func get(key: Key) -> Payload? {
        return search(key: key)
    }
}
