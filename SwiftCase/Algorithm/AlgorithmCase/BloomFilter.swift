//
//===--- BloomFilter.swift - Defines the BloomFilter class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/27.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Bloom%20Filter/BloomFilter.swift
//
//===----------------------------------------------------------------------===//

import Foundation

public class BloomFilter<T> {
    private var array: [Bool]
    private var hashFunctions: [(T) -> Int]

    public init(size: Int = 1024, hashFunctions: [(T) -> Int]) {
        array = [Bool](repeating: false, count: size)
        self.hashFunctions = hashFunctions
    }

    private func computeHashes(_ value: T) -> [Int] {
        return hashFunctions.map { hashFunc in
            abs(hashFunc(value) % array.count)
        }
    }

    public func insert(_ element: T) {
        for hashValue in computeHashes(element) {
            array[hashValue] = true
        }
    }

    public func insert(_ values: [T]) {
        for value in values {
            insert(value)
        }
    }

    public func query(_ value: T) -> Bool {
        let hashValues = computeHashes(value)

        // Map hashes to indices in the Bloom Filter
        let results = hashValues.map { hashValue in
            array[hashValue]
        }

        // All values must be 'true' for the query to return true
        // This does NOT imply that the value is in the Bloom filter,
        // only that it may be. If the query returns false, however,
        // you can be certain that the value was not added.
        let exists = results.reduce(true) { $0 && $1 }
        return exists
    }

    public func isEmpty() -> Bool {
        // As soon as the reduction hits a 'true' value, the && condition will fail.
        return array.reduce(true) { prev, next in prev && !next }
    }
}

extension BloomFilter: CustomStringConvertible {
    public var description: String {
        var s = ""
        for x in array {
            s += (x ? "1" : "0") + " "
        }

        return s
    }
}

//===----------------------------------------------------------------------===//
//                              Hash Functions
//===----------------------------------------------------------------------===//
/// Two hash functions, adapted from http://www.cse.yorku.ca/~oz/hash.html

public func djb2(x: String) -> Int {
    var hash = 5381
    for char in x {
        hash = ((hash << 5) &+ hash) &+ char.hashValue
    }
    return Int(hash)
}

public func sdbm(x: String) -> Int {
    var hash = 0
    for char in x {
        hash = char.hashValue &+ (hash << 6) &+ (hash << 16) &- hash
    }
    return Int(hash)
}
