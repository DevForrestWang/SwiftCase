//
//===--- SCBase.swift - Defines the SCBase class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/8/29.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

// MARK: - 定义操作符: ???

/// 定义操作符: ???
infix operator ???: NilCoalescingPrecedence

/// 将值转成字符串，nil时使用缺省值
public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}
