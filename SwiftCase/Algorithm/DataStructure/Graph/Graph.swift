//
//===--- Graph.swift - Defines the Graph class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph/Graph/Graph.swift
//
//===----------------------------------------------------------------------===//

import Foundation

open class AbstractGraph<T>: CustomStringConvertible where T: Hashable {
    public required init() {}

    public required init(fromGraph graph: AbstractGraph<T>) {
        for edge in graph.edges {
            let from = createVertex(edge.from.data)
            let to = createVertex(edge.to.data)

            addDirectedEdge(from, to: to, withWeight: edge.weight)
        }
    }

    open var description: String {
        fatalError("abstract property accessed")
    }

    open var vertices: [Vertex<T>] {
        fatalError("abstract property accessed")
    }

    open var edges: [Edge<T>] {
        fatalError("abstract property accessed")
    }

    // Adds a new vertex to the matrix.
    // Performance: possibly O(n^2) because of the resizing of the matrix.
    open func createVertex(_: T) -> Vertex<T> {
        fatalError("abstract function called")
    }

    open func addDirectedEdge(_: Vertex<T>, to _: Vertex<T>, withWeight _: Double?) {
        fatalError("abstract function called")
    }

    open func addUndirectedEdge(_: (Vertex<T>, Vertex<T>), withWeight _: Double?) {
        fatalError("abstract function called")
    }

    open func weightFrom(_: Vertex<T>, to _: Vertex<T>) -> Double? {
        fatalError("abstract function called")
    }

    open func edgesFrom(_: Vertex<T>) -> [Edge<T>] {
        fatalError("abstract function called")
    }
}
