//
//===--- SCRxSwiftAndRxCocoaVC.swift - Defines the SCRxSwiftAndRxCocoaVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/22.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// [RxSwift中文文档](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/)
// [Lorwy/RxSwiftExample](https://github.com/Lorwy/RxSwiftExample)
//===----------------------------------------------------------------------===//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SCRxSwiftAndRxCocoaVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Off timer
        disposeBag = nil
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    /// 可观察序列Observable的创建方法
    private func obserableFun() {
        printEnter(message: "Observable")

        let observable = Observable<String>.create { observer -> Disposable in
            // 对订阅者发出了.next事件
            observer.onNext("next string")
            // 对订阅者发出了.completed事件
            observer.onCompleted()
            // 因为一个订阅行为会有一个Disposable类型的返回值
            return Disposables.create()
        }

        // 使用 AnyObserver 创建观察者
        let observer: AnyObserver<String> = AnyObserver { event in
            switch event {
            case let .next(data):
                yxc_debugPrint("data: \(data)")
            case let .error(error):
                yxc_debugPrint("error: \(error)")
            case .completed:
                yxc_debugPrint("Completed")
            }
        }
        observable.subscribe(observer).disposed(by: disposeBag)

        // subscribe方法, 把 event 进行分类
        observable.subscribe { element in
            yxc_debugPrint("onNext: \(element)")
        } onError: { error in
            yxc_debugPrint("error: \(error)")
        } onCompleted: {
            yxc_debugPrint("Completed")
        } onDisposed: {
            yxc_debugPrint("Disposed")
        }.disposed(by: disposeBag)
    }

    /// BehaviorRelay 使用
    private func behaviorRelayTest() {
        printEnter(message: "BehaviorRelay")

        let relay = BehaviorRelay<String>(value: "1")
        relay.subscribe {
            yxc_debugPrint("Event:", $0)
        }.disposed(by: disposeBag)

        relay.accept("2")
        relay.accept("3")
    }

    private func transformingObservables() {
        printEnter(message: "Transforming Observables")

        let s1 = BehaviorSubject(value: "A")
        let s2 = BehaviorSubject(value: "1")

        let relay = BehaviorRelay<BehaviorSubject>(value: s1)
        relay.flatMap { $0 }
            .subscribe(onNext: {
                yxc_debugPrint($0)
            }).disposed(by: disposeBag)

        s1.onNext("B")

        relay.accept(s2)
        s2.onNext("2")
        s1.onNext("C")
    }

    /// 时间富文本
    private func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d", arguments: [(ms / 600) % 600, (ms % 600) / 10, ms % 10])
        yxc_debugPrint("Time: \(string)")
        let attString = NSMutableAttributedString(string: string)
        attString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, 5))
        attString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 5))
        attString.addAttribute(.backgroundColor, value: UIColor.orange, range: NSMakeRange(0, 5))

        return attString
    }

    // MARK: - UI

    func setupUI() {
        title = "RxSwift and RxCocoa"
        view.backgroundColor = .white

        view.addSubview(rxLable)
        // 富文本
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map(
            formatTimeInterval(ms:)
        ).bind(to: rxLable.rx.attributedText).disposed(by: disposeBag)

        obserableFun()
        behaviorRelayTest()
        transformingObservables()
    }

    // MARK: - Constraints

    func setupConstraints() {
        rxLable.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    private var disposeBag: DisposeBag! = DisposeBag()
    private let rxLable = UILabel().then {
        $0.text = "Time"
        $0.textAlignment = .center
    }
}
