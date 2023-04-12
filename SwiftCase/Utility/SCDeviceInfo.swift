//
//===--- SCDeviceInfo.swift - Defines the SCDeviceInfo class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/3/12.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit
/*
 手机设备型号   屏幕尺寸             分辨率点数 (pt)      屏幕显示模式    分辨率像素(px)    屏幕比例
 iPhone       6/6s/7/8/SE        2 4.7吋 375x667     @2x           750x1334        16:9
 iPhone       6p/7p/8p           5.5吋   414x736     @3x           1242x2208       16:9

 iPhone       XR/11              6.1吋   414x896     @2x           828x1792        19.5:9
 iPhone       X/XS/11 Pro        5.8吋   375x812     @3x           1125x2436       19.5:9
 iPhone       XS Max/11 Pro Max  6.5吋   414x896     @3x           1242x2688       19.5:9

 iPhone       12 mini            5.4吋   360x780     @3x           1080x2340       19.5:9
 iPhone       12/12 Pro          6.1吋   390x844     @3x           1170x2532       19.5:9
 iPhone       12 Pro Max         6.7吋   428x926     @3x           1284x2778       19.5:9

 iPhone       13 mini            5.4吋   360x780     @3x            1080x2340      19.5:9
 iPhone       13/13 Pro          6.1吋   390x844     @3x            1170x2532      19.5:9
 iPhone       13 Pro Max         6.7吋   428x926     @3x            1284x2778      19.5:9
 */

public var gWindow: UIWindow? {
    return UIWindow.keyWindow
}

public var isSupportSafeArea: Bool {
    if #available(iOS 11, *) {
        return true
    }
    return false
}

// 状态栏高度
public let gStatusBarHeight: CGFloat = isSupportSafeArea ? (gWindow?.safeAreaInsets.top ?? 20) : 20

// 底部安全区高度
public let gBottomSafeHeight: CGFloat = isSupportSafeArea ? (gWindow?.safeAreaInsets.bottom ?? 0) : 0

// 导航栏高度
public let gNaviHeight: CGFloat = 44

// TableBar高度
public let gTableBarHeight: CGFloat = 49

// 顶部高度
public let gTopBarHeight: CGFloat = gStatusBarHeight + gNaviHeight

// 底部高度
public let gBottomBarHeight: CGFloat = gBottomSafeHeight + gTableBarHeight

// 屏幕高度
public let gScreenHeight = UIScreen.main.bounds.height

// 屏幕宽度
public let gScreenWidth = UIScreen.main.bounds.width

// bundle id
public let gIdentifier = Bundle.main.bundleIdentifier

// 等比适配
public let gEqualScale = gScreenWidth / 375

/// 获取系统信息
public class SCDeviceInfo: NSObject {
    // MARK: - Public

    /// APP汇总信息
    static func deviceInfo() -> [String: String] {
        return [
            "OSVersion": appVersion,
            "OSName": osName(),
            "OSIdentifier": identifierNumber,
            "APPName": getAppName(),
            "AppVersion": appVersion,
        ]
    }

    /// 获取APP名称
    static func getAppName() -> String {
        if let name = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            return name
        }

        if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return name
        }

        if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return "App"
    }

    /// 设备具体详细的型号
    static func osName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceId = machineMirror.children.reduce("") { deviceId, element in
            guard let value = element.value as? Int8, value != 0 else {
                return deviceId
            }
            return deviceId + String(UnicodeScalar(UInt8(value)))
        }

        let deviceName = deviceToName(identifier: deviceId)
        if deviceName.count > 0 {
            return deviceName
        }

        if deviceId.hasPrefix("iPhone") {
            return "iPhone"
        } else if deviceId.hasPrefix("iPad") {
            return "iPad"
        } else if deviceId.hasPrefix("iPod") {
            return "iPod Touch"
        } else if deviceId.hasPrefix("AppleTV") {
            return "Apple TV"
        }

        return "Unknown"
    }

    // MARK: - Private

    /// 获取设备标识与名称对应关系，当前值支持手机系统
    /// 设备更新信息参考：
    /// https://blog.csdn.net/qq_19926599/article/details/86747401
    /// https://www.theiphonewiki.com/wiki/Models
    private static func deviceToName(identifier: String) -> String {
        switch identifier {
        // iPhone
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"

        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"

        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"

        case "iPhone10,3", "iPhone10,6": return "iPhone X"

        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"

        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE"

        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12  Pro"
        case "iPhone13,4": return "iPhone 12  Pro Max"

        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13  Pro"
        case "iPhone14,3": return "iPhone 13  Pro Max"
        case "iPhone14,6": return "iPhone SE"

        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"

        // 模拟器
        case "i386", "x86_64": return "iPhone Simulator"
        default: return ""
        }
    }

    // MARK: - Property

    // 设备udid
    static let identifierNumber = UIDevice.current.identifierForVendor?.uuidString ?? ""

    // Bundle Identifier
    static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""

    // App版本号
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    // iOS版本
    static let iOSVersion: String = UIDevice.current.systemVersion
}
