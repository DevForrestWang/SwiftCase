//
//===--- AdjacencyMatrixGraph.swift - Defines the AdjacencyMatrixGraph class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/29.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph/Graph/AdjacencyMatrixGraph.swift
//
//===----------------------------------------------------------------------===//

import Foundation

open class AdjacencyMatrixGraph<T>: AbstractGraph<T> where T: Hashable {
    // If adjacencyMatrix[i][j] is not nil, then there is an edge from vertex i to vertex j
    fileprivate var adjacencyMatrix: [[Double?]] = []
    fileprivate var _vertices: [Vertex<T>] = []

    public required init() {
        super.init()
    }

    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }

    override open var vertices: [Vertex<T>] {
        return _vertices
    }

    override open var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for row in 0 ..< adjacencyMatrix.count {
            for column in 0 ..< adjacencyMatrix.count {
                if let weight = adjacencyMatrix[row][column] {
                    edges.append(Edge(from: vertices[row], to: vertices[column], weight: weight))
                }
            }
        }

        return edges
    }

    // Adds a new vertex to the matrix.
    // Performance: possibly O(n^2) because of the resizing of the matrix.
    override open func createVertex(_ data: T) -> Vertex<T> {
        // check if the vertex already exists
        let matchingVertices = vertices.filter { vertex in
            vertex.data == data
        }

        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }

        // if the vertex doesn't exist, create a new one
        let vertex = Vertex(data: data, index: adjacencyMatrix.count)

        // Expand each existing row to the right one column.
        for i in 0 ..< adjacencyMatrix.count {
            adjacencyMatrix[i].append(nil)
        }

        // Add one new row at the bottom.
        let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)

        _vertices.append(vertex)
        return vertex
    }

    override open func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        adjacencyMatrix[from.index][to.index] = weight
    }

    override open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }

    override open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
    }

    override open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        var outEdges = [Edge<T>]()
        let fromIndex = sourceVertex.index
        for column in 0 ..< adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][column] {
                outEdges.append(Edge(from: sourceVertex, to: vertices[column], weight: weight))
            }
        }

        return outEdges
    }

    override open var description: String {
        var grid = [String]()
        let n = adjacencyMatrix.count
        for i in 0 ..< n {
            var row = ""
            for j in 0 ..< n {
                if let value = adjacencyMatrix[i][j] {
                    let number = NSString(format: "%.1f", value)
                    row += "\(value >= 0 ? " " : "")\(number) "
                } else {
                    row += "  ø  "
                }
            }
            grid.append(row)
        }
        return (grid as NSArray).componentsJoined(by: "\n")
    }
}
