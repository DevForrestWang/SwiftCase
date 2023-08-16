//
//===--- GlobalConfig.swift - Defines the GlobalConfig class ----------===//
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

public enum GlobalConfig {
    // MARK: - Config Info

    public static let gBaseUrl = "192.168.1.177"
    // public static let gBaseUrl = "192.168.1.105"

    public static let gRpcUrl = gBaseUrl
    public static let gRestUrl = "http://\(gBaseUrl):9098/grpc"
    public static let gCharHost = "http://\(gBaseUrl):9100"

    // 高德地图key
    public static let gGaoDeMapKey = "d47f60402dd010cb57f6bad3b2b735d1"

    // MARK: -  UI
}
