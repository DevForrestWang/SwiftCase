//
//===--- Huffman.swift - Defines the Huffman class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Huffman%20Coding/Huffman.playground/Sources/Huffman.swift
//
//===----------------------------------------------------------------------===//

/*
 Basic implementation of Huffman encoding. It encodes bytes that occur often
 with a smaller number of bits than bytes that occur less frequently.
 Based on Al Stevens' C Programming column from Dr.Dobb's Magazine, February
 1991 and October 1992.
 Note: This code is not optimized for speed but explanation.
 */
import Foundation

public class Huffman {
    // Tree nodes don't use pointers to refer to each other, but simple integer indices. That allows us to use structs
    // for the nodes.
    typealias NodeIndex = Int

    // A node in the compression tree. Leaf nodes represent the actual bytes that are present in the input data.
    // The count of an intermediary node is the sum  of the counts of all nodes below it. The root node's count is the
    // number of bytes in the original, uncompressed input data.
    struct Node {
        var count = 0
        var index: NodeIndex = -1
        var parent: NodeIndex = -1
        var left: NodeIndex = -1
        var right: NodeIndex = -1
    }

    // The tree structure. The first 256 entries are for the leaf nodes (not all of those may be used, depending on the input).
    // We add additional nodes as we build the tree.
    var tree = [Node](repeating: Node(), count: 256)

    // This is the last node we add to the tree.
    var root: NodeIndex = -1

    // The frequency table describes how often a byte occurs in the input data. You need it to decompress the
    // Huffman-encoded data. The frequency table should be serialized along with the compressed data.
    public struct Freq {
        var byte: UInt8 = 0
        var count = 0
    }

    public init() {}
}

extension Huffman {
    /// To compress a block of data, first we need to count how often each byte occurs.
    /// These counts are stored in the first 256 nodes in the tree, i.e.
    /// the leaf nodes. The requency table used by decompression is derived from this
    fileprivate func countByteFrequency(inData data: NSData) {
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
        for _ in 0 ..< data.length {
            let i = Int(ptr.pointee)
            tree[i].count += 1
            tree[i].index = i
            ptr = ptr.successor()
        }
    }

    /// Takes a frequency table and rebuilds the tree. This is the first step of decompression.
    fileprivate func restoreTree(fromTable frequencyTable: [Freq]) {
        for freq in frequencyTable {
            let i = Int(freq.byte)
            tree[i].count = freq.count
            tree[i].index = i
        }
        buildTree()
    }

    /// Returns the frequency table. This is the first 256 nodes from the tree but only those that are actually used,
    /// without the parent/left/right points.
    /// You would serialize this along with the compressed file.
    public func frequencyTable() -> [Freq] {
        var a = [Freq]()
        for i in 0 ..< 256 where tree[i].count > 0 {
            a.append(Freq(byte: UInt8(i), count: tree[i].count))
        }
        return a
    }
}

private extension Huffman {
    /// Builds a Huffman tree from a frequency table.
    func buildTree() {
        // Create a min-priority queue and enqueue all used nodes.
        var queue = PriorityQueue<Node> { $0.count < $1.count }

        for node in tree where node.count > 0 {
            queue.enqueue(node)
        }

        while queue.count > 1 {
            // FInd the two nodes with the smallest frequencies that do not have a parent node yet.
            let node1 = queue.dequeue()!
            let node2 = queue.dequeue()!

            // Create a new intermediate node.
            var parentNode = Node()
            parentNode.count = node1.count + node2.count
            parentNode.left = node1.index
            parentNode.right = node2.index
            parentNode.index = tree.count
            tree.append(parentNode)

            // Link the two nodes into their new parent node.
            tree[node1.index].parent = parentNode.index
            tree[node2.index].parent = parentNode.index

            // Put the intermediate node back into the queue.
            queue.enqueue(parentNode)
        }

        // The final remaining node in the queue becomes the root of the tree.
        let rootNode = queue.dequeue()!
        root = rootNode.index
    }
}

extension Huffman {
    /// Compresses the contents of an NSData object.
    public func compressData(data: NSData) -> NSData {
        countByteFrequency(inData: data)
        buildTree()

        let writer = BitWriter()
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
        for _ in 0 ..< data.length {
            let c = ptr.pointee
            let i = Int(c)
            traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
            ptr = ptr.successor()
        }

        writer.flush()
        return writer.data
    }

    /// Recursively walks the tree from a leaf node up to the root, and then back again.
    /// If a child is the right node, we emit a 0 bit; if it's the left node,we emit a 1 bit.
    private func traverseTree(writer: BitWriter, nodeIndex h: Int, childIndex child: Int) {
        if tree[h].parent != -1 {
            traverseTree(writer: writer, nodeIndex: tree[h].parent, childIndex: h)
        }

        if child != -1 {
            if child == tree[h].left {
                writer.writeBit(bit: true)
            } else if child == tree[h].right {
                writer.writeBit(bit: false)
            }
        }
    }
}

extension Huffman {
    /// Takes a Huffman-compressed NSData object and outputs the uncompressed data.
    public func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
        restoreTree(fromTable: frequencyTable)

        let reader = BitReader(data: data)
        let outData = NSMutableData()
        let byteCount = tree[root].count

        var i = 0
        while i < byteCount {
            var b = findLeafNode(reader: reader, nodeIndex: root)
            outData.append(&b, length: 1)
            i += 1
        }

        return outData
    }

    /// Walks the tree from the root down to the leaf node. At every node,
    /// read the next bit and use that to detemine whether to step to the left or right.
    /// When we get to the leaf node, we simply return its index, which is equal to the original byte value.
    private func findLeafNode(reader: BitReader, nodeIndex: Int) -> UInt8 {
        var h = nodeIndex
        while tree[h].right != -1 {
            if reader.readBit() {
                h = tree[h].left
            } else {
                h = tree[h].right
            }
        }
        return UInt8(h)
    }
}
