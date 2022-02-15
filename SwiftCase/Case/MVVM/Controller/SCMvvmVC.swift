//
//===--- SCMvvmVC.swift - Defines the SCMvvmVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

/*
 RxSwift + MVVM 实战
 M 职责：数据的归档、保存:Track.swift - 数据模型
 V 职责：与用户交互的界面: LoginView.swift - 与用户交互的界面
 VM 职责：业务逻辑的处理：SignUpViewModel.swift - 用户登录校验的业务逻辑
 Controller 职责：V 与 VM 数据绑定：ViewController.swift- 进行数据的绑定

 本示例演示场景：
 1、网络获取数据在界面的更新，通过 SignUpViewModel.tracks 与 LoginView.tracks 绑定
 2、用户输入数据的校验，通过 SignUpViewModel.Input(username,password) 进行数据绑定，outputs反馈校验结果
 outputs.validatedUsername
        .validatedPassword
        .isLoginAllowed
 3、通过 confirmBtn.rx.tap.subscribe 演示界面事件的响应
 loginView.confirmBtn.rx.tap.subscribe(onNext: { [weak self] in
 })

 使用到第三方库：'RxSwift'、'RxCocoa'、'Then'、"SnapKit"

 - 参考资料：
   - [An Introduction to RxSwift + MVVM](https://betterprogramming.pub/an-introduction-to-rxswift-mvvm-3a2868d3b2c5)
   - [kmpnz/PracticalRxSwift](https://github.com/kmpnz/PracticalRxSwift)
   - [RxExample/UsingVanillaObservables/](https://github.com/ReactiveX/RxSwift/tree/main/RxExample/RxExample/Examples/GitHubSignup/UsingVanillaObservables)
   - [實用的MVVM和RxSwift](https://codertw.com/程式語言/744310/)
 */

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SCMvvmVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = nil
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func bindViewModel() {
        // 说明：1
        let username = loginView.userTextField.rx.text.orEmpty.asObservable()
        let password = loginView.passwordTextField.rx.text.orEmpty.asObservable()
        let outputs = viewModel.configure(input: SignUpViewModel.Input(username: username, password: password))

        // 说明：2
        viewModel.tracks.observe(on: MainScheduler.instance).bind(to: loginView.tracks).disposed(by: disposeBag)
        
        // 说明：3
        outputs.validatedUsername.bind(to: loginView.userOutletLable.rx.validationResult).disposed(by: disposeBag)
        outputs.validatedPassword.bind(to: loginView.passwordOutletLable.rx.validationResult).disposed(by: disposeBag)

        // 说明：4
        outputs.isLoginAllowed.subscribe(onNext: { [weak self] valid in
            self?.loginView.confirmBtn.isEnabled = valid
            self?.loginView.confirmBtn.alpha = valid ? 1.0 : 0.5

            if !valid {
                self?.viewModel.clearTrackData()
            }
        }).disposed(by: disposeBag)

        // 说明：5
        loginView.confirmBtn.rx.tap.subscribe(onNext: { [weak self] in
            print("submit")
            self?.viewModel.loadDataFromNewWork()
        }).disposed(by: disposeBag)
    }

    // MARK: - UI

    private func setupUI() {
        title = "MVVM"
        view.backgroundColor = .white

        view.addSubview(loginView)
        bindViewModel()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    private var disposeBag: DisposeBag! = DisposeBag()

    private var viewModel = SignUpViewModel()

    private let loginView = LoginView()
}
