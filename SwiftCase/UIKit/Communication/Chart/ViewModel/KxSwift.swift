//
//===--- KxSwift.swift - Defines the KxSwift class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// Inspirations are taken from:
// https://medium.com/mindful-engineering/sockets-mvvm-in-swift-8f32b1401aa5
//
//===----------------------------------------------------------------------===//

import Foundation

class KxSwift<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?

    var value: T {
        didSet {
            observer?(value)
        }
    }

    init(_ v: T) {
        value = v
    }

    func bind(_ listner: Observer?) {
        observer = listner
    }

    func subscribe(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
