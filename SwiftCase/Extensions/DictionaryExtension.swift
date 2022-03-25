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
     mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
