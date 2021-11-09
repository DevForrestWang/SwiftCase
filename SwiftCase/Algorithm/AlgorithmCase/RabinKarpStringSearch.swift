//
//===--- RabinKarpStringSearch.swift - Defines the RabinKarpStringSearch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/1.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

struct Constants {
    static let hashMultiplier = 69069
}

precedencegroup PowerPrecedence {
    higherThan: MultiplicationPrecedence
}

infix operator **: PowerPrecedence
func ** (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

func ** (radix: Double, power: Int) -> Double {
    return pow(radix, Double(power))
}

extension Character {
    var asInt: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

public func hash(array: [Int]) -> Double {
    var total: Double = 0
    var expoent = array.count - 1
    for i in array {
        total += Double(i) * (Double(Constants.hashMultiplier) ** expoent)
        expoent -= 1
    }

    return Double(total)
}

public func nextHash(prevHash: Double, dropped: Int, added: Int, patternSize: Int) -> Double {
    let oldHash = prevHash - Double(dropped) * (Double(Constants.hashMultiplier) ** patternSize)
    return Double(Constants.hashMultiplier) * oldHash + Double(added)
}

//===----------------------------------------------------------------------===//
//                              Rabin Karp String Search
//===----------------------------------------------------------------------===//
/// Find first position of pattern in the text using Rabin Karp algorithm
public func searchStringByRK(text: String, pattern: String) -> Int {
    // convert to array of ints
    let patternArray = pattern.compactMap {
        $0.asInt
    }

    let textArray = text.compactMap {
        $0.asInt
    }

    if textArray.count < patternArray.count {
        return -1
    }

    let patternHash = hash(array: patternArray)
    var endIdx = patternArray.count - 1
    let firstChars = Array(textArray[0 ... endIdx])
    let firstHash = hash(array: firstChars)

    if patternHash == firstHash {
        // Verify this was not a hash collison
        if firstChars == patternArray {
            return 0
        }
    }

    var prevHash = firstHash
    // Now slide the window across the text to be searched
    for idx in 1 ... (textArray.count - patternArray.count) {
        endIdx = idx + (patternArray.count - 1)
        let window = Array(textArray[idx ... endIdx])
        let windowHash = nextHash(prevHash: prevHash, dropped: textArray[idx - 1], added: textArray[endIdx], patternSize: patternArray.count - 1)
        if windowHash == patternHash {
            if patternArray == window {
                return idx
            }
        }
        prevHash = windowHash
    }

    return -1
}
