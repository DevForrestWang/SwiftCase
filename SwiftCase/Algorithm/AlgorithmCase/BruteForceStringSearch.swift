//
//===--- BruteForceStringSearch.swift - Defines the BruteForceStringSearch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by Forrest on 2021/10/31.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Brute-Force%20String%20Search/BruteForceStringSearch.swift
//
//===----------------------------------------------------------------------===//

import Foundation

/// Brute-force string search
extension String {
    func indexOf(_ pattern: String) -> String.Index? {
        for i in indices {
            var j = i
            var found = true
            for p in pattern.indices {
                if j == endIndex || self[j] != pattern[p] {
                    found = false
                    break
                } else {
                    j = index(after: j)
                }
            }
            if found {
                return i
            }
        }
        return nil
    }
}
