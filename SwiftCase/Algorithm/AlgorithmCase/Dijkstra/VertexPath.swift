//
//===--- VertexPath.swift - Defines the VertexPath class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/8.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Dijkstra%20Algorithm/Dijkstra.playground/Sources/Vertex.swift
//
//===----------------------------------------------------------------------===//

import Foundation

open class VertexPath {
    open var identifier: String
    open var neighbors: [(VertexPath, Double)] = []
    open var pathLengthFromStart = Double.infinity
    open var pathVerticesFromStart: [VertexPath] = []

    public init(identifier: String) {
        self.identifier = identifier
    }

    open func clearCache() {
        pathLengthFromStart = Double.infinity
        pathVerticesFromStart = []
    }
}

extension VertexPath: Hashable {
    open var hashValue: Int {
        return identifier.hashValue
    }
}

extension VertexPath: Equatable {
    public static func == (lhs: VertexPath, rhs: VertexPath) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
