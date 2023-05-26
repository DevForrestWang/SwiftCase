//
//===--- SCPermenantThread.swift - Defines the SCPermenantThread class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/5/26.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 线程保活的封装
public class SCPermenantThread: NSObject {
    // MARK: - Lifecycle

    override init() {
        super.init()

        innerThread = SCThread(block: { [weak self] in
            guard let self = self else {
                return
            }

            // 添加一个port，用于线程间通信，相当于添加了个Source1，捕获事件给Source0处理（performSelector:onThread:）
            RunLoop.current.add(NSMachPort(), forMode: .default)

            while !self.isStoped {
                // 有了Port，启动RunLoop就不会立马退出
                RunLoop.current.run(mode: .default, before: Date.distantFuture)
            }

            print("RunLoop is done.")
        })
    }

    // 执行析构过程
    deinit {
        print("===========<deinit: \(type(of: self))>===========")
        stop()
    }

    // MARK: - Public

    public func run() {
        guard let thread = innerThread else {
            return
        }

        if !isStoped {
            return
        }

        isStoped = false
        thread.start()
    }

    public func stop() {
        guard let thread = innerThread else {
            return
        }

        // waitUntilDone要为true，确保RunLoop退出了再继续
        perform(#selector(stopThread), on: thread, with: nil, waitUntilDone: true)
    }

    public func executeTask(task: @escaping () -> Void) {
        guard let thread = innerThread else {
            return
        }

        perform(#selector(p_executeTask), on: thread, with: task, waitUntilDone: false)
    }

    // MARK: - Private

    @objc private func stopThread() {
        // 1.要先修改标识
        isStoped = true

        // 2.再停止RunLoop，否则可能标识都还没改就已经新循环的判断
        RunLoop.current.run(mode: .default, before: Date())

        // 3.不再使用线程就置为nil
        innerThread = nil
    }

    @objc private func p_executeTask(task: @escaping () -> Void) {
        task()
    }

    // MARK: - Property

    private var innerThread: SCThread?

    private var isStoped: Bool = true

    fileprivate class SCThread: Thread {
        deinit {
            print("===========<deinit: \(type(of: self))>===========")
        }
    }

    fileprivate class SCPort：Port {
        deinit {
            print("===========<deinit: \(type(of: self))>===========")
        }
    }
}
