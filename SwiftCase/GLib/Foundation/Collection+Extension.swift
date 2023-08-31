//
//===--- Collection+Extension.swift - Defines the Collection+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/8/31.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

public extension Collection {
    /// 索引列表为参数的下标方法，返回包含这些索引位置上的元素的数组
    subscript(indices indexList: Index...) -> [Element] {
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}
