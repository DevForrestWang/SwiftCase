//
//===--- Application+Extension.swift - Defines the Application+Extension class ----------===//
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
import UIKit

extension UIApplication {
    static func jsonString(from object: Any) -> String? {
        guard let data = jsonData(from: object) else {
            return nil
        }

        return String(data: data, encoding: String.Encoding.utf8)
    }

    static func jsonData(from object: Any) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }

        return data
    }
}
