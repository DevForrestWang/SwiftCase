//
//===--- BinarySearch.swift - Defines the BinarySearch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/20.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Binary%20Search/BinarySearch.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/// Recursively splits the array in half until the value is found.
/// The recursive version of binary search.
public func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    guard range.upperBound > range.lowerBound else {
        return nil
    }

    let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
    if key < a[midIndex] {
        return binarySearch(a, key: key, range: range.lowerBound ..< midIndex)
    } else if key > a[midIndex] {
        return binarySearch(a, key: key, range: midIndex + 1 ..< range.upperBound)
    } else {
        return midIndex
    }
}

/**
 The iterative version of binary search.

 Notice how similar these functions are. The difference is that this one
 uses a while loop, while the other calls itself recursively.
 **/
public func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count

    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if key < a[midIndex] {
            upperBound = midIndex
        } else if key > a[midIndex] {
            lowerBound = midIndex + 1
        } else {
            return midIndex
        }
    }

    return nil
}
