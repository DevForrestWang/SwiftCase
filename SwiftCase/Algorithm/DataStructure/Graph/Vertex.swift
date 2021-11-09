//
//===--- Vertex.swift - Defines the Vertex class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/29.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph/Graph/Vertex.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public struct Vertex<T>: Equatable where T: Hashable {
    public var data: T
    public let index: Int
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index): \(data)"
    }
}

extension Vertex: Hashable {
    public func hasher(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(index)
    }
}

public func == <T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    guard lhs.index == rhs.index else {
        return false
    }

    guard lhs.data == rhs.data else {
        return false
    }

    return true
}
