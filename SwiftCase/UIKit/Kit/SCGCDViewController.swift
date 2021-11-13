//
//===--- SCGCDViewController.swift - Defines the SCGCDViewController class ----------===//
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

class SCGCDViewController: BaseViewController {
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

    @objc private func serialSyncAction() {
        yxc_debugPrint("serialSyncAction")
    }

    @objc private func serialAsyncAction() {
        yxc_debugPrint("serialAsyncAction")
    }

    @objc private func concurrentSyncAction() {
        yxc_debugPrint("concurrentSyncAction")
    }

    @objc private func concurrentAsyncAction() {
        yxc_debugPrint("concurrentAsyncAction")
    }

    @objc private func downImageInGroupAction() {
        yxc_debugPrint("downImageInGroupAction")
        indicator1.startAnimating()
        indicator2.startAnimating()
    }

    @objc private func dispatchSemaphoreAction() {
        yxc_debugPrint("dispatchSemaphoreAction")
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Grand Central Dispath"
        view.backgroundColor = .white

        view.addSubview(serialSyncBtn)
        view.addSubview(serialAsyncBtn)
        view.addSubview(concurrentSyncBtn)
        view.addSubview(concurrentAsyncBtn)
        view.addSubview(downImageInGroupBtn)
        view.addSubview(dispatchSemaphoreBtn)

        view.addSubview(imageView1)
        view.addSubview(imageView2)

        imageView1.addSubview(indicator1)
        imageView2.addSubview(indicator2)
    }

    // MARK: - Constraints

    func setupConstraints() {
        serialSyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.left.equalTo(view).offset(15)
        }

        serialAsyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.right.equalTo(view).offset(-15)
        }

        concurrentSyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(serialSyncBtn.snp.bottom).offset(20)
            make.left.equalTo(view).offset(15)
        }

        concurrentAsyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(serialAsyncBtn.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-15)
        }

        downImageInGroupBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(concurrentSyncBtn.snp.bottom).offset(20)
            make.left.equalTo(view).offset(15)
        }

        dispatchSemaphoreBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(concurrentAsyncBtn.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-15)
        }

        indicator1.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }

        indicator2.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }

        imageView1.snp.makeConstraints { make in
            make.height.equalTo(223)
            make.width.equalToSuperview()
            make.top.equalTo(downImageInGroupBtn.snp.bottom).offset(20)
        }

        imageView2.snp.makeConstraints { make in
            make.height.equalTo(223)
            make.width.equalToSuperview()
            make.top.equalTo(imageView1.snp.bottom).offset(20)
        }
    }

    // MARK: - Property

    let serialSyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Serial&Sync", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(serialSyncAction), for: .touchUpInside)
    }

    let serialAsyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Serial&Async", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(serialAsyncAction), for: .touchUpInside)
    }

    let concurrentSyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Concurrent&Sync", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(concurrentSyncAction), for: .touchUpInside)
    }

    let concurrentAsyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Concurrent&Async", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(concurrentAsyncAction), for: .touchUpInside)
    }

    let downImageInGroupBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Load Image in Group", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(downImageInGroupAction), for: .touchUpInside)
    }

    let dispatchSemaphoreBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("DispatchSemaphore", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(dispatchSemaphoreAction), for: .touchUpInside)
    }

    let imageView1 = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "placeholder")
    }

    let imageView2 = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "placeholder")
    }

    let indicator1 = UIActivityIndicatorView().then {
        $0.style = UIActivityIndicatorView.Style.medium
    }

    let indicator2 = UIActivityIndicatorView().then {
        $0.style = UIActivityIndicatorView.Style.medium
    }
}
