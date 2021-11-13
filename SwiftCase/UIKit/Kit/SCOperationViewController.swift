//
//===--- SCOperationViewController.swift - Defines the SCOperationViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/13.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCOperationViewController: BaseViewController {
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

    @objc private func invocationOperationAction() {
        yxc_debugPrint("invocationOperationAction")
    }

    @objc private func blockOperationAction() {
        yxc_debugPrint("blockOperationAction")
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Cocoa Operation"
        view.backgroundColor = .white

        view.addSubview(invocationOperationBtn)
        view.addSubview(blockOperationBtn)

        view.addSubview(imageView1)
        imageView1.addSubview(indicator1)
    }

    // MARK: - Constraints

    func setupConstraints() {
        invocationOperationBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.left.equalTo(view).offset(15)
        }

        blockOperationBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.right.equalTo(view).offset(-15)
        }

        indicator1.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }

        imageView1.snp.makeConstraints { make in
            make.height.equalTo(223)
            make.width.equalToSuperview()
            make.top.equalTo(invocationOperationBtn.snp.bottom).offset(20)
        }
    }

    // MARK: - Property

    let invocationOperationBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("InvocationOperation", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(invocationOperationAction), for: .touchUpInside)
    }

    let blockOperationBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("BlockOperation", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(blockOperationAction), for: .touchUpInside)
    }

    let imageView1 = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "placeholder")
    }

    let indicator1 = UIActivityIndicatorView().then {
        $0.style = UIActivityIndicatorView.Style.medium
    }
}
