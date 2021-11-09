//
//===--- BinarySearchTree.swift - Defines the BinarySearchTree class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Binary%20Search%20Tree/Solution%201/BinarySearchTree.playground/Sources/BinarySearchTree.swift
//
//===----------------------------------------------------------------------===//
/*
 A binary search tree.
 Each node stores a value and two children. The left child contains a smaller
 value; the right a larger (or equal) value.
 This tree allows duplicate elements.
 This tree does not automatically balance itself. To make sure it is balanced,
 you should insert new values in randomized order, not in sorted order.
 */

import Foundation

public class BinarySearchTree<T: Comparable> {
    public fileprivate(set) var value: T
    public fileprivate(set) var parent: BinarySearchTree?
    public fileprivate(set) var left: BinarySearchTree?
    public fileprivate(set) var right: BinarySearchTree?

    public init(value: T) {
        self.value = value
    }

    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)

        for v in array.dropFirst() {
            insert(value: v)
        }
    }

    public var isRoot: Bool {
        return parent == nil
    }

    public var isLeaf: Bool {
        return left == nil && right == nil
    }

    public var isLeftChild: Bool {
        return parent?.left === self
    }

    public var isRightChild: Bool {
        return parent?.right === self
    }

    public var hasLeftChild: Bool {
        return left != nil
    }

    public var hasRightChild: Bool {
        return right != nil
    }

    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }

    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }

    // How many nodes are in this subtree
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
}

// MARK: - Adding items

public extension BinarySearchTree {
    /*
     Inserts a new element into the tree. You should only insert elements at the root, to make to sure this remains a
     valid binary tree!
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }
}

// MARK: - Deleting items

extension BinarySearchTree {
    /*
       Deletes a node from the tree.
       Returns the node that has replaced this removed one (or nil if this was a leaf node). That is primarily useful
      for when you delete the root node, in which case the tree gets a new root.
       Performance: runs in O(h) time, where h is the height of the tree.
     */
    @discardableResult public func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree?

        // Replacement for current node can be either biggest one on the left or samplest one on the right, whichever is no nil
        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }

        replacement?.remove()

        // Place the replacement on current mode's position
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParentTo(node: replacement)

        // The current node is no longer part of the tree, so clean it up.
        parent = nil
        left = nil
        right = nil

        return replacement
    }

    private func reconnectParentTo(node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
}

// MARK: - Searching

public extension BinarySearchTree {
    // Finds the highest node with the specified value
    func search(value: T) -> BinarySearchTree? {
        var node: BinarySearchTree? = self
        while let n = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }

        return nil
    }

    func contains(value: T) -> Bool {
        return search(value: value) != nil
    }

    /// Returns the leftmost descendent.
    func minimum() -> BinarySearchTree {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }

    /// Returns the rightmost descendent
    func maximum() -> BinarySearchTree {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }

    /// Calculates the depth of this node, i.e. the distance to the root
    func depth() -> Int {
        var node = self
        var edges = 0
        while let parent = node.parent {
            node = parent
            edges += 1
        }

        return edges
    }

    /// Calculates the height of this node, i.e. the distance to the lowest leaf.
    func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }

    /// Finds the node whose value precedes our value in sorted order.
    func predecessor() -> BinarySearchTree? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }

    /// Finds the node whose value succeeds our value in sorted order.
    func successor() -> BinarySearchTree? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
}

// MARK: - Traversal

public extension BinarySearchTree {
    func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }

    func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }

    func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }

    /// Performs an in-order traversal and collects the results in an array.
    func map(formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left {
            a += left.map(formula: formula)
        }

        a.append(formula(value))

        if let right = right {
            a += right.map(formula: formula)
        }

        return a
    }
}

// MARK: - Is this binary tree a valid binary search tree?

public extension BinarySearchTree {
    func isBST(minValue: T, maxValue: T) -> Bool {
        if value < minValue || value > maxValue {
            return false
        }

        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
}

// MARK: - Debugging

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }

        s += "\(value)"

        if let right = right {
            s += " -> (\(right.description))"
        }

        return s
    }

    public func toArray() -> [T] {
        return map { $0 }
    }
}
