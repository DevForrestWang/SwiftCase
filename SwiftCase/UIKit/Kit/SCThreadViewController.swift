//
//===--- SCThreadViewController.swift - Defines the SCThreadViewController class ----------===//
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

class SCThreadViewController: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Thread

    // MARK: - Cocoa Operation(Operation、OperationQueue)

    // MARK: - Grand Central Dispath(GCD)

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func threadAction() {
        printEnter(message: "Thread")
    }

    @objc private func operationAction() {
        printEnter(message: "Cocoa Operation")
    }

    @objc private func gcgAction() {
        printEnter(message: "Grand Central Dispath(GCD)")
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Thread"
        view.backgroundColor = .white

        view.addSubview(threadButton)
        view.addSubview(operationBtn)
        view.addSubview(gcdButton)
    }

    // MARK: - Constraints

    func setupConstraints() {
        threadButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview().offset(-180)
            make.centerX.equalToSuperview()
        }

        operationBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-50)
            make.top.equalTo(threadButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }

        gcdButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-50)
            make.top.equalTo(operationBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    let threadButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start Thread", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(threadAction), for: .touchUpInside)
    }

    let operationBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start OperationQueue", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(operationAction), for: .touchUpInside)
    }

    let gcdButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start GCD", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(gcgAction), for: .touchUpInside)
    }
}
