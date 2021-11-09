//
//===--- Dijkstra.swift - Defines the Dijkstra class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Dijkstra%20Algorithm/Dijkstra.playground/Sources/Dijkstra.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public class Dijkstra {
    private var totalVertices: Set<VertexPath>

    public init(vertices: Set<VertexPath>) {
        totalVertices = vertices
    }

    private func clearCache() {
        totalVertices.forEach { $0.clearCache() }
    }

    public func findShortestPaths(from startVertex: VertexPath) {
        clearCache()
        var currentVertices = totalVertices
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        var currentVertex: VertexPath? = startVertex

        while let vertex = currentVertex {
            currentVertices.remove(vertex)
            let filteredNeighbors = vertex.neighbors.filter {
                currentVertices.contains($0.0)
            }

            for neighbor in filteredNeighbors {
                let neighborVertex = neighbor.0
                let weight = neighbor.1

                let theoreticNewWeight = vertex.pathLengthFromStart + weight
                if theoreticNewWeight < neighborVertex.pathLengthFromStart {
                    neighborVertex.pathLengthFromStart = theoreticNewWeight
                    neighborVertex.pathVerticesFromStart = vertex.pathVerticesFromStart
                    neighborVertex.pathVerticesFromStart.append(neighborVertex)
                }
            }

            if currentVertices.isEmpty {
                currentVertex = nil
                break
            }

            currentVertex = currentVertices.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
    }
}
