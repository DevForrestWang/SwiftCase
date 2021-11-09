//
//===--- BreadthFirstSearch.swift - Defines the BreadthFirstSearch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Breadth-First%20Search/BreadthFirstSearch.swift
//
//===----------------------------------------------------------------------===//

import Foundation

func breadthFirstSearch(_: GSGraph, source: GSNode) -> [String] {
    var queue = Queue<GSNode>()
    queue.enqueue(source)

    var nodesExplored = [source.label]
    source.visited = true

    while let current = queue.dequeue() {
        for edge in current.neighbors {
            let neighborNode = edge.neighbor
            if !neighborNode.visited {
                queue.enqueue(neighborNode)
                neighborNode.visited = true
                nodesExplored.append(neighborNode.label)
            }
        }
    }
    return nodesExplored
}
