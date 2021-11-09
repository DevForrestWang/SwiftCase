//
//===--- CurrencyFactory.swift - Defines the CurrencyFactory class ----------===//
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

import Foundation

// 接口
protocol CurrencyDescribing {
    var symbol: String { get }
    var code: String { get }
}

// 定义不同实现类
final class Euro: CurrencyDescribing {
    var symbol: String {
        return "€"
    }

    var code: String {
        return "EUR"
    }
}

final class UnitedStatesDolar: CurrencyDescribing {
    var symbol: String {
        return "$"
    }

    var code: String {
        return "USD"
    }
}

// 工厂类
enum Country {
    case unitedStates
    case spain
    case uk
    case greece
}

enum CurrencyFactory {
    static func currency(for country: Country) -> CurrencyDescribing? {
        switch country {
        case .spain, .greece:
            return Euro()
        case .unitedStates:
            return UnitedStatesDolar()
        default:
            return nil
        }
    }
}
