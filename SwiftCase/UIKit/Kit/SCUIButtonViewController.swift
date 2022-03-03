//
//===--- SCUIButtonViewController.swift - Defines the SCUIButtonViewController class ----------===//
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
import Then
import UIKit

class SCUIButtonViewController: BaseViewController {
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

    @objc private func btn1Action(button: UIButton) {
        yxc_debugPrint("Run Btn: \(button)")
        if button == btn1 {
            showToast("Run button one")
        } else if button == btn2 {
            showToast("Run button two")
        } else {
            showToast("Run button others")
        }
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "UIButton"

        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btnFlash)
    }

    // MARK: - Constraints

    func setupConstraints() {
        btn1.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(view).offset(-50)
            // make.top.equalTo(20)
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }

        btn2.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(200)
            make.top.equalTo(btn1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        btnFlash.snp.makeConstraints { make in
            make.top.equalTo(btn2.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    let btn1 = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.orange
        $0.setTitle("Login", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
    }

    let btn2 = UIButton(type: .custom).then {
        $0.setImage(R.image.normalImage(), for: .normal)
        $0.setImage(R.image.hightImage(), for: .highlighted)
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: -50, bottom: 5, right: 0)
        $0.layer.cornerRadius = 5

        $0.backgroundColor = .orange
        $0.setTitle("Logo", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
        $0.setTitleShadowColor(.green, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -50)
        $0.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
    }

    let btnFlash = ImageTextButton(type: .custom).then {
        // $0.backgroundColor = .white
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.setTitle("手电筒", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
}

/// 图文混排，图片在上，文字在下
// 来自：https://codeleading.com/article/30281015726/
class ImageTextButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        titleLabel?.textAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX = 0
        let titleY = contentRect.size.height * 0.35
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: CGFloat(titleX), y: titleY, width: titleW, height: titleH)
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.width
        let imageH = contentRect.size.height * 0.4
        return CGRect(x: 0, y: 5, width: imageW, height: imageH)
    }
}
