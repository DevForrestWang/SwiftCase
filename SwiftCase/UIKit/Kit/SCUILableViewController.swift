//
//===--- SCUILableViewController.swift - Defines the SCUILableViewController class ----------===//
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

import SnapKit
import UIKit

class SCUILableViewController: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func showAllFonts() {
        let familyNames = UIFont.familyNames
        var index = 0
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for font in fontNames {
                index += 1
                yxc_debugPrint("\(index). font name:\(font)")
                systemFontName.append(font)
            }
        }

        if systemFontName.contains("HelveticaNeue-Bold") {
            attributeString.addAttribute(NSAttributedString.Key.font,
                                         value: UIFont(name: "HelveticaNeue-Bold", size: 30) as Any, range: NSMakeRange(0, 5))
            lab2.attributedText = attributeString
        }
    }

    private func calculateSizeFor(label: UILabel, attributedText: NSAttributedString) -> CGSize {
        let constraint = CGSize(width: label.frame.size.width, height: .greatestFiniteMagnitude)
        let context = NSStringDrawingContext()

        let boundingBox = attributedText.boundingRect(with: constraint,
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: context)
        return boundingBox.size
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        clickNumbers += 1
        if clickNumbers > 3 {
            // 文本高亮
            lab1.isHighlighted = true
            lab1.highlightedTextColor = .orange
            showToast("Reach the maximum number")
            return
        }
        lab1.text! += ", \(lab1.text!)"
    }

    private func useAttributedStrings() {
        let username = "AliGator"
        let str: AttrString = """
        Hello \(username, .color(.red)), isn't this \("cool", .color(.blue), .oblique, .underline(.purple, .single))?

        \(wrap: """
        \(" Merry Xmas! ", .font(.systemFont(ofSize: 36)), .color(.red), .bgColor(.yellow))
        \(image: #imageLiteral(resourceName: "santa.png"), scale: 0.7)
        """, .alignment(.center))

        Go there to \("learn more about String Interpolation", .link("https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md"), .underline(.blue, .single))!
        """
        lab4.attributedText = str.attributedString
    }

    // MARK: - UI

    func setupUI() {
        title = "UILable"
        showAllFonts()
        view.addSubview(lab1)

        view.addSubview(lab2)
        lab2.attributedText = attributeString

        let messageRect: CGSize = calculateSizeFor(label: lab3, attributedText: attributeString)
        yxc_debugPrint("The lable calculate height:\(String(format: "%.2f", messageRect.height))")

        view.addSubview(lab3)
        // 改变行间距
        lab3.changeLineSpace(space: 10)

        view.addSubview(lab4)
        useAttributedStrings()
    }

    // MARK: - Constraints

    func setupConstraints() {
        // 文字长度如果短于某个值,则让 label 适应文字宽度,如果长于这个值的话,则让 label 的宽度固定,高度适应其文本
        lab1.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view).offset(-50)
            make.top.equalTo(20)
            // make.centerY.equalToSuperview().offset(-150)
            make.centerX.equalToSuperview()
        }

        lab2.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view).offset(-50)
            make.top.equalTo(lab1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        lab3.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view).offset(-50)
            make.top.equalTo(lab2.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        lab4.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view).offset(-50)
            make.top.equalTo(lab3.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    var clickNumbers = 0
    var systemFontName: [String] = []

    let lab1 = SCPaddingLabel().then {
        $0.text = "点击我会变大！"
        $0.textAlignment = .left
        $0.backgroundColor = UIColor.green
        // 多行显示
        $0.numberOfLines = 0
        // "abcd..."
        $0.lineBreakMode = .byTruncatingTail
        // 自动调节字号
        // $0.adjustsFontSizeToFitWidth = true

        // layer层设置
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.orange.cgColor
    }

    // 富文本
    let lab2 = SCPaddingLabel().then {
        $0.backgroundColor = .white
        $0.font = UIFont(name: "Thonburi", size: 16)
    }

    let attributeString = NSMutableAttributedString(string: "Label 富文本属性").then {
        $0.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, 5))
        $0.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.green, range: NSMakeRange(0, 5))
    }

    let lab3 = SCPaddingLabel().then {
        $0.text = "swift中计算字符串的宽度和高度。swift中计算字符串的宽度和高度。swift中计算字符串的宽度和高度。"
        $0.backgroundColor = .green
        $0.font = .systemFont(ofSize: 16)
        // 高度自适应
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    let lab4 = UILabel().then {
        $0.backgroundColor = .cyan
        $0.numberOfLines = 0
    }

    /// 定义文字到边框距离
    class SCPaddingLabel: UILabel {
        var circularFillet = false

        let padding = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: padding))
        }

        override var intrinsicContentSize: CGSize {
            let superContentSize = super.intrinsicContentSize
            let width = superContentSize.width + padding.left + padding.right
            let heigth = superContentSize.height + padding.top + padding.bottom
            return CGSize(width: width, height: heigth)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            if circularFillet == true {
                let h = layer.frame.size.height
                layer.cornerRadius = h / 2
            }
        }
    }
}
