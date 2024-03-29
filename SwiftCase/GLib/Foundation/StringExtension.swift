//
//===--- StringExtension.swift - Defines the StringExtension class ----------===//
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

import CommonCrypto
import CoreGraphics
import CryptoSwift
import Foundation
import UIKit

// MARK: - Base

public extension String {
    /// 初始化 base64
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }

    static var identifier: String {
        let uuidMd5 = UUID().uuidString.md5
        return uuidMd5
    }

    /// 复制到剪贴板
    func copy() {
        UIPasteboard.general.string = self
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

    /// 给字体添加描边效果 : strokeWidth为正数为空心文字描边 strokeWidth为负数为实心文字描边
    func drawOutline(
        fontSize: CGFloat,
        fontWeight: UIFont.Weight = .bold,
        textColor: UIColor,
        strokeWidth: CGFloat,
        widthColor: UIColor
    ) -> NSAttributedString {
        let dic: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.strokeWidth: strokeWidth,
            NSAttributedString.Key.strokeColor: widthColor,
        ]
        var attributedText: NSMutableAttributedString!
        attributedText = NSMutableAttributedString(string: self, attributes: dic)
        return attributedText
    }
}

// MARK: - 获取字符串位置

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

// MARK: - 字符串检查

public extension String {
    /// 判断是否是数字，包括小数点
    func isPureFloat() -> Bool {
        let scan = Scanner(string: self)
        return (scan.scanFloat(representation: .decimal) != nil) && scan.isAtEnd
    }

    /// 判断是否是数字
    func isPureInt() -> Bool {
        let scan = Scanner(string: self)
        var val = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }

    // 判断是不是九宫格键盘
    /// 判断是不是九宫格键盘
    func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 仅包含数字
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }

    /// 仅包含字母
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }

    /// 仅包含字母数字
    var isAlphanumeric: Bool {
        let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: String.CompareOptions.literal, range: nil) == nil
    }

    /// 字符串是否为空串
    var isBlank: Bool {
        // 通过裁剪字符串中的空格和换行符检查
        // returnreturn trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        // 通过高阶函数allSatisfy检查
        return allSatisfy { $0.isWhitespace }
    }

    /// 是否是有效的电子邮件格式
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 检测中文
    func validateChinese() -> Bool {
        let pattern = "[\\u4e00-\\u9fa5]"
        return matches(pattern)
    }

    /// 是否匹配正则
    func matches(_ pattern: String) -> Bool {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) else {
            return false
        }
        let result = reg.matches(in: self, options: .reportProgress, range: NSMakeRange(0, count))
        return result.count > 0
    }

    /// 是否包含emoji
    var isContainEmoji: Bool {
        for scalar in unicodeScalars {
            return containEmoji(scalar)
        }
        return false
    }

    /// 是否包含表情
    /// - Parameter scalar: unicode 字符
    /// - Returns: 是表情返回true
    func containEmoji(_ scalar: Unicode.Scalar) -> Bool {
        switch Int(scalar.value) {
        case 0x1F600 ... 0x1F64F: return true // Emoticons
        case 0x1F300 ... 0x1F5FF: return true // Misc Symbols and Pictographs
        case 0x1F680 ... 0x1F6FF: return true // Transport and Map
        case 0x1F1E6 ... 0x1F1FF: return true // Regional country flags
        case 0x2600 ... 0x26FF: return true // Misc symbols
        case 0x2700 ... 0x27BF: return true // Dingbats
        case 0xE0020 ... 0xE007F: return true // Tags
        case 0xFE00 ... 0xFE0F: return true // Variation Selectors
        case 0x1F900 ... 0x1F9FF: return true // Supplemental Symbols and Pictographs
        case 127_000 ... 127_600: return true // Various asian characters
        case 65024 ... 65039: return true // Variation selector
        case 9100 ... 9300: return true // Misc items
        case 8400 ... 8447: return true //
        default: return false
        }
    }

    /// 字符串是否有 Emoji
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            return containEmoji(scalar)
        }
        return false
    }

    /// 移除表情
    func removeEmoji() -> String {
        var scalars = unicodeScalars
        scalars.removeAll(where: containEmoji(_:))
        return String(scalars)
    }
}

// MARK: - 整数下标

public extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start ..< end]
    }

    subscript(bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start ... end]
    }

    subscript(bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start ... end]
    }

    subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex ... end]
    }

    subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex ..< end]
    }
}

// MARK: - 字符截取

public extension String {
    var length: Int {
        return count
    }

