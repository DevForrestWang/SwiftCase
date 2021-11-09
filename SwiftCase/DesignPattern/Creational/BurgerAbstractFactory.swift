//
//===--- BurgerAbstractFactory.swift - Defines the BurgerAbstractFactory class ----------===//
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

protocol BurgerDescribing {
    var ingredients: [String] { get }
}

struct CheeseBuger: BurgerDescribing {
    let ingredients: [String]
}

protocol BurgerMaking {
    func make() -> BurgerDescribing
}

// 工厂方式实现
final class BigKahunaBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBuger(ingredients: ["Cheese", "Burger", "Lettuce", "Tomato"])
    }
}

final class JackInTheBox: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBuger(ingredients: ["Cheese", "Burger", "Tomato", "Oniouns"])
    }
}

enum BurgerFactoryType: BurgerMaking {
    func make() -> BurgerDescribing {
        switch self {
        case .bigKahuna:
            return BigKahunaBurger().make()
        case .jackInTheBox:
            return JackInTheBox().make()
        }
    }

    case bigKahuna
    case jackInTheBox
}
