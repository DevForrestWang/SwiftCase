//
//===--- GSGraph.swift - Defines the GSGraph class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/30.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

public class GSGraph: CustomStringConvertible, Equatable {
    public private(set) var nodes: [GSNode]

    public init() {
        nodes = []
    }

    @discardableResult public func addNode(_ label: String) -> GSNode {
        let node = GSNode(label)
        nodes.append(node)
        return node
    }

    public func addEdge(_ source: GSNode, neighbor: GSNode) {
        let edge = GSEdge(neighbor)
        source.neighbors.append(edge)
    }

    public var description: String {
        var description = ""
        for node in nodes {
            if !node.neighbors.isEmpty {
                description += "[node: \(String(describing: node.label)) edges: \(node.neighbors.map { $0.neighbor.label })]"
            }
        }
        return description
    }

    public func findNodeWithLabel(_ label: String) -> GSNode {
        return nodes.filter { $0.label == label }.first!
    }

    public func duplicate() -> GSGraph {
        let duplicated = GSGraph()

        for node in nodes {
            duplicated.addNode(node.label)
        }

        for node in nodes {
            for edge in node.neighbors {
                let source = duplicated.findNodeWithLabel(node.label)
                let neighbour = duplicated.findNodeWithLabel(edge.neighbor.label)
                duplicated.addEdge(source, neighbor: neighbour)
            }
        }

        return duplicated
    }
}

public func == (lhs: GSGraph, rhs: GSGraph) -> Bool {
    return lhs.nodes == rhs.nodes
}
