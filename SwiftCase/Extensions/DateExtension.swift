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

    var longDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    var shortDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    var shortTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    /// 这周开始日期
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    /// 这周结束日期
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    /// 将date对象格式制定格式的字符串
    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