    /// 计算字符个数（英文 = 1，数字 = 1，汉语 = 2）
    /// - Returns: 返回字符的个数
    func countOfChars() -> Int {
        var count = 0
        guard self.count > 0 else { return 0 }

        for i in 0 ... self.count - 1 {
            let c: unichar = (self as NSString).character(at: i)
            if c >= 0x4E00 {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }

    /// right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards),
            leftRange.upperBound <= rightRange.lowerBound
        else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

    func substring(to: Int) -> String {
        let toIndex = index(startIndex, offsetBy: to)
        return String(self[...toIndex])
    }

    /// 根据字符个数返回从指定位置向后截取的字符串（英文 = 1，数字 = 1，汉语 = 2）
    func substring(from index: Int) -> String {
        if count == 0 {
            return ""
        }

        var number = 0
        var strings: [String] = []
        for c in self {
            let subStr = "\(c)"
            let num = subStr.countOfChars()
            number += num
            if number <= index {
                strings.append(subStr)
            } else {
                break
            }
        }
        var resultStr = ""
        for str in strings {
            resultStr = resultStr + "\(str)"
        }
        return resultStr

        // let fromIndex = index(startIndex, offsetBy: from)
        // return String(self[fromIndex...])
        // 或
        // let theIndex = self.index(endIndex, offsetBy: index - count)
        // return String(self[theIndex ..< endIndex])
    }

    func substring(_ r: Range<Int>) -> String {
        let fromIndex = index(startIndex, offsetBy: r.lowerBound)
        let toIndex = index(startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }

    func character(_ at: Int) -> Character {
        return self[index(startIndex, offsetBy: at)]
    }

    func lastIndexOfCharacter(_ c: Character) -> Int? {
        guard let index = range(of: String(c), options: .backwards)?.lowerBound
        else { return nil }
        return distance(from: startIndex, to: index)
    }

    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }

    func inserting(separator: String, every n: Int) -> String {
        var result = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0 ..< min($0 + n, count)])
            if $0 + n < count {
                result += separator
            }
        }
        return result
    }
}

// MARK: - 解析 JSON 数据

public extension String {
    init?(json: Any) {
        guard let data = Data(json: json) else { return nil }
        self.init(decoding: data, as: UTF8.self)
    }

    func jsonToDictionary() -> [String: Any]? {
        data(using: .utf8)?.jsonToDictionary()
    }

    func jsonToArray() -> [Any]? {
        data(using: .utf8)?.jsonToArray()
    }

    /// 初始化 base64
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        return data(using: .utf8)?.toModel(type)
    }
}

// MARK: - 数据转换

public extension String {
    ///  本地化字符串
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

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

    /// 将字符串转换为Date
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
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

    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    /// 转utf8Encoded Data类型
    func utf8Encoded() -> Data? {
        return data(using: String.Encoding.utf8)
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

    /// 转本地URL
    var pathToURL: URL? {
        return URL(fileURLWithPath: self, isDirectory: true)
    }

    /// 转网络URL
    var netUrl: URL? {
        return URL(string: self)
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

    /// base64 解码
    var base64Decoded: String? {
        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: self + padding,
                              options: .ignoreUnknownCharacters) else { return nil }

        return String(data: data, encoding: .utf8)
    }

    /// base64 编码
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }

    /// md5
    var md5: String {
        return self.md5()
    }

    /// 去掉小数点后多余的0
    /// - Returns: 返回小数点后没有 0 的金额
    func cutLastZeroAfterDot() -> String {
        var rst = self
        var i = 1
        if contains(".") {
            while i < count {
                if rst.hasSuffix("0") {
                    rst.removeLast()
                    i = i + 1
                } else {
                    break
                }
            }
            if rst.hasSuffix(".") {
                rst.removeLast()
            }
            return rst
        } else {
            return self
        }
    }

    /// 将数字的字符串处理成  几位 位小数的情况
    /// - Parameters:
    ///   - numberDecimal: 保留几位小数
    ///   - mode: 模式, 默认四舍五入
    /// - Returns: 返回保留后的小数，如果是非字符，则根据numberDecimal 返回0 或 0.00等等
    /// - 模式参考资料：https://juejin.cn/post/6844903760183951367
    func saveNumberDecimal(numberDecimal: Int = 2, mode: NumberFormatter.RoundingMode = .halfUp) -> String {
        var n = NSDecimalNumber(string: self)
        if n.doubleValue.isNaN {
            n = NSDecimalNumber.zero
        }

        let formatter = NumberFormatter()
        formatter.roundingMode = mode

        // 小数位最多位数
        formatter.maximumFractionDigits = numberDecimal
        // 小数位最少位数
        formatter.minimumFractionDigits = numberDecimal
        // 整数位最少位数
        formatter.minimumIntegerDigits = 1
        // 整数位最多位数
        formatter.maximumIntegerDigits = 100
        // 获取结果
        guard let result = formatter.string(from: n) else {
            // 异常处理
            if numberDecimal == 0 {
                return "0"
            } else {
                var zero = ""
                for _ in 0 ..< numberDecimal {
                    zero += zero
                }
                return "0." + zero
            }
        }
        return result
    }

    /// 将数据格式为指定位数，末尾为0的清理掉
    func formatNumberCutZero(numberDecimal: Int = 2, mode: NumberFormatter.RoundingMode = .halfUp) -> String {
        let result = saveNumberDecimal(numberDecimal: numberDecimal, mode: mode)
        return result.cutLastZeroAfterDot()
    }

    /// 获取文件扩展名
    var fileExtension: String? {
        guard let period = lastIndex(of: ".") else {
            return nil
        }
        // 获取.后面的位置
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }

    /// 获取文件扩展名
    var fileName: String? {
        // 获取文件名
        let lastFile = (self as NSString).lastPathComponent
        guard let period = lastFile.lastIndex(of: ".") else {
            return nil
        }

        // 获取.前的位置
        let pointStart = lastFile.index(before: period)
        return String(lastFile[...pointStart])
    }
}
