//
//===--- SelectionSort.swift - Defines the SelectionSort class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/18.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Selection%20Sort/SelectionSort.playground/Sources/SelectionSort.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/// Performs the Selection sort algorithm on a array
///
/// - Parameter array: array of elements that conform to the Comparable protocol
/// - Returns: an array in ascending order
public func selectionSort<T: Comparable>(_ array: [T]) -> [T] {
    return selectionSort(array, <)
}

/// Performs the Selection sort algorithm on a array using the provided comparisson method
///
/// - Parameters:
///   - array: array of elements that conform to the Comparable protocol
///   - isLowerThan: returns true if the two provided elements are in the correct order
/// - Returns: a sorted array

public func selectionSort<T>(_ array: [T], _ isLowerThan: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else {
        return array
    }

    var sortedArray = array
    for index in 0 ..< sortedArray.count - 1 {
        // Find the lowest value in the rest of the array.
        var lowest = index
        for y in index + 1 ..< sortedArray.count {
            if isLowerThan(sortedArray[y], sortedArray[lowest]) {
                lowest = y
            }
        }

        // Swap the lowest value with the current array index.
        if index != lowest {
            sortedArray.swapAt(index, lowest)
        }
    }
    return sortedArray
}
