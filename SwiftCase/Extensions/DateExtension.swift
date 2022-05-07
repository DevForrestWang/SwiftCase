//
//===--- DateExtension.swift - Defines the DateExtension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/5/7.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

public extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
}
