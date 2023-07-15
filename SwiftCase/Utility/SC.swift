//
//===--- SC.swift - Defines the SC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/14.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SpeedySwift
import Toast_Swift
import UIKit

public typealias SC = SwiftCase

@objcMembers
public class SwiftCase: NSObject {
    public static let w = UIScreen.main.bounds.width

    public static let h = UIScreen.main.bounds.height

    public static let bounds = UIScreen.main.bounds

    // 设备udid
    static let identifierNumber = UIDevice.current.identifierForVendor?.uuidString ?? ""

    // Bundle Identifier
    static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""

    // App版本号
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    // iOS版本
    static let iOSVersion: String = UIDevice.current.systemVersion

    /// build号
    public static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    }

    /// app版本号
    public static var versionS: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// 设备名称
    public static var deviceName: String {
        return UIDevice.current.localizedModel
    }

    /// 当前系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    public static func scaleW(_ width: CGFloat, fit: CGFloat = 375.0) -> CGFloat {
        return w / fit * width
    }

    public static func scaleH(_ height: CGFloat, fit: CGFloat = 812.0) -> CGFloat {
        return h / fit * height
    }

    public static func scale(_ value: CGFloat) -> CGFloat {
        return scaleW(value)
    }

    /// 全场toast
    public static func toast(_ message: String, position: ToastPosition = .center) {
        // UIWindow.keyWindow?.view.toast(message: message)
        gWindow?.makeToast(message, duration: 2.0, position: position)
    }

    public static func printLine() {
        log("===================================================", terminator: "\n\n")
    }

    public static func printEnter(message: String) {
        log("================ \(message)====================")
    }

    /// 打印日志
    static func log(_ items: Any...,
                    separator: String = " ",
                    terminator: String = "\n",
                    file: String = #file,
                    line: Int = #line,
                    method: String = #function)
    {
        #if DEBUG
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss.SSSZ")
            print("\(date) \((file as NSString).lastPathComponent)[\(line)], \(method)", terminator: separator)
            var i = 0
            let j = items.count
            for a in items {
                i += 1
                print(" ", a, terminator: i == j ? terminator : separator)
            }
        #endif
    }

    // MARK: - Device Info

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
}
