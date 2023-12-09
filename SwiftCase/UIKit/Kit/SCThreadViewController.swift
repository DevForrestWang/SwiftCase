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
// https://github.com/Oniityann/SwiftMultiThreadDemo
//
//===----------------------------------------------------------------------===//

import Foundation
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
    deinit {
        stopThreadAction()
    }

    // MARK: - Public

    // MARK: - Thread

    @objc private func threadAction(_ obj: Any) {
        SC.log("Thread action parameter: \(obj), current thread: \(Thread.current)")
    }

    private func saleTicket() {
        if ticketCount <= 0 {
            ticketCount = 30
        }

        thread1 = Thread(target: self, selector: #selector(saleTicketAction(_:)), object: "Thread One")
        thread1.name = "Thread One"

        thread2 = Thread(target: self, selector: #selector(saleTicketAction(_:)), object: "Thread Two")
        thread2.name = "Thread Two"

        thread3 = Thread(target: self, selector: #selector(saleTicketAction(_:)), object: "Thread Three")
        thread3.name = "Thread Three"

        thread1.start()
        thread2.start()
        thread3.start()
    }

    @objc private func saleTicketAction(_ obj: Any) {
        SC.log("Thread 3 action parameter: \(obj), current thread: \(String(describing: Thread.current.name))")
        while ticketCount > 0 {
            synchronized(self) {
                Thread.sleep(forTimeInterval: 0.1)
                if ticketCount > 0 {
                    ticketCount -= 1
                    SC.log("\(Thread.current.name!) sold 1 ticket, \(self.ticketCount) remains.")
                    // 主线程显示余票
                    self.performSelector(onMainThread: #selector(updateTicketNum), with: nil, waitUntilDone: true)
                } else {
                    SC.log("Tickets have been sold out.")
                    // 终止线程
                    thread1.cancel()
                    thread2.cancel()
                    thread3.cancel()
                }
            }
        }
    }

    func synchronized(_ lock: AnyObject, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }

    @objc func updateTicketNum() {
        threadButton.setTitle("Start Thread, Ticket: \(ticketCount)", for: .normal)

        if ticketCount == 0 {
            threadButton.setTitle("Start Thread", for: .normal)
        }
    }

    // MARK: - Cocoa Operation(Operation、OperationQueue)

    // MARK: - Grand Central Dispath(GCD)

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func threadBtnAction() {
        SC.printEnter(message: "Thread")
        // 方式1
        Thread.detachNewThreadSelector(#selector(threadAction(_:)), toTarget: self, with: "ThreadName1")

        // 方式2
        performSelector(inBackground: #selector(threadAction(_:)), with: "ThreadName2")

        // 方式3
        saleTicket()
    }

    @objc private func operationBtnAction() {
        SC.printEnter(message: "Cocoa Operation")
        let vc = SCOperationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func gcgBtnAction() {
        SC.printEnter(message: "Grand Central Dispath(GCD)")
        let vc = SCGCDViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func stopThreadAction() {
        perThread?.stop()
    }

    @objc private func asyncAction() {
        guard let url = URL(string: "https://talk.objc.io/episodes.json") else {
            return
        }

        Task {
            let episodAry = try await loadEpisodes(url: url)
            SC.toast("episodAry count: \(episodAry.count)")
            // episodAry count: 376

            if episodAry.count > 0 {
                let imageAry = try await loadPosterImages(for: episodAry)
                SC.toast("imageAry count: \(imageAry.count)")
            }
        }
    }

    override public func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        perThread?.executeTask(task: {
            print("执行任务 --- \(Thread.current)")
        })
    }

    // MARK: - Private

    // 执行多个异步加载
    private func loadEpisodeData() {
        guard let url = URL(string: "https://talk.objc.io/episodes.json") else {
            return
        }

        let task = Task {
            let episodAry = try await loadEpisodes(url: url)
            SC.toast("episodAry count: \(episodAry.count)")
            // episodAry count: 376

            let doubleEpisod = try await loadDoubleEpisodes(url: url)
            SC.toast("doubleEpisod.0 count: \(doubleEpisod.0.count)")
        }

        // 验证取消操作
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.5) {
            task.cancel()
        }
    }

    /// 使用 Async/Await 加载数据
    private func loadEpisodes(url: URL) async throws -> [Episode] {
        // 设置取消检查点
        try Task.checkCancellation()
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw SCServiceError(retCode: 9001, msg: "No data.")
        }

        return try JSONDecoder().decode([Episode].self, from: data)
    }

    /// 执行两个异步绑定
    private func loadDoubleEpisodes(url: URL) async throws -> ([Episode], [Episode]) {
        // async let 语法创建了一个异步绑定
        async let episodes = loadEpisodes(url: url)
        async let episodes2 = loadEpisodes(url: url)

        // 等待异步绑定完成
        try Task.checkCancellation()
        return try await (episodes, episodes2)
    }

    /// 加载海报
    private func loadPosterImages(for episodes: [Episode]) async throws -> [String: UIImage] {
        let session = URLSession.shared
        return try await withThrowingTaskGroup(of: (id: String, image: UIImage).self) { group in
            for episode in episodes {
                // 图片地址需要代理，否则会下载失败 或 很慢
                guard let url = URL(string: episode.poster_url) else {
                    continue
                }

                // 添加下载任务
                group.addTask {
                    let (imageData, _) = try await session.data(from: url)
                    return (episode.id, UIImage(data: imageData) ?? UIImage())
                }
            }

            // 归并下载任务
            return try await group.reduce(into: [:]) { dict, pair in
                dict[pair.id] = pair.image
            }
        }
    }

    /// 资源隔离
    private func resourceIsolate() {
        actor Counter {
            var value = 0

            func increment() -> Int {
                // 随机柱塞时间
                usleep(arc4random_uniform(10000))
                value = value + 1
                return value
            }
        }

        let counter = Counter()

        Task.detached(priority: .medium) {
            for _ in 0 ..< 1000 {
                print("medium: \(await counter.increment())")
                print("medium2: \(await counter.increment())")
            }
        }
        
        // medium: 1
        // medium2: 2
        // medium: 3
        // medium2: 4
        // ...
        // medium: 1997
        // medium2: 1998
        // medium: 1999
        // medium2: 2000
    }

    // MARK: - UI

    func setupUI() {
        title = "Thread"
        view.backgroundColor = .white

        view.addSubview(threadButton)
        view.addSubview(operationBtn)
        view.addSubview(gcdButton)
        view.addSubview(perThredButton)
        view.addSubview(asyncButton)

        threadButton.addTarget(self, action: #selector(threadBtnAction), for: .touchUpInside)
        operationBtn.addTarget(self, action: #selector(operationBtnAction), for: .touchUpInside)
        gcdButton.addTarget(self, action: #selector(gcgBtnAction), for: .touchUpInside)
        perThredButton.addTarget(self, action: #selector(stopThreadAction), for: .touchUpInside)
        asyncButton.addTarget(self, action: #selector(asyncAction), for: .touchUpInside)

        perThread = SCPermenantThread()
        perThread?.run()

        // loadEpisodeData()
        resourceIsolate()
    }

    // MARK: - Constraints

    func setupConstraints() {
        threadButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(44)
            make.width.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }

        operationBtn.snp.makeConstraints { make in
            make.top.equalTo(threadButton.snp.bottom).offset(20)
            make.height.width.centerX.equalTo(threadButton)
        }

        gcdButton.snp.makeConstraints { make in
            make.top.equalTo(operationBtn.snp.bottom).offset(20)
            make.height.width.centerX.equalTo(threadButton)
        }

        perThredButton.snp.makeConstraints { make in
            make.top.equalTo(gcdButton.snp.bottom).offset(20)
            make.height.width.centerX.equalTo(threadButton)
        }

        asyncButton.snp.makeConstraints { make in
            make.top.equalTo(perThredButton.snp.bottom).offset(20)
            make.height.width.centerX.equalTo(threadButton)
        }
    }

    // MARK: - Property

    var ticketCount = 30
    var thread1: Thread!
    var thread2: Thread!
    var thread3: Thread!

    let threadButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start Thread", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    let operationBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start OperationQueue", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    let gcdButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start GCD", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    let perThredButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Stop Permenant Thread", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    let asyncButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Async/Await 加载数据", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }

    var perThread: SCPermenantThread?

    /// 数据模型
    struct Episode: Codable {
        var id: String
        var title: String
        var poster_url: String
        var small_poster_url: String
        var url: String
        var synopsis: String
        var collection: String
        var released_at: Int64
        var number: Int
        var media_duration: Int
        var subscription_only: Bool
    }
}
