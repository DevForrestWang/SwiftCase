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
import UIKit

public typealias SC = SwiftCase

@objcMembers
public class SwiftCase: NSObject {
    public static let w = UIScreen.main.bounds.width

    public static let h = UIScreen.main.bounds.height

    public static let bounds = UIScreen.main.bounds

    /// app 显示名称
    public static var displayName: String {
        // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "SpeedySwift"
    }

    /// app 的bundleid
    public static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? "top.tlien.ss"
    }

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
    public static func toast(message: String) {
        if let view = UIWindow.keyWindow {
            view.toast(message: message)
        }
    }

    public static func printLine() {
        log("===================================================", terminator: "\n\n")
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
}
