//
//===--- SCUITextFieldVC.swift - Defines the SCUITextFieldVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See [Swift—UITextField的基本用法](https://www.jianshu.com/p/63bdeca39ddf) information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCUITextFieldVC: BaseViewController, UITextFieldDelegate {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            SC.log("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    // MARK: - Protocol

    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        SC.log("I'm going to start editing")
        return true
    }

    func textFieldDidBeginEditing(_: UITextField) {
        SC.log("I've already started editing")
    }

    func textFieldShouldEndEditing(_: UITextField) -> Bool {
        SC.log("To finish editing")
        return true
    }

    func textFieldDidEndEditing(_: UITextField) {
        SC.log("I have finished editing")
    }

    // UITextField.textDidChangeNotification通知可以实时获取输入的内容；shouldChangeCharactersIn只能获取上一次输入的内容
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString text: String) -> Bool {
        SC.log("The text input will change (called each time it is typed:\(String(describing: textField.text))")

        // 禁止表情输入
        if text.containsEmoji() {
            return false
        }

        // 只允许输入中英文，数字
        let pattern = "[a-zA-Z\\u4E00-\\u9FA5\\u0030-\\u0039]"
        let string = textField.text ?? ""
        return string.matches(pattern) || string.isEmpty
    }

    /// 限制输入长度，只在iOS13后生效，之前的使用，UITextField.textDidChangeNotification 通知方式
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let maxCount = 5
        // 限制输入的长度
        if let temp = textField.text, temp.count >= maxCount {
            if textField.markedTextRange != nil {
                return
            }
            textField.text = String(temp.prefix(maxCount))
        }
    }

    func textFieldShouldClear(_: UITextField) -> Bool {
        SC.log("To clear the input, the return value is whether to clear the content")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SC.log("To press the Return button, the Return value is whether to finish typing (lose focus)")
        // 收起键盘
        textField.resignFirstResponder()
        return true
    }

    // MARK: - IBActions

    @objc private func leftButtonAction() {
        SC.toast("Left button action")
    }

    @objc private func rightButtonAction() {
        SC.toast("Right button action")
        textField.text = ""
    }

    @objc private func textFiledEditChanged(notification: NSNotification) {
        let textField: UITextField = notification.object as! UITextField
        let maxCount = 20

        // 中英长度判断
        if let temp = textField.text, temp.count > maxCount {
            if textField.markedTextRange != nil {
                return
            }
            textField.text = String(temp.prefix(maxCount))
        }
    }

    @objc func accessoryLeftAction() {
        SC.toast("Cancel")
    }

    @objc func accessoryRightAction() {
        SC.toast("Confirm")
        view.endEditing(true)
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "UITextField"
        hideKeyboardWhenTapedAround()

        view.addSubview(selectTableView)

        // 表格数据
        let spaceAry = ["空间数", "100", "1000", "10000"]
        let priceAry = ["价格", "￥100", "￥1000", "￥10000"]
        let descAry = ["描述", "aa", "bb", "cc"]
        selectTableView.gySelectTableViewClosure = { row, isSelect in
            SC.log("select row: \(row), state: \(isSelect)")
        }
        selectTableView.show(dataSource: [spaceAry, priceAry, descAry], noDataInfo: "没有可选择空间扩容数")

        view.addSubview(textField)

        leftView.addSubview(leftButton)
        textField.leftView = leftView
        rightView.addSubview(rightButton)
        textField.rightView = rightView
        textField.delegate = self

        accessoryView.addSubview(accessoryLeftBtn)
        accessoryView.addSubview(accessoryRightBtn)
        textField.inputAccessoryView = accessoryView

        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        accessoryLeftBtn.addTarget(self, action: #selector(accessoryLeftAction), for: .touchUpInside)
        accessoryRightBtn.addTarget(self, action: #selector(accessoryRightAction), for: .touchUpInside)

        // 通过通知监听状态变化
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledEditChanged), name: UITextField.textDidChangeNotification, object: textField)
    }

    // MARK: - Constraints

    func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(view).offset(-40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-60)
        }

        selectTableView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.bottom.equalTo(textField.snp.top).offset(-20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

    // MARK: - Property

    let leftView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.frame = CGRect(x: 0, y: 0, width: 10 + 30, height: 40)
    }

    let leftButton = UIButton(type: .infoDark).then {
        $0.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
    }

    let rightView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.frame = CGRect(x: 0, y: 0, width: 10 + 30, height: 40)
    }

    let rightButton = UIButton(type: .close).then {
        $0.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
    }

    let accessoryView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: SC.w, height: 40)
        $0.backgroundColor = .cyan
    }

    let accessoryLeftBtn = UIButton(type: .custom).then {
        $0.frame = CGRect(x: 10, y: 10, width: 60, height: 20)
        $0.setTitle("Cancel", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .clear
    }

    let accessoryRightBtn = UIButton(type: .custom).then {
        $0.frame = CGRect(x: SC.w - 10 - 60, y: 10, width: 60, height: 20)
        $0.setTitle("Confirm", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .clear
    }

    let textField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .black
        // 主题颜色
        $0.tintColor = .green
        // 边框样式，边线+阴影
        $0.borderStyle = .roundedRect

        // 背景图片设置; 先要去除边框样式
        // $0.borderStyle = .none
        // $0.background = UIImage(named:"background1");

        $0.font = .systemFont(ofSize: 16)
        // 当文字超出文本框宽度时，自动调整文字大小
        $0.adjustsFontSizeToFitWidth = true
        // 输入内容对齐方式
        $0.textAlignment = .left
        // 垂直居中对齐
        $0.contentVerticalAlignment = .center
        $0.placeholder = "Please enter your email address"
        // 自动更正功能
        $0.autocorrectionType = .no
        // 完成按钮样式
        $0.returnKeyType = .done
        // 清除按钮显示状态；不能同时设置clearButtonMode、rightViewMode/rightView 属性，否则只有rightViewMode/rightView有效
        $0.clearButtonMode = .whileEditing
        // 键盘样式
        $0.keyboardType = .emailAddress
        // 键盘外观
        $0.keyboardAppearance = .alert
        // 安全文本输入
        $0.isSecureTextEntry = false
        // 左侧 view
        $0.leftViewMode = .always
        // 右侧 view
        $0.rightViewMode = .always
    }

    let selectTableView = SCSelectTableView()
}
