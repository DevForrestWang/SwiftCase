//
//===--- DepthFirstSearch.swift - Defines the DepthFirstSearch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Depth-First%20Search/DepthFirstSearch.swift
//
//===----------------------------------------------------------------------===//

import Foundation

func depthFirstSearch(_ graph: GSGraph, source: GSNode) -> [String] {
    var nodesExplored = [source.label]
    source.visited = true

    for edge in source.neighbors {
        if !edge.neighbor.visited {
            nodesExplored += depthFirstSearch(graph, source: edge.neighbor)
        }
    }
    return nodesExplored
}
