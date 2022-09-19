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
            fwDebugPrint("I've been injected: \(self)")
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
        fwDebugPrint("serialSyncAction")
        let queue = DispatchQueue(label: "com.forrest.serial")

        // 串行队列做同步操作, 容易造成死锁
        queue.sync {
            fwDebugPrint("Sync operation in as serial queue.")
        }

        fwShowToast("console logs")
    }

    @objc private func serialAsyncAction() {
        fwDebugPrint("serialAsyncAction")
        let queue = DispatchQueue(label: "com.forrest.serail2")
        // 串行队列做异步操作是顺序执行
        queue.async {
            fwDebugPrint(Thread.current)
            for i in 0 ..< 2 {
                fwDebugPrint("First i: \(i)")
            }
        }

        queue.async {
            fwDebugPrint(Thread.current)
            for i in 0 ..< 2 {
                fwDebugPrint("Second i: \(i)")
            }
        }

        fwShowToast("console logs")
    }

    @objc private func concurrentSyncAction() {
        fwDebugPrint("concurrentSyncAction")

        let lable = "com.forrest.concurrent1"
        let qos = DispatchQoS.default
        let attributes = DispatchQueue.Attributes.concurrent
        let autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.never
        let queue = DispatchQueue(label: lable, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: nil)

        // 并发队列同步操作是顺序执行
        queue.sync {
            for i in 0 ..< 2 {
                fwDebugPrint("First sync i: \(i)")
            }
        }

        queue.sync {
            for i in 0 ..< 2 {
                fwDebugPrint("Second sync i: \(i)")
            }
        }

        fwShowToast("console logs")
    }

    @objc private func concurrentAsyncAction() {
        fwDebugPrint("concurrentAsyncAction")

        let lable = "com.forrest.concurrent2"
        let attributes = DispatchQueue.Attributes.concurrent
        let queue = DispatchQueue(label: lable, attributes: attributes)

        // 并发队列做异步操作执行顺序不固定
        queue.async {
            for i in 0 ..< 2 {
                fwDebugPrint("First async i: \(i)")
            }
        }

        queue.async {
            for i in 0 ..< 2 {
                fwDebugPrint("Second async i: \(i)")
            }
        }

        fwShowToast("console logs")
    }

    @objc private func downImageInGroupAction() {
        fwDebugPrint("downImageInGroupAction")

        imageView1.image = UIImage(named: "placeholder")
        imageView2.image = UIImage(named: "placeholder")
        indicator1.startAnimating()
        indicator2.startAnimating()

        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        var fileURL1 = URL(fileURLWithPath: documentPath!)
        fileURL1 = fileURL1.appendingPathComponent("lb1")
        fileURL1 = fileURL1.appendingPathExtension("jpg")

        var fileURL2 = URL(fileURLWithPath: documentPath!)
        fileURL2 = fileURL2.appendingPathComponent("lb2")
        fileURL2 = fileURL2.appendingPathExtension("jpg")

        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            fwDebugPrint("Begin to download image 1.")
            let imageURL = URL(string: self.strImageURL)
            let data = try? Data(contentsOf: imageURL!)

            guard let tmpData = data else {
                DispatchQueue.main.async {
                    self.indicator1.stopAnimating()
                }
                fwDebugPrint("Failed to download image 1.")
                return
            }

            try! tmpData.write(to: fileURL1, options: .atomic)
            fwDebugPrint("image 1 download")
            sleep(1)
            group.leave()
        }

        group.enter()
        DispatchQueue.global().async {
            fwDebugPrint("Begin to down image 2.")

            let imageURL = URL(string: self.strImageURL2)
            let data = try? Data(contentsOf: imageURL!)

            guard let tmpData = data else {
                DispatchQueue.main.async {
                    self.indicator2.stopAnimating()
                }
                fwDebugPrint("Failed to download image 2.")
                return
            }

            try! tmpData.write(to: fileURL2, options: .atomic)
            sleep(1)
            fwDebugPrint("image 2 download.")
            group.leave()
        }

        group.notify(queue: .main) {
            let imageData1 = try? Data(contentsOf: fileURL1)
            let imageData2 = try? Data(contentsOf: fileURL2)

            guard let tmpData1 = imageData1 else {
                fwDebugPrint("The imageData1 is nil")
                return
            }

            guard let tmpData2 = imageData2 else {
                fwDebugPrint("The imageData2 is nil")
                return
            }

            self.imageView1.image = UIImage(data: tmpData1)
            self.imageView2.image = UIImage(data: tmpData2)
            self.indicator1.stopAnimating()
            self.indicator2.stopAnimating()
        }
    }

    @objc private func dispatchSemaphoreAction() {
        fwDebugPrint("dispatchSemaphoreAction")
        let semaphore = DispatchSemaphore(value: 2)
        // semaphore 在串行队列需要注意死锁问题
        let queue = DispatchQueue(label: "com.forrest.concurrent", qos: .default, attributes: .concurrent)

        queue.async {
            semaphore.wait()
            fwDebugPrint("First car in")
            sleep(3)
            fwDebugPrint("First car out.")
            semaphore.signal()
        }

        queue.async {
            semaphore.wait()
            fwDebugPrint("Second car in")
            sleep(2)
            fwDebugPrint("Second car out.")
            semaphore.signal()
        }

        queue.async {
            semaphore.wait()
            fwDebugPrint("Third car in")
            sleep(4)
            fwDebugPrint("Third car out.")
            semaphore.signal()
        }

        fwShowToast("console logs")
    }

    // MARK: - Private

    /// 线程异步处理数据演示
    private func asyncDemo() {
        // 创建并行队列，尽量用自定义队列，免得自己的代码质量不过关，影响全局队列
        let queue = DispatchQueue(label: "com.apple.request", attributes: .concurrent)
        // 异步执行
        queue.async {
            print("开始请求数据 \(Date())  thread: \(Thread.current)")
            sleep(10) // 模拟网络请求
            print("数据请求完成 \(Date())  thread: \(Thread.current)")

            // 异步执行
            queue.async {
                print("开始处理数据 \(Date())  thread: \(Thread.current)")
                sleep(5) // 模拟数据处理
                print("数据处理完成 \(Date())  thread: \(Thread.current)")

                // 切换到主队列，刷新UI
                DispatchQueue.main.async {
                    print("UI刷新成功  \(Date())  thread: \(Thread.current)")
                }
            }
        }
    }

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
        serialSyncBtn.addTarget(self, action: #selector(serialSyncAction), for: .touchUpInside)
        serialAsyncBtn.addTarget(self, action: #selector(serialAsyncAction), for: .touchUpInside)
        concurrentSyncBtn.addTarget(self, action: #selector(concurrentSyncAction), for: .touchUpInside)
        concurrentAsyncBtn.addTarget(self, action: #selector(concurrentAsyncAction), for: .touchUpInside)
        downImageInGroupBtn.addTarget(self, action: #selector(downImageInGroupAction), for: .touchUpInside)
        dispatchSemaphoreBtn.addTarget(self, action: #selector(dispatchSemaphoreAction), for: .touchUpInside)

        view.addSubview(imageView1)
        view.addSubview(imageView2)
        imageView1.addSubview(indicator1)
        imageView2.addSubview(indicator2)

        let dispatchTime = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            fwDebugPrint("After 0.5 second.")
        }

        // 串行队列做异步操作是顺序执行
        DispatchQueue.main.async {
            for i in 0 ..< 2 {
                fwDebugPrint("First main queue async i: \(i)")
            }
        }

        asyncDemo()
    }

    // MARK: - Constraints

    func setupConstraints() {
        serialSyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.left.equalTo(view).offset(15)
        }

        serialAsyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(20)
            make.right.equalTo(view).offset(-15)
        }

        concurrentSyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(serialSyncBtn.snp.bottom).offset(20)
            make.left.equalTo(view).offset(15)
        }

        concurrentAsyncBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(serialAsyncBtn.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-15)
        }

        downImageInGroupBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
            make.top.equalTo(concurrentSyncBtn.snp.bottom).offset(20)
            make.left.equalTo(view).offset(15)
        }

        dispatchSemaphoreBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(gScreenWidth / 2 - 25)
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

    let strImageURL = "https://cdn.pixabay.com/photo/2021/08/19/12/53/bremen-6557996_960_720.jpg"
    let strImageURL2 = "https://cdn.pixabay.com/photo/2020/09/01/21/03/sunset-5536777_960_720.jpg"

    let serialSyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Serial&Sync", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let serialAsyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Serial&Async", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let concurrentSyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Concurrent&Sync", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let concurrentAsyncBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Concurrent&Async", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let downImageInGroupBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Load Image in Group", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
    }

    let dispatchSemaphoreBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("DispatchSemaphore", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
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
