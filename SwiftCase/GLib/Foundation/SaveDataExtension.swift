//
//===--- SaveDataExtension.swift - Defines the SaveDataExtension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by Forrest on 2022/8/29.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// 数据本地保
//===----------------------------------------------------------------------===//

import Foundation

public extension Int {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.integer(forKey: key))
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Bool {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.bool(forKey: key))
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Float {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.float(forKey: key))
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Double {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.double(forKey: key))
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Data {
    init?(key: String) {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        self.init(data)
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension String {
    init?(key: String) {
        guard let str = UserDefaults.standard.string(forKey: key) else { return nil }
        self.init(str)
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Array where Element == Any {
    init?(key: String) {
        guard let array = UserDefaults.standard.array(forKey: key) else { return nil }
        self.init()
        append(contentsOf: array)
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public extension Dictionary where Key == String, Value == Any {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }

    init?(key: String) {
        guard let dict = UserDefaults.standard.dictionary(forKey: key) else { return nil }
        self.init()
        merge(dict: dict)
    }

    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
