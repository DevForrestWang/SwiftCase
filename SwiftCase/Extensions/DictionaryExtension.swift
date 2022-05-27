//
//  DictionaryExtension.swift
//  GYCompany
//
//  Created by wfd on 2022/3/25.
//  Copyright © 2022 归一. All rights reserved.
//

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
}
