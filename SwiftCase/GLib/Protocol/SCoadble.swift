//
//===--- SCoadble.swift - Defines the SCoadble class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/17.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//
import Foundation

public protocol SCoadble: Codable {
    func toDict() -> [String: Any]?
    func toData() -> Data?
    func toString() -> String?
}

public extension SCoadble {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    func toDict() -> [String: Any]? {
        if let data = toData() {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
                return nil
            }
        } else {
            debugPrint("model to data error")
            return nil
        }
    }

    func toString() -> String? {
        if let data = try? JSONEncoder().encode(self), let x = String(data: data, encoding: .utf8) {
            return x
        } else {
            return nil
        }
    }
}
