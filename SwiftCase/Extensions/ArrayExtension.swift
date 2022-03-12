//
//  ArrayExtention.swift
//  GYCompany
//
//  Created by wfd on 2022/3/4.
//  Copyright © 2022 归一. All rights reserved.
//

import UIKit

public extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
