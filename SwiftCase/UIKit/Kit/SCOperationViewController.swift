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

    class CustomOperation: Operation {
        override func main() {
            for _ in 0 ..< 2 {
                if isCancelled {
                    yxc_debugPrint("Cunstom operation is cancelled.")
                    break
                } else {
                    yxc_debugPrint("Cunstom operation in thread: \(Thread.current)")
                }
            }
        }
    }

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

    @objc private func addExecutionAction() {
        yxc_debugPrint("addExecutionAction")
        let operation = BlockOperation {
            yxc_debugPrint("Create a block operation in \(Thread.current).")
        }
        operation.addExecutionBlock {
            yxc_debugPrint("The block operation has add an execution block in \(Thread.current).")
        }
        operation.addExecutionBlock {
            yxc_debugPrint("The block operation has add an execution block in \(Thread.current).")
        }
        operation.start()

        // 自定义子类
        CustomOperation().start()
    }

    @objc private func addDependencyAction() {
        yxc_debugPrint("addDependencyAction")

        let queue = OperationQueue()
        var flag = false
        let op1 = BlockOperation {
            flag = true
            yxc_debugPrint("Operation 1 in \(Thread.current).")
            Thread.sleep(forTimeInterval: 2)
        }

        op1.completionBlock = {
            yxc_debugPrint("Operation 1 is completed.")
        }

        let op2 = BlockOperation {
            if flag {
                yxc_debugPrint("Operation 2 in \(Thread.current)")
            } else {
                yxc_debugPrint("Something went wrong.")
            }
        }

        let customOp = CustomOperation()

        op2.addDependency(op1)
        queue.addOperation(op1)
        queue.addOperation(op2)
        queue.addOperation(customOp)
    }

    @objc private func downLoadImageAction() {
        yxc_debugPrint("downLoadImageAction")
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Cocoa Operation"
        view.backgroundColor = .white

        view.addSubview(addExecutionBtn)
        view.addSubview(addDependencyBtn)
        view.addSubview(downLoadImageBtn)

        view.addSubview(imageView1)
        imageView1.addSubview(indicator1)
    }

    // MARK: - Constraints

    func setupConstraints() {
        addExecutionBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.left.equalTo(view).offset(15)
        }

        addDependencyBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(GlobalConfig.gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.right.equalTo(view).offset(-15)
        }

        downLoadImageBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-30)
            make.top.equalTo(addDependencyBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        indicator1.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }

        imageView1.snp.makeConstraints { make in
            make.height.equalTo(223)
            make.width.equalToSuperview()
            make.top.equalTo(downLoadImageBtn.snp.bottom).offset(20)
        }
    }

    // MARK: - Property

    let addExecutionBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("AddExecution", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(addExecutionAction), for: .touchUpInside)
    }

    let addDependencyBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("AddDependency", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(addDependencyAction), for: .touchUpInside)
    }

    let downLoadImageBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("DownLoadImage", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(downLoadImageAction), for: .touchUpInside)
    }

    let imageView1 = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "placeholder")
    }

    let indicator1 = UIActivityIndicatorView().then {
        $0.style = UIActivityIndicatorView.Style.medium
    }
}
