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
                    SC.log("Cunstom operation is cancelled.")
                    break
                } else {
                    SC.log("Cunstom operation in thread: \(Thread.current)")
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

    @objc private func addExecutionAction() {
        SC.log("addExecutionAction")
        let operation = BlockOperation {
            SC.log("Create a block operation in \(Thread.current).")
        }
        operation.addExecutionBlock {
            SC.log("The block operation has add an execution block in \(Thread.current).")
        }
        operation.addExecutionBlock {
            SC.log("The block operation has add an execution block in \(Thread.current).")
        }
        operation.start()

        // 自定义子类
        CustomOperation().start()

        fwShowToast("console logs")
    }

    @objc private func addDependencyAction() {
        SC.log("addDependencyAction")

        let queue = OperationQueue()
        var flag = false
        let op1 = BlockOperation {
            flag = true
            SC.log("Operation 1 in \(Thread.current).")
            Thread.sleep(forTimeInterval: 2)
        }

        op1.completionBlock = {
            SC.log("Operation 1 is completed.")
        }

        let op2 = BlockOperation {
            if flag {
                SC.log("Operation 2 in \(Thread.current)")
            } else {
                SC.log("Something went wrong.")
            }
        }

        let customOp = CustomOperation()

        op2.addDependency(op1)
        queue.addOperation(op1)
        queue.addOperation(op2)
        queue.addOperation(customOp)

        fwShowToast("console logs")
    }

    @objc private func downLoadImageAction() {
        SC.log("downLoadImageAction")
        imageView.image = UIImage(named: "placeholder")
        indicator.startAnimating()

        let downloadQueue = OperationQueue()
        downloadQueue.addOperation {
            Thread.sleep(forTimeInterval: 1)
            let imageURL = URL(string: self.strImageURL)
            let data = try? Data(contentsOf: imageURL!)

            guard let tmpData = data else {
                OperationQueue.main.addOperation {
                    self.indicator.stopAnimating()
                }
                SC.log("Download failed.")
                return
            }

            let image = UIImage(data: tmpData)
            OperationQueue.main.addOperation {
                if let image = image {
                    self.imageView.image = image
                }
                self.indicator.stopAnimating()
            }
        }
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Cocoa Operation"
        view.backgroundColor = .white

        view.addSubview(addExecutionBtn)
        view.addSubview(addDependencyBtn)
        view.addSubview(downLoadImageBtn)

        view.addSubview(imageView)
        imageView.addSubview(indicator)

        addExecutionBtn.addTarget(self, action: #selector(addExecutionAction), for: .touchUpInside)
        addDependencyBtn.addTarget(self, action: #selector(addDependencyAction), for: .touchUpInside)
        downLoadImageBtn.addTarget(self, action: #selector(downLoadImageAction), for: .touchUpInside)
    }

    // MARK: - Constraints

    func setupConstraints() {
        addExecutionBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.left.equalTo(view).offset(15)
        }

        addDependencyBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.right.equalTo(view).offset(-15)
        }

        downLoadImageBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-30)
            make.top.equalTo(addDependencyBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(223)
            make.width.equalToSuperview()
            make.top.equalTo(downLoadImageBtn.snp.bottom).offset(20)
        }
    }

    // MARK: - Property

    let strImageURL = "https://cdn.pixabay.com/photo/2021/08/19/12/53/bremen-6557996_960_720.jpg"

    let addExecutionBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("AddExecution", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let addDependencyBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("AddDependency", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let downLoadImageBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("DownLoadImage", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "placeholder")
    }

    let indicator = UIActivityIndicatorView().then {
        $0.style = UIActivityIndicatorView.Style.medium
    }
}
