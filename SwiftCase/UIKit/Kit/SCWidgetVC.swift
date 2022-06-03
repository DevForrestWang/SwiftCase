//
//===--- SCUISwitchVC.swift - Defines the SCUISwitchVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/30.
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

class SCWidgetVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 进行内存释放
        disposeBag = nil
        yxc_debugPrint("The free disposeBag.")
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "UISwich"
        view.backgroundColor = .white

        view.addSubview(switch01)
        switch01.rx.isOn.subscribe(onNext: { flag in
            showToast("switch: \(flag)")
        }).disposed(by: disposeBag)

        view.addSubview(mySlider)
        // 绑定事件
        mySlider.rx.value.subscribe(onNext: { value in
            yxc_debugPrint("slider value: \(Int(value))")
            self.sliderLable.alpha = CGFloat((self.mySlider.maximumValue - value) / self.mySlider.maximumValue)
        }).disposed(by: disposeBag)

        view.addSubview(sliderLable)
        // 绑定到控件上
        mySlider.rx.value.map {
            "\(Int($0))"
        }.bind(to: sliderLable.rx.text).disposed(by: disposeBag)

        // 手势添加点击事件
        view.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            let point = recognizer.location(in: recognizer.view)
            // showToast("click: x: \(point.x), y: \(point.y)")
            self?.sliderLable.text = "click: x: \(point.x), y: \(point.y)"
        }).disposed(by: disposeBag)
    }

    // MARK: - Constraints

    func setupConstraints() {
        switch01.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }

        mySlider.snp.makeConstraints { make in
            make.top.equalTo(switch01.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        sliderLable.snp.makeConstraints { make in
            make.top.equalTo(mySlider.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Property

    private var disposeBag: DisposeBag! = DisposeBag()

    private let switch01 = UISwitch().then {
        // on 颜色
        $0.onTintColor = .green
    }

    private let mySlider = UISlider().then {
        // 底色
        $0.backgroundColor = .cyan
        // 滑块未填充的颜色
        $0.maximumTrackTintColor = .orange
        // 已填充的颜色
        $0.minimumTrackTintColor = .purple
        // 滑块按钮颜色
        $0.thumbTintColor = .brown

        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.value = 10
        $0.isContinuous = true
    }

    private let sliderLable = UILabel().then {
        $0.backgroundColor = .cyan
        $0.text = ""
        $0.textColor = .orange
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 17)
    }

    private let tap = UITapGestureRecognizer().then {
        $0.numberOfTapsRequired = 1
        $0.numberOfTouchesRequired = 1
    }
}
