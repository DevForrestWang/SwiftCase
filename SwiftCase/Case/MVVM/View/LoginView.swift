//
//===--- LoginView.swift - Defines the LoginView class ----------===//
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

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class LoginView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func bindViewModel() {
        // 点击关闭输入框
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            self?.endEditing(true)
        }).disposed(by: disposeBag)
        addGestureRecognizer(tap)

        // 绑定cell数据
        tracks.bind(to: tracksTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, element, cell in
            cell.textLabel?.text = element.name
        }.disposed(by: disposeBag)

        // 获取选中项的内容
        tracksTableView.rx.modelSelected(Track.self).subscribe(onNext: { item in
            print("select: \(String(describing: item.name))")
        }).disposed(by: disposeBag)
    }

    // MARK: - UI

    private func setupUI() {
        addSubview(userTextField)
        addSubview(userOutletLable)
        addSubview(passwordTextField)
        addSubview(passwordOutletLable)
        addSubview(confirmBtn)

        tracksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        addSubview(tracksTableView)

        bindViewModel()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        userTextField.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        userOutletLable.snp.makeConstraints { make in
            make.top.equalTo(userTextField.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(userOutletLable.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        passwordOutletLable.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordOutletLable.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        tracksTableView.snp.makeConstraints { make in
            make.top.equalTo(confirmBtn.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    var tracks = PublishSubject<[Track]>()

    private let disposeBag = DisposeBag()

    let userTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .roundedRect

        $0.placeholder = "Please input user name"
        $0.font = .systemFont(ofSize: 16)
    }

    let userOutletLable = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .red
        $0.font = .systemFont(ofSize: 17)
        $0.text = "username validation"
    }

    let passwordTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .roundedRect

        $0.placeholder = "Please input password"
        $0.font = .systemFont(ofSize: 16)
    }

    let passwordOutletLable = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .red
        $0.font = .systemFont(ofSize: 17)
        $0.text = "password validation"
    }

    let confirmBtn = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.27, green: 0.71, blue: 0.94, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.setTitle("Sign Up", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18)
        $0.isEnabled = false
    }

    private let tracksTableView = UITableView().then {
        $0.backgroundColor = .white
    }
}
