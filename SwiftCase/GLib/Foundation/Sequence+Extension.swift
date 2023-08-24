//
//===--- Sequence+Extension.swift - Defines the Sequence+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/8/24.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

public extension Sequence where Element: Hashable {
    /// 保证序列中所有的元素唯一且顺序保存不变
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        }
    }
}
