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
//
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
    /// 参考：https://github.com/Lorwy/RxSwiftExample
    private func obserableFun() {
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
                print("data: \(data)")
            case let .error(error):
                print("error: \(error)")
            case .completed:
                print("Completed")
            }
        }
        observable.subscribe(observer).disposed(by: disposeBag)

        // subscribe方法, 把 event 进行分类
        observable.subscribe { element in
            print("onNext: \(element)")
        } onError: { error in
            print("error: \(error)")
        } onCompleted: {
            print("Completed")
        } onDisposed: {
            print("Disposed")
        }.disposed(by: disposeBag)
    }

    /// 时间富文本
    private func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d", arguments: [(ms / 600) % 600, (ms % 600) / 10, ms % 10])
        print("Time: \(string)")
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
