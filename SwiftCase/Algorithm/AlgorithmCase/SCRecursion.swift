//
//===--- SCRecursion.swift.swift - Defines the SCRecursion.swift class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/10/8.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

/// 递归求解爬楼梯问题
/// 接受任何数字，Int，Float，Double
///
class SCRecursion<T: Numeric> {
    /// 最开始版本的递归算法，调用次数过多导致崩溃
    public func add(_ num: T) -> T {
        if num == 1 {
            return 1
        }

        if num == 2 {
            return 2
        }
        return add(num - 1) + add(num - 2)
    }

    /// 通过map来存储已经计算过的值，避免递归重复计算；depth 控制递归的深度
    public func addGuard(_ num: Int) -> Double {
        depth += 1
        if depth > 1000 {
            fatalError("function stack is too deep!")
        }

        if num == 1 {
            yxc_debugPrint("depth: \(depth)")
            return 1
        }
        if num == 2 {
            return 2
        }

        if let iValue = valueMap[num] {
            return iValue
        }

        let ret = addGuard(num - 1) + addGuard(num - 2)
        valueMap[num] = Double(ret)

        return ret
    }

    var depth: Int = 1
    var valueMap = [Int: Double]()
}
