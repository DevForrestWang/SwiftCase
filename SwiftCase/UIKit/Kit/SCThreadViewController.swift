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
    deinit {}

    // MARK: - Public

    // MARK: - Thread

    @objc private func threadAction(_ obj: Any) {
        yxc_debugPrint("Thread action parameter: \(obj), current thread: \(Thread.current)")
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
        yxc_debugPrint("Thread 3 action parameter: \(obj), current thread: \(String(describing: Thread.current.name))")
        while ticketCount > 0 {
            synchronized(self) {
                Thread.sleep(forTimeInterval: 0.1)
                if ticketCount > 0 {
                    ticketCount -= 1
                    yxc_debugPrint("\(Thread.current.name!) sold 1 ticket, \(self.ticketCount) remains.")
                    // 主线程显示余票
                    self.performSelector(onMainThread: #selector(updateTicketNum), with: nil, waitUntilDone: true)
                } else {
                    yxc_debugPrint("Tickets have been sold out.")
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
        printEnter(message: "Thread")
        // 方式1
        Thread.detachNewThreadSelector(#selector(threadAction(_:)), toTarget: self, with: "ThreadName1")

        // 方式2
        performSelector(inBackground: #selector(threadAction(_:)), with: "ThreadName2")

        // 方式3
        saleTicket()
    }

    @objc private func operationBtnAction() {
        printEnter(message: "Cocoa Operation")
        let vc = SCOperationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func gcgBtnAction() {
        printEnter(message: "Grand Central Dispath(GCD)")
        let vc = SCGCDViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        $0.addTarget(self, action: #selector(threadBtnAction), for: .touchUpInside)
    }

    let operationBtn = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start OperationQueue", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(operationBtnAction), for: .touchUpInside)
    }

    let gcdButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("Start GCD", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(gcgBtnAction), for: .touchUpInside)
    }
}
