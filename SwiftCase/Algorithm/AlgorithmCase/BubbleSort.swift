//
//===--- BubbleSort.swift - Defines the BubbleSort class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/15.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information:
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Bubble%20Sort/MyPlayground.playground/Sources/BubbleSort.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/// Performs the bubble sort algorithm in the array
///
/// - Parameter elements: a array of elements that implement the Comparable protocol
/// - Returns: an array with the same elements but in order
public func bubbleSort<T>(_ elements: [T]) -> [T] where T: Comparable {
    return bubbleSort(elements, <)
}

public func bubbleSort<T>(_ elements: [T], _ comparison: (T, T) -> Bool) -> [T] {
    var array = elements

    guard array.count > 1 else {
        return array
    }

    // Exit flag bit early when there is no sort
    var flag = false
    for i in 0 ..< array.count {
        flag = false
        for j in 1 ..< array.count - i {
            if comparison(array[j], array[j - 1]) {
                let tmp = array[j - 1]
                array[j - 1] = array[j]
                array[j] = tmp
                flag = true
            }
        }

        if !flag {
            break
        }
    }

    return array
}
