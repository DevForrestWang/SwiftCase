//
//===--- GSEdge.swift - Defines the GSEdge class ----------===//
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

public class GSEdge: Equatable {
    public var neighbor: GSNode

    public init(_ neighbor: GSNode) {
        self.neighbor = neighbor
    }
}

public func == (_ lhs: GSEdge, rhs: GSEdge) -> Bool {
    return lhs.neighbor == rhs.neighbor
}
