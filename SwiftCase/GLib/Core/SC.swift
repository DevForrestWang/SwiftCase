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

/// 常用系统信息相关方法
@objcMembers
public class SwiftCase: NSObject {
    // 屏幕宽度
    public static let w = UIScreen.main.bounds.width

    // 屏幕高度
    public static let h = UIScreen.main.bounds.height

    public static var window: UIWindow? {
        return UIWindow.keyWindow
    }

    public static let bounds = UIScreen.main.bounds

    // 等比适配
    public static let equalScale = w / 375

    // 状态栏高度
    public static let statusBarHeight: CGFloat = isSupportSafeArea ? (window?.safeAreaInsets.top ?? 20) : 20

    // 底部安全区高度
    public static let bottomSafeHeight: CGFloat = isSupportSafeArea ? (window?.safeAreaInsets.bottom ?? 0) : 0

    // 导航栏高度
    public static let naviHeight: CGFloat = 44

    // TableBar高度
    public static let tableBarHeight: CGFloat = 49

    // 顶部高度
    public static let topBarHeight: CGFloat = statusBarHeight + naviHeight

    // 底部高度
    public static let bottomBarHeight: CGFloat = bottomSafeHeight + tableBarHeight

    // 设备udid
    static let identifierNumber = UIDevice.current.identifierForVendor?.uuidString ?? ""

    // Bundle Identifier
    static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""

    // App版本号
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    // iOS版本
    static let iOSVersion: String = UIDevice.current.systemVersion

    // MARK: - Device Info

    /// build号
    public static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    }

    /// app版本号
    public static var versionS: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    // bundle id
    public static let identifier = Bundle.main.bundleIdentifier

    /// 设备名称
    public static var deviceName: String {
        return UIDevice.current.localizedModel
    }

    /// 当前系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// APP汇总信息
    public static func deviceInfo() -> [String: String] {
        return [
            "OSVersion": appVersion,
            "OSName": osName(),
            "OSIdentifier": identifierNumber,
            "APPName": getAppName(),
            "AppVersion": appVersion,
        ]
    }

    /// 获取APP名称
    public static func getAppName() -> String {
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
    public static func osName() -> String {
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

    // MARK: - UI

    public static var isSupportSafeArea: Bool {
        if #available(iOS 11, *) {
            return true
        }
        return false
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

    /// 根据控制器获取 顶层控制器
    public static func topVC(_ viewController: UIViewController?) -> UIViewController? {
        guard let currentVC = viewController else {
            return nil
        }

        if let nav = currentVC as? UINavigationController {
            // 控制器是nav
            return topVC(nav.visibleViewController)
        } else if let tabC = currentVC as? UITabBarController {
            // tabBar 的跟控制器
            return topVC(tabC.selectedViewController)
        } else if let presentVC = currentVC.presentedViewController {
            // modal出来的 控制器
            return topVC(presentVC)
        } else {
            // 返回顶控制器
            return currentVC
        }
    }

    /// 获取顶层控制器 根据window
    public static func topVC() -> UIViewController? {
        var window = window
        // 是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for windowTemp in windows {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return topVC(vc)
    }

    /// 当用户截屏时的监听
    public static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
        // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
        _ = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main)
        { notification in
            action(notification)
        }
    }

    // MARK: - General Info

    /// 全场toast
    public static func toast(_ message: String, position: ToastPosition = .center) {
        // UIWindow.keyWindow?.view.toast(message: message)
        window?.makeToast(message, duration: 2.0, position: position)
    }

    public static func printLine() {
        log("===================================================", terminator: "\n\n")
    }

    public static func printEnter(message: String) {
        log("================ \(message)====================")
    }

    /// 打印日志
    public static func log(_ items: Any...,
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
