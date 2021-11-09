//
//===--- GSNode.swift - Defines the GSNode class ----------===//
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

public class GSNode: CustomStringConvertible, Equatable {
    public var neighbors: [GSEdge]

    public private(set) var label: String
    public var distance: Int?
    public var visited: Bool

    public init(_ label: String) {
        self.label = label
        neighbors = []
        visited = false
    }

    public var description: String {
        if let distance = distance {
            return "Node(label: \(String(describing: label)), distance: \(distance))"
        }
        return "Node(label: \(String(describing: label)), distance: infinity)"
    }

    public var hasDistance: Bool {
        return distance != nil
    }

    public func remove(_ edge: GSEdge) {
        neighbors.remove(at: neighbors.firstIndex { $0 === edge }!)
    }
}

public func == (_ lhs: GSNode, rhs: GSNode) -> Bool {
    return lhs.label == rhs.label && lhs.neighbors == rhs.neighbors
}
