//
//===--- SCAttributedStringVC.swift - Defines the SCAttributedStringVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2022/12/5.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class SCAttributedStringVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        initData()
    }

    // 执行析构过程
    deinit {
        SC.log("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func initData() {
        setColorLable()
        setFontLable()
        setUnlineLabel()
        setStrokeLabel()
        setShadowLable()
    }

    private func setColorLable() {
        let text = "This is a colorful attributed string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: .red, subString: "This")
        attributedText.apply(color: .darkGray, onRange: NSMakeRange(5, 4)) // Range of substring "is a"
        attributedText.apply(color: .purple, subString: "colorful")
        attributedText.apply(color: .blue, subString: "attributed")
        attributedText.apply(color: .orange, subString: "string")
        colorLable.attributedText = attributedText
    }

    private func setFontLable() {
        let text = "This string is having multiple font"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), subString: "This")
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), onRange: NSMakeRange(5, 6))
        attributedText.apply(font: UIFont.italicSystemFont(ofSize: 20), subString: "string")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, subString: " is")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-ThinItalic", size: 20)!, subString: "having")
        attributedText.apply(color: UIColor.blue, subString: "having")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!, subString: "multiple")
        attributedText.apply(color: appRedColor, subString: "multiple")
        fontLable.attributedText = attributedText
    }

    private func setUnlineLabel() {
        let text = "This is underline string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.underLine(subString: "This is underline string")
        unlineLable.attributedText = attributedText
    }

    private func setStrokeLabel() {
        let text = "This is a strike and underline stroke string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.strikeThrough(thickness: 2, subString: "This is a")
        attributedText.underLine(subString: "underline")
        attributedText.applyStroke(color: appRedColor, thickness: 2, subString: "stroke string")
        strokeLable.attributedText = attributedText
    }

    private func setShadowLable() {
        let text = "This string is having a shadow"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeigt: 4.0, shadowRadius: 4.0, subString: "This string is")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 0, shadowHeigt: 0, shadowRadius: 5.0, subString: "having")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeigt: 4.0, shadowRadius: 4.0, subString: "a shadow")
        shadowLable.attributedText = attributedText
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Lable AttributedString"

        view.addSubview(colorLable)
        view.addSubview(fontLable)
        view.addSubview(unlineLable)
        view.addSubview(strokeLable)
        view.addSubview(shadowLable)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        colorLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
        }

        fontLable.snp.makeConstraints { make in
            make.height.left.right.equalTo(colorLable)
            make.top.equalTo(colorLable.snp.bottom).offset(20)
        }

        unlineLable.snp.makeConstraints { make in
            make.height.left.right.equalTo(colorLable)
            make.top.equalTo(fontLable.snp.bottom).offset(20)
        }

        strokeLable.snp.makeConstraints { make in
            make.height.left.right.equalTo(colorLable)
            make.top.equalTo(unlineLable.snp.bottom).offset(20)
        }

        shadowLable.snp.makeConstraints { make in
            make.height.left.right.equalTo(colorLable)
            make.top.equalTo(strokeLable.snp.bottom).offset(20)
        }
    }

    // MARK: - Property

    let appRedColor = UIColor(red: 230.0 / 255.0, green: 51.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)

    let appBlueColor = UIColor(red: 62.0 / 255.0, green: 62.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)

    let appYellowColor = UIColor(red: 248.0 / 255.0, green: 175.0 / 255.0, blue: 0.0, alpha: 1.0)

    let darkOrangeColor = UIColor(red: 248.0 / 255.0, green: 150.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)

    let colorLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    let fontLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    let unlineLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    let strokeLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    let shadowLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }
}
