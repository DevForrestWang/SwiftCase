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

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    /// 可观察序列Observable的创建方法
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

    // MARK: - UI

    func setupUI() {
        title = "RxSwift and RxCocoa"
        view.backgroundColor = .white

        obserableFun()
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property

    private let disposeBag = DisposeBag()
}
