//
//===--- Object+Extension.swift - Defines the Object+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/18.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//
import Foundation

public extension NSObject {
    class var named: String {
        let array = NSStringFromClass(self).components(separatedBy: ".")
        return array.last ?? ""
    }

    var named: String {
        let array = NSStringFromClass(type(of: self)).components(separatedBy: ".")
        return array.last ?? ""
    }
}
