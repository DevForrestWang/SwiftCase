//
//===--- Grade.swift - Defines the Grade class ----------===//
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

struct Grade: SCJsonModel {
    var id: Int?

    var name: String?

    var stus: [Student]?
}
