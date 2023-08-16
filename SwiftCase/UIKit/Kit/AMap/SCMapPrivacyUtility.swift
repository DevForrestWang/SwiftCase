//
//===--- SCMapPrivacyUtility.swift - Defines the SCMapPrivacyUtility class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/8/16.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import UIKit

class SCMapPrivacyUtility: NSObject {
    /**
     * @brief 通过这个方法来判断是否同意隐私合规
     * 1.如果没有同意隐私合规，则创建的SDK manager 实例返回 为nil， 无法使用SDK提供的功能
     * 2.如果同意了下次启动不提示 的授权，则不会弹框给用户
     * 3.如果只同意了，则下次启动还要给用户弹框提示
     */
    static func handlePrivacyAgreeStatus() {
        // 判断是否需要同步了下次不提示
        if !UserDefaults.standard.bool(forKey: "agreeStatus") {
            // 添加隐私合规弹窗
            showPrivacyInfoInWindow()
        }
    }

    /// 展示隐私合规弹框
    static func showPrivacyInfoInWindow() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left

        let privacyInfo = NSMutableAttributedString(string: "\n亲，感谢您对SwiftCase一直以来的信任！我们依据最新的监管要求更新了SwiftCase《隐私权政策》，特向您说明如下\n1.为向您提供交易相关基本功能，我们会收集、使用必要的信息；\n2.基于您的明示授权，我们可能会获取您的位置（为您提供附近的商品、店铺及优惠资讯等）等信息，您有权拒绝或取消授权；\n3.我们会采取业界先进的安全措施保护您的信息安全；\n4.未经您同意，我们不会从第三方处获取、共享或向提供您的信息；", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        privacyInfo.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: privacyInfo.mutableString.range(of: "《隐私权政策》"))

        let alert = UIAlertController(title: "温馨提示(隐私合规示例)", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.setValue(privacyInfo, forKey: "attributedMessage")

        let agreeAllAction = UIAlertAction(title: "同意(下次不提示)", style: UIAlertAction.Style.default) { _ in
            UserDefaults.standard.set(true, forKey: "agreeStatus")
            UserDefaults.standard.synchronize()
            // 更新用户授权高德SDK隐私协议状态. since 8.1.0
            AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        }

        let agreeAction = UIAlertAction(title: "同意", style: UIAlertAction.Style.default) { _ in
            // 更新用户授权高德SDK隐私协议状态. since 8.1.0
            AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        }

        let notAgreeAction = UIAlertAction(title: "不同意", style: UIAlertAction.Style.default) { _ in
            UserDefaults.standard.set(false, forKey: "agreeStatus")
            UserDefaults.standard.synchronize()
            // 更新用户授权高德SDK隐私协议状态. since 8.1.0
            AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.notAgree)
        }

        alert.addAction(agreeAllAction)
        alert.addAction(agreeAction)
        alert.addAction(notAgreeAction)

        SC.window?.rootViewController?.present(alert, animated: true, completion: {
            // 更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
            AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        })
    }
}
