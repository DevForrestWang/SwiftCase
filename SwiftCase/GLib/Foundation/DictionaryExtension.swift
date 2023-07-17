//
//===--- DictionaryExtension.swift - Defines the DictionaryExtension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

public extension Dictionary {
    /// 将一个字典添加到另一个字典里
    mutating func update(other: Dictionary) {
        for (key, value) in other {
            updateValue(value, forKey: key)
        }
    }

    // 检查字典是否包含key
    func contains(key: Key) -> Bool {
        self[key] != nil
    }

    /// 字典转字符串
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }

        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }

    /// 打印
    func jsonPrint() {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else { return }
        guard let str = String(data: data, encoding: .utf8) else { return }
        print(str)
    }
}
