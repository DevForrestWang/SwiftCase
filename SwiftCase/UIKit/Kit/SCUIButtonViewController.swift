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
            SC.log("I've been injected: \(self)")
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
        SC.log("Run Btn: \(button)")
        if button == btn1 {
            fwShowToast("Run button one")
        } else if button == btn2 {
            fwShowToast("Run button two")
        } else {
            fwShowToast("Run button others")
        }
    }

    // MARK: - Private

    @objc private func photoAlbumAction() {
        let imageURL = "https://t7.baidu.com/it/u=3655946603,4193416998&fm=193&f=GIF"
        SCUtils.downloadWith(urlStr: imageURL) { [weak self] image in
            guard let saveImage = image else {
                fwShowToast("图片下载失败")
                return
            }
            // 图片写入相册
            UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(self?.saveImageResult(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc private func saveImageResult(image _: UIImage, didFinishSavingWithError error: NSError?, contextInfo _: AnyObject) {
        if error != nil {
            fwShowToast("图片保存失败")
        } else {
            fwShowToast("图片保存成功")
        }
    }

    // MARK: - UI

    func setupUI() {
        title = "UIButton"
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btnFlash)
        view.addSubview(saveImageBtn)
        view.addSubview(textImgBtn)

        saveImageBtn.addTarget(self, action: #selector(photoAlbumAction), for: .touchUpInside)
        btn1.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
    }

    // MARK: - Constraints

    func setupConstraints() {
        btn1.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(view).offset(-50)
            // make.top.equalTo(20)
            make.centerY.equalToSuperview().offset(-200)
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

        saveImageBtn.snp.makeConstraints { make in
            make.top.equalTo(btnFlash.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }

        textImgBtn.snp.makeConstraints { make in
            make.top.equalTo(saveImageBtn.snp.bottom).offset(20)
            make.height.left.right.centerX.equalTo(saveImageBtn)
        }
    }

    // MARK: - Property

    let btn1 = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.orange
        $0.setTitle("Login", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    let btn2 = UIButton(type: .custom).then {
        $0.setImage(R.image.normalImage(), for: .normal)
        $0.setImage(R.image.hightImage(), for: .highlighted)
        // 按钮对齐方式：左对齐
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: -50, bottom: 5, right: 0)
        $0.layer.cornerRadius = 5

        $0.backgroundColor = .orange
        $0.setTitle("Logo", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
        $0.setTitleShadowColor(.green, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -50)
    }

    let btnFlash = SCImageTextButton(type: .custom).then {
        // $0.backgroundColor = .white
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.setTitle("手电筒", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }

    let saveImageBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("图片下载及相册保存", for: .normal)
        $0.setTitleColor(UIColor.hexColor(0x3F6D03), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0)
        $0.layer.cornerRadius = 15
    }

    // 指定图片位置
    let textImgBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .orange
        $0.setTitle("分享 ", for: .normal)
        $0.setTitleColor(UIColor.hexColor(0x3F6D03), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.setImage(UIImage(named: "search"), for: .normal)
        // 按钮图标在右侧
        $0.semanticContentAttribute = .forceRightToLeft
        $0.layer.cornerRadius = 15
    }
}
