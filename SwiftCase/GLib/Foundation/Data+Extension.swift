//
//===--- DataExtension.swift - Defines the DataExtension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by Forrest on 2022/8/29.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

/// Data 转json
public extension Data {
    init?(json: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) else {
            return nil
        }
        self.init(data)
    }

    /// NSString gives us a nice sanitized debugDescription
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }

    func jsonToDictionary() -> [String: Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [String: Any]
    }

    func jsonToArray() -> [Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [Any]
    }

    // 转 string
    func toString(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }

    func toBytes() -> [UInt8] {
        return [UInt8](self)
    }

    func toDict() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            SC.log(error.localizedDescription)
            return nil
        }
    }

    /// 从给定的JSON数据返回一个基础对象。
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }

    /// 指定Model类型
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            SC.log("data to model error")
            return nil
        }
    }
}
