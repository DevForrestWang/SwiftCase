//
//===--- DijkstraData.swift - Defines the DijkstraData class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/8.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Dijkstra%20Algorithm/Dijkstra.playground/Contents.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public class DijkstraData {
    var vertices: Set<VertexPath> = Set()

    func createNotConnectedVertices() {
        // change this value to increase or decrease amount of vertices in the graph
        let numberOfVerticesInGraph = 15
        for i in 0 ..< numberOfVerticesInGraph {
            let vertex = VertexPath(identifier: "\(i)")
            vertices.insert(vertex)
        }
    }

    func setupConnections() {
        for vertex in vertices {
            // the amount of edges each vertex can have
            let randomEdgesCount = arc4random_uniform(4) + 1
            for _ in 0 ..< randomEdgesCount {
                // randomize weight value from 0 to 9
                let randomWeight = Double(arc4random_uniform(10))
                let neighborVertex = randomVertex(except: vertex)

                // we need this check to set only one connection between two equal pairs of vertices
                if vertex.neighbors.contains(where: { $0.0 == neighborVertex }) {
                    continue
                }

                // creating neighbors and setting them
                let neighbor1 = (neighborVertex, randomWeight)
                let neighbor2 = (vertex, randomWeight)
                vertex.neighbors.append(neighbor1)
                neighborVertex.neighbors.append(neighbor2)
            }
        }
    }

    func randomVertex(except vertex: VertexPath) -> VertexPath {
        var newSet = vertices
        newSet.remove(vertex)
        let offset = Int(arc4random_uniform(UInt32(newSet.count)))
        let index = newSet.index(newSet.startIndex, offsetBy: offset)
        return newSet[index]
    }

    func randomVertex() -> VertexPath {
        let offset = Int(arc4random_uniform(UInt32(vertices.count)))
        let index = vertices.index(vertices.startIndex, offsetBy: offset)
        return vertices[index]
    }
}
