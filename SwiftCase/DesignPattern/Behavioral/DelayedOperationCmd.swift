//
//===--- DelayedOperationCmd.swift - Defines the DelayedOperationCmd class ----------===//
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

import Foundation
/*:
  ###  命令是一种行为设计模式，它可将请求或简单操作转换为一个对象。
       识别方法： 命令模式可以通过抽象或接口类型 （发送者）中的行为方法来识别，该类型调用另一个不同的抽象或接口类型（接收者） 实现中的方法，该实现则是在创建时由命令模式的实现封装。
  ### 理论：
    1、果你需要通过操作来参数化对象，可使用命令模式。
    2、如果你想要将操作放入队列中、操作的执行或者远程执行操作， 可使用命令模式。
    3、如果你想要实现操作回滚功能，可使用命令模式。

 ### 用法
     testDelayOperationCmd()
 */

//===----------------------------------------------------------------------===//
//                              Command
//===----------------------------------------------------------------------===//
class DelayedOperation: Operation {
    private var delay: TimeInterval

    init(_ delay: TimeInterval = 0) {
        self.delay = delay
    }

    override var isExecuting: Bool {
        get {
            return _execution
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _execution = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _execution: Bool = false

    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    private var _finished: Bool = false

    override func start() {
        guard delay > 0 else {
            _start()
            return
        }

        let deadline = DispatchTime.now() + delay
        DispatchQueue(label: "").asyncAfter(deadline: deadline) {
            self._start()
        }
    }

    private func _start() {
        guard !isCancelled else {
            fwDebugPrint("\(self): operation is canceled")
            isFinished = true
            return
        }

        isExecuting = true
        main()
        isExecuting = false
        isFinished = true
    }
}

class WindowOperation: DelayedOperation {
    override func main() {
        fwDebugPrint("\(self): Windows are closed via HomeKit.")
    }

    override var description: String {
        return "WindowOperation"
    }
}

class DoorOperation: DelayedOperation {
    override func main() {
        fwDebugPrint("\(self): Doors are closed via HomeKit.")
    }

    override var description: String {
        return "DoorOperation"
    }
}

class TaxiOperation: DelayedOperation {
    override func main() {
        fwDebugPrint("\(self): Taxi is ordered via Uber")
    }

    override var description: String {
        return "TaxiOperation"
    }
}

//===----------------------------------------------------------------------===//
//                              Invoker
//===----------------------------------------------------------------------===//
class SiriShortcuts {
    static let shared = SiriShortcuts()
    private lazy var queue = OperationQueue()

    private init() {}

    enum Action: String {
        case leaveHome
        case leaveWork
    }

    func perform(_ action: Action, delay: TimeInterval = 0) {
        fwDebugPrint("Siri: performing \(action)-action\n")
        switch action {
        case .leaveHome:
            add(operation: WindowOperation(delay))
            add(operation: DoorOperation(delay))
        case .leaveWork:
            add(operation: TaxiOperation(delay))
        }
    }

    func cancel(_ action: Action) {
        fwDebugPrint("Siri: canceling \(action)-action\n")
        switch action {
        case .leaveHome:
            cancelOperation(with: WindowOperation.self)
            cancelOperation(with: DoorOperation.self)
        case .leaveWork:
            cancelOperation(with: TaxiOperation.self)
        }
    }

    private func cancelOperation(with operationType: Operation.Type) {
        queue.operations.filter { operation in
            type(of: operation) == operationType
        }.forEach { $0.cancel() }
    }

    private func add(operation: Operation) {
        queue.addOperation(operation)
    }
}
