//
//===--- Quicksort.swift - Defines the Quicksort class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/18.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Quicksort/Quicksort.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/*
 Easy to understand but not very efficient.
 */

func quickSort<T: Comparable>(_ a: [T]) -> [T] {
    guard a.count > 1 else {
        return a
    }

    let pivot = a[a.count / 2]
    let less = a.filter {
        $0 < pivot
    }

    let equal = a.filter {
        $0 == pivot
    }

    let greater = a.filter {
        $0 > pivot
    }

    return quickSort(less) + equal + quickSort(greater)
}

// *** Dutch national flag partioning ***

/*
 Swift's swap() doesn't like it if the items you're trying to swap refer to
 the same memory location. This little wrapper simply ignores such swaps.
 */
public func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
    if i != j {
        a.swapAt(i, j)
    }
}

/*
 Dutch national flag partitioning
 Partitions the array into three sections: all element smaller than the pivot,
 all elements equal to the pivot, and all larger elements.
 This makes for a more efficient Quicksort if the array contains many duplicate
 elements.
 Returns a tuple with the start and end index of the middle area. For example,
 on [0,1,2,3,3,3,4,5] it returns (3, 5). Note: These indices are relative to 0,
 not to "low"!
 The number of occurrences of the pivot is: result.1 - result.0 + 1
 Time complexity is O(n), space complexity is O(1).
 */
func partitionButchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
    let pivot = a[pivotIndex]

    var smaller = low
    var equal = low
    var larger = high

    // This loop partitions the array into four (possibly empty) regions:
    //   [low    ...smaller-1] contains all values < pivot,
    //   [smaller...  equal-1] contains all values == pivot,
    //   [equal  ...   larger] contains all values > pivot,
    //   [larger ...     high] are values we haven't looked at yet.
    while equal <= larger {
        if a[equal] < pivot {
            swap(&a, smaller, equal)
            smaller += 1
            equal += 1
        } else if a[equal] == pivot {
            equal += 1
        } else {
            swap(&a, equal, larger)
            larger -= 1
        }
    }

    return (smaller, larger)
}

/*
 Uses Dutch national flag partitioning and a random pivot index.
 */
func quickSortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = Randoms.randomInt(low, high)
        let (p, q) = partitionButchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
        quickSortDutchFlag(&a, low: low, high: p - 1)
        quickSortDutchFlag(&a, low: q + 1, high: high)
    }
}
