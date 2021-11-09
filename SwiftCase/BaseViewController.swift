//
//===--- BaseViewController.swift - Defines the BaseViewController class ----------===//
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

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.hexColor(0xF2F4F7)

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.27, green: 0.71, blue: 0.94, alpha: 1)
            let titleColor = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18) as Any, NSAttributedString.Key.foregroundColor: UIColor.hexColor(0x333333)]
            appearance.titleTextAttributes = titleColor
            appearance.largeTitleTextAttributes = titleColor
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.27, green: 0.71, blue: 0.94, alpha: 1)
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.hexColor(0x333333)]
        }

        if responds(to: Selector(("edgesForExtendedLayout"))) {
            edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        }

        // 隐藏返回按钮的文字，要通过重新leftItem方式，如果通过 navigationController!.navigationBar.topItem!.title = "" 返回时前一个页面title没有
        if (navigationController?.children.count)! > 1 {
            let backButtonItem = UIBarButtonItem(image: R.image.nav_btn_backs(), style: .plain, target: self, action: #selector(backButtonClicked))
            backButtonItem.tintColor = .white
            navigationItem.leftBarButtonItems = [backButtonItem]
        }
    }

    /// 隐藏键盘
    func hideKeyboardWhenTapedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func backButtonClicked() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
