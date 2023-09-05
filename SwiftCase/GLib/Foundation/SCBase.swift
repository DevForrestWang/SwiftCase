//
//===--- SCBase.swift - Defines the SCBase class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/8/29.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation

// MARK: - 定义操作符: ???

/// 定义操作符: ???
infix operator ???: NilCoalescingPrecedence

/// 将值转成字符串，nil时使用缺省值
public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}

// MARK: - 定义操作符: !?，强制解包，提供缺省值

infix operator !?

/// 强制解包，debug模式抛出异常信息；release模式使用缺省值
func !? <T>(wrapped: T?, nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

/// 解包失败使用缺省值
func !? <T>(wrapped: T?, defaultValue: @autoclosure () -> T) -> T {
    if wrapped == nil {
        return defaultValue()
    }

    return wrapped ?? defaultValue()
}

// MARK: - 属性包装器

/// 字符串首字母大写
@propertyWrapper struct SCapitalized {
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}

/// 属性加锁使用
@propertyWrapper
class SCAtomic<T> {
    private var value: T
    private let lock = NSRecursiveLock()

    public init(wrappedValue value: T) {
        self.value = value
    }

    public var wrappedValue: T {
        get { getValue() }
        set { setValue(newValue: newValue) }
    }

    // 加锁处理获取数据
    func getValue() -> T {
        lock.lock()
        defer { lock.unlock() }

        return value
    }

    // 设置数据加锁
    func setValue(newValue: T) {
        lock.lock()
        defer { lock.unlock() }

        value = newValue
    }
}

/// 保存属性
@propertyWrapper
struct SCUserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }

        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
