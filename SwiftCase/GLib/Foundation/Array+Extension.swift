//
//===--- Array+Extension.swift - Defines the Array+Extension class ----------===//
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

public extension Array where Element: Equatable {
    /// 删除指定元素
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }

    // 通过下标获取数组的值，如果越界返回nil
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex ..< endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
