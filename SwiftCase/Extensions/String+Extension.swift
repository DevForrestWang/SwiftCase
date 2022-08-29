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
    /// String to int
    func toInt() -> Int? {
        let number = NumberFormatter()
        return number.number(from: self)?.intValue
    }

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

    /// 将字符串转换为Date
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /// A Boolean value indicating whether a String is blank.
    /// The string is blank if it is empty or only contains whitespace.
    var isBlank: Bool {
        return allSatisfy { $0.isWhitespace }
    }

    /// 检测中文
    func validateChinese() -> Bool {
        let pattern = "[\\u4e00-\\u9fa5]"
        return isMatchRegularExp(pattern)
    }

    /// 是否匹配正则
    func isMatchRegularExp(_ pattern: String) -> Bool {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) else {
            return false
        }
        let result = reg.matches(in: self, options: .reportProgress, range: NSMakeRange(0, count))
        return (result.count > 0)
    }

    /// 计算字符串在组件中的尺寸
    func getBoundingRect(font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping

        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]

        let attContent = NSMutableAttributedString(string: self, attributes: att)

        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size

        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    /// 去除字符串前后的换行和空格
    func trim() -> String {
        var resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 以utf8 解编码
    func utf8DecodedString() -> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }

    /// 以utf8 编码
    func utf8EncodedString() -> String {
        let messageData = data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }

    /// 字符串是否有 Emoji
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600 ... 0x1F64F, // Emoticons
                 0x1F300 ... 0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680 ... 0x1F6FF, // Transport and Map
                 0x2600 ... 0x26FF, // Misc symbols
                 0x2700 ... 0x27BF, // Dingbats
                 0xFE00 ... 0xFE0F, // Variation Selectors
                 0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }

    /// 判断是不是Emoji
    /// - Returns: true false
    func hasEmoji() -> Bool {
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
}

extension Optional where Wrapped == String {
    /// A Boolean value indicating whether an Optional String is blank.
    /// The optional string is blank if it is nil, empty or only contains whitespace.
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}

/// 查找字符串位置，返回Int类型
public extension StringProtocol {
    func distance(of element: Element) -> Int? {
        firstIndex(of: element)?.distance(in: self)
    }

    func distance<S: StringProtocol>(of string: S) -> Int? {
        range(of: string)?.lowerBound.distance(in: self)
    }
}

public extension Collection {
    func distance(to index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
}

public extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int {
        string.distance(to: self)
    }
}
