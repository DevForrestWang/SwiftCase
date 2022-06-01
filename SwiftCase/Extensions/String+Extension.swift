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

public extension String {
    /// String to float
    func toFloat() -> Float? {
        let number = NumberFormatter()
        return number.number(from: self)?.floatValue
    }

    /// String to double
    func toDouble() -> Double? {
        let number = NumberFormatter()
        return number.number(from: self)?.doubleValue
    }

    /// URL 编码
    func urlEncoded() -> String {
        let encodeUrlString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    /// URL 解码
    func urlDecoded() -> String {
        return removingPercentEncoding ?? ""
    }

    /// 判断是否是数字，包括小数点
    func isPureFloat() -> Bool {
        let scan = Scanner(string: self)
        var val: Float = 0
        return scan.scanFloat(&val) && scan.isAtEnd
    }

    /// 判断是否是数字
    func isPureInt() -> Bool {
        let scan = Scanner(string: self)
        var val = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }

    /// 把汉字转为拼音
    func transformToPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        // 把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        var string = String(mutableString)
        // 首字母大写
        string = string.capitalized
        // 去掉空格
        return string.replacingOccurrences(of: " ", with: "")
    }

    /// 字符串转字典
    func toDictionary() -> [String: Any] {
        var result = [String: Any]()

        guard !isEmpty else {
            return result
        }

        guard let dataSelf = data(using: .utf8) else {
            return result
        }

        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String: Any] {
            result = dic
        }
        return result
    }
}
