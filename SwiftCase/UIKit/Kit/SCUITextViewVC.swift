//
//===--- SCUITextViewVC.swift - Defines the SCUITextViewVC class ----------===//
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

import IQKeyboardManagerSwift
import UIKit

class SCUITextViewVC: BaseViewController, UITextViewDelegate {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 关闭 IQKeyboard事件监听
        IQKeyboardManager.shared.enable = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - UITextViewDelegate

    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        yxc_debugPrint("I'm going to start editing")
        return true
    }

    func textViewDidBeginEditing(_: UITextView) {
        yxc_debugPrint("I've already started editing")
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        yxc_debugPrint("To finish editing")

        return true
    }

    func textViewDidEndEditing(_: UITextView) {
        yxc_debugPrint("I have finished editing")
    }

    func textViewDidChange(_: UITextView) {
        yxc_debugPrint("the user changes the text ")
    }

    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        yxc_debugPrint("text: \(currentText), lenght: \(currentText.count)")

        // 回车时退出编辑
        if text == "\n" {
            // textView.resignFirstResponder()
        }

        return true
    }

    // MARK: - IBActions

    @objc func textViewEditChanged(notification: NSNotification) {
        let textView: UITextView! = notification.object as? UITextView
        if textView != nil {
            let text: String! = textView.text
            let length = text.count
            if length > 100 {
                textView.text = String(text.prefix(100))
                showToast("Reach maximum length")
            }
        }
    }

    @objc func accessoryRightAction() {
        showToast("Confirm")
        view.endEditing(true)
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "UITextView"
        hideKeyboardWhenTapedAround()

        view.addSubview(textView)
        textView.delegate = self

        accessoryView.addSubview(accessoryRightBtn)
        textView.inputAccessoryView = accessoryView

        // 通过通知监听变化
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(notification:)), name: UITextView.textDidChangeNotification, object: textView)
    }

    // MARK: - Constraints

    func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height / 4)
            make.width.equalTo(view).offset(-40)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view).offset(-100)
        }
    }

    // MARK: - Property

    let accessoryView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        $0.backgroundColor = .lightGray
    }

    let accessoryRightBtn = UIButton(type: .custom).then {
        $0.frame = CGRect(x: UIScreen.main.bounds.width - 10 - 60, y: 10, width: 60, height: 20)
        $0.setTitle("Confirm", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(accessoryRightAction), for: .touchUpInside)
    }

    let textView = UITextView().then {
        $0.backgroundColor = .cyan
        $0.tintColor = .blue

        // 字体设置
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)

        $0.isEditable = true
        $0.isUserInteractionEnabled = true
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = true
        $0.showsVerticalScrollIndicator = true

        // 输入设置
        $0.keyboardType = .webSearch
        $0.returnKeyType = .done

        $0.layer.cornerRadius = 5

        // 设置Placeholder
        let phLabel = UILabel()
        phLabel.text = "Placeholder info"
        phLabel.font = UIFont.systemFont(ofSize: 16)
        phLabel.textColor = UIColor.lightGray
        phLabel.numberOfLines = 0
        phLabel.sizeToFit()
        $0.addSubview(phLabel)
        $0.setValue(phLabel, forKey: "_placeholderLabel")
    }
}
