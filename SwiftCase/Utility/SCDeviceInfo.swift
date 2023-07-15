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

