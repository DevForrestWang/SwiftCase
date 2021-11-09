//
//===--- KnuthMorrisPratt.swift - Defines the KnuthMorrisPratt class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/2.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Knuth-Morris-Pratt/KnuthMorrisPratt.playground/Contents.swift
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Z-Algorithm/ZAlgorithm.swift
//
//===----------------------------------------------------------------------===//

/*  Knuth-Morris-Pratt algorithm for pattern/string matching

 The code is based on the book:
 "Algorithms on String, Trees and Sequences: Computer Science and Computational Biology"
 by Dan Gusfield
 Cambridge University Press, 1997
 */
import Foundation

//===----------------------------------------------------------------------===//
//                              NameZetaAlgorithm
//===----------------------------------------------------------------------===//
func ZetaAlgorithm(ptrn: String) -> [Int]? {
    let pattern = Array(ptrn)
    let patternLength: Int = pattern.count

    guard patternLength > 0 else {
        return nil
    }

    var zeta = [Int](repeating: 0, count: patternLength)

    var left: Int = 0
    var right: Int = 0
    var k_1: Int = 0
    var betaLength: Int = 0
    var textIndex: Int = 0
    var patternIndex: Int = 0

    for k in 1 ..< patternLength {
        if k > right {
            patternIndex = 0

            while k + patternIndex < patternLength,
                  pattern[k + patternIndex] == pattern[patternIndex]
            {
                patternIndex = patternIndex + 1
            }

            zeta[k] = patternIndex

            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }

        } else {
            k_1 = k - left + 1
            betaLength = right - k + 1

            if zeta[k_1 - 1] < betaLength {
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength {
                textIndex = betaLength
                patternIndex = right + 1

                while patternIndex < patternLength, pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }
                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}

extension String {
    func indexesOf(ptnr: String) -> [Int]? {
        let text = Array(self)
        let pattern = Array(ptnr)

        let textLength: Int = text.count
        let patternLength: Int = pattern.count

        guard patternLength > 0 else {
            return nil
        }

        var suffixPrefix = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        var indexes = [Int]()

        // Pre-processing stage: computing the table for the shifts (through Z-Algorithm)
        let zeta = ZetaAlgorithm(ptrn: ptnr)

        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta![patternIndex] - 1
            suffixPrefix[textIndex] = zeta![patternIndex]
        }

        // Search stage: scanning the text for pattern matching
        textIndex = 0
        patternIndex = 0

        while textIndex + (patternLength - patternIndex - 1) < textLength {
            while patternIndex < patternLength, text[textIndex] == pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }

            if patternIndex == patternLength {
                indexes.append(textIndex - patternIndex)
            }

            if patternIndex == 0 {
                textIndex = textIndex + 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }

        return indexes
    }
}
