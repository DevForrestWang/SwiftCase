//
//===--- String+Extension.swift - Defines the String+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/20.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

extension String {
    /// String to float
    func toFloat() -> Float? {
        let number = NumberFormatter()
        return number.number(from: self)?.floatValue
    }

    func toDouble() -> Double? {
        let number = NumberFormatter()
        return number.number(from: self)?.doubleValue
    }
}
