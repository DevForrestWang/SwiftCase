//
//===--- Float+Extension.swift - Defines the Float+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/5/30.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

public extension Double {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
