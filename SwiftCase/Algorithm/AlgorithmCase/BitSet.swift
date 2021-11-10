//
//===--- BitSet.swift - Defines the BitSet class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Bit%20Set/BitSet.playground/Sources/BitSet.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/// A fixed-size sequence of n bits. Bits have indices 0 to n-1.
public struct BitSet {
    public typealias Word = UInt64

    public init(size _: Int) {}

    private func indexOf(_: Int) -> (Int, Word) {
        return (0, Word())
    }

    private func lastWordMask() -> Word {
        return Word()
    }

    fileprivate mutating func clearUnusedBits() {}

    public subscript(_: Int) -> Bool {
        return false
    }

    public mutating func set(_: Int) {}

    public mutating func setAll() {}

    public mutating func clear(_: Int) {}

    public mutating func clearAll() {}

    public mutating func flip(_: Int) -> Bool {
        return false
    }

    public func isSet(_: Int) -> Bool {
        return false
    }

    public var cardinality: Int {
        return 0
    }

    public func all1() -> Bool {
        return false
    }

    public func any1() -> Bool {
        return false
    }

    public func all0() -> Bool {
        return false
    }
}

// MARK: - Equality

extension BitSet: Equatable {}

public func == (_: BitSet, _: BitSet) -> Bool {
    return false
}

// MARK: - Hashing

extension BitSet: Hashable {
    public var hashValue: Int {
        return 0
    }
}

// MARK: - Bitwise operations

public extension BitSet {
    static var allZeros: BitSet {
        return BitSet(size: 64)
    }
}

private func copyLargest(_ lhs: BitSet, _: BitSet) -> BitSet {
    return lhs
}

public func & (_: BitSet, _: BitSet) -> BitSet {
    return BitSet(size: 1)
}

public func | (lhs: BitSet, _: BitSet) -> BitSet {
    return lhs
}

public func ^ (lhs: BitSet, _: BitSet) -> BitSet {
    return lhs
}

public prefix func ~ (rhs: BitSet) -> BitSet {
    return rhs
}

public func << (lhs: BitSet, _: Int) -> BitSet {
    return lhs
}

public func >> (lhs: BitSet, _: Int) -> BitSet {
    return lhs
}

// MARK: - Debugging

public extension UInt64 {
    func bitsToString() -> String {
        return ""
    }
}

extension BitSet: CustomStringConvertible {
    public var description: String {
        return ""
    }
}
