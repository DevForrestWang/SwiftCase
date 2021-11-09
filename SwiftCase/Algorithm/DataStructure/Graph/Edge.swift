//
//===--- Edge.swift - Defines the Edge class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/29.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph/Graph/Edge.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public struct Edge<T>: Equatable where T: Hashable {
    public let from: Vertex<T>
    public let to: Vertex<T>

    public let weight: Double?
}

extension Edge: CustomStringConvertible {
    public var description: String {
        guard let unwrappedWeight = weight else {
            return "\(from.description) -> \(to.description)"
        }

        return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)

        if weight != nil {
            hasher.combine(weight)
        }
    }
}

public func == <T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    guard lhs.from == rhs.from else {
        return false
    }

    guard lhs.to == rhs.to else {
        return false
    }

    guard lhs.weight == rhs.weight else {
        return false
    }

    return true
}
