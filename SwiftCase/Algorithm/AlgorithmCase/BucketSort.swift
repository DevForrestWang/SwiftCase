//
//===--- BucketSort.swift - Defines the BucketSort class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/19.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Bucket%20Sort/BucketSort.swift
//
//===----------------------------------------------------------------------===//

import Foundation

//===----------------------------------------------------------------------===//
//                              Sortable
//===----------------------------------------------------------------------===//
public protocol IntConvertible {
    func toInt() -> Int
}

public protocol Sortable: IntConvertible, Comparable {}

//===----------------------------------------------------------------------===//
//                              Sorter
//===----------------------------------------------------------------------===//
public protocol Sorter {
    func sort<T: Sortable>(_ items: [T]) -> [T]
}

public struct InsertionSorter: Sorter {
    public init() {}

    public func sort<T>(_ items: [T]) -> [T] where T: Sortable {
        var results = items
        for i in 0 ..< results.count {
            var j = i
            while j > 0, results[j - 1] > results[j] {
                let auxiliar = results[j - 1]
                results[j - 1] = results[j]
                results[j] = auxiliar

                j -= 1
            }
        }

        return results
    }
}

//===----------------------------------------------------------------------===//
//                              Bucket
//===----------------------------------------------------------------------===//
public struct Bucket<T: Sortable> {
    var elements: [T]
    let capacity: Int

    public init(capacity: Int) {
        self.capacity = capacity
        elements = [T]()
    }

    public mutating func add(_ item: T) {
        if elements.count < capacity {
            elements.append(item)
        }
    }

    public func sort(_ algorithm: Sorter) -> [T] {
        return algorithm.sort(elements)
    }
}

//===----------------------------------------------------------------------===//
//                              Distributor
//===----------------------------------------------------------------------===//
public protocol Distributor {
    func distribute<T>(_ element: T, buckets: inout [Bucket<T>])
}

/*
 * An example of a simple distribution function that send every elements to
 * the bucket representing the range in which it fits.An
 *
 * If the range of values to sort is 0..<49 i.e, there could be 5 buckets of capacity = 10
 * So every element will be classified by the ranges:
 *
 * -  0 ..< 10
 * - 10 ..< 20
 * - 20 ..< 30
 * - 30 ..< 40
 * - 40 ..< 50
 *
 * By following the formula: element / capacity = #ofBucket
 */
public struct RangeDistributor: Distributor {
    public init() {}

    public func distribute<T>(_ element: T, buckets: inout [Bucket<T>]) where T: Sortable {
        let value = element.toInt()
        let bucketCapacity = buckets.first!.capacity

        let bucketIndex = value / bucketCapacity
        buckets[bucketIndex].add(element)
    }
}

private func allPositiveNumbers<T: Sortable>(_ array: [T]) -> Bool {
    return array.filter { $0.toInt() >= 0 }.count > 0
}

private func enoughSpaceInBuckets<T>(_ buckets: [Bucket<T>], elements: [T]) -> Bool {
    let maximumValue = elements.max()?.toInt()
    let totalCapacity = buckets.count * (buckets.first?.capacity)!

    guard let max = maximumValue else {
        return false
    }

    return totalCapacity >= max
}

//===----------------------------------------------------------------------===//
//                              Int Extensions
//===----------------------------------------------------------------------===//
extension Int: IntConvertible, Sortable {
    public func toInt() -> Int {
        return self
    }
}

/**
    Performs bucket sort algorithm on the given input elements.
    [Bucket Sort Algorithm Reference](https://en.wikipedia.org/wiki/Bucket_sort)
    - Parameter elements:     Array of Sortable elements
    - Parameter distributor:  Performs the distribution of each element of a bucket
    - Parameter sorter:       Performs the sorting inside each bucket, after all the elements are distributed
    - Parameter buckets:      An array of buckets
    - Returns: A new array with sorted elements
 */
public func bucketSort<T>(_ elements: [T], distributor: Distributor, sorter: Sorter, buckets: [Bucket<T>]) -> [T] {
    precondition(allPositiveNumbers(elements))
    precondition(enoughSpaceInBuckets(buckets, elements: elements))

    var bucketsCopy = buckets
    for elem in elements {
        distributor.distribute(elem, buckets: &bucketsCopy)
    }

    var results = [T]()
    for bucket in bucketsCopy {
        results += bucket.sort(sorter)
    }

    return results
}
