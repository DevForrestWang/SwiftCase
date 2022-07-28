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

    @objc private func recordTick(timer _: Timer) {
        circleProgressView.setProgress(currentIndex)
        if currentIndex >= 100 {
            recordtimer?.invalidate()
            return
        }

        currentIndex += Randoms.randomInt(1, 10)
    }

    // MARK: - Private

    private func downLoadImage() {
        let imageURL = "https://cdn.pixabay.com/photo/2021/08/19/12/53/bremen-6557996_960_720.jpg"
        SCUtils.downloadWith(urlStr: imageURL) { [weak self] image in

            guard let saveImage = image else {
                yxc_debugPrint("The image is nil")
                return
            }

            self?.downLoadImagView.image = image
            // 写入相册
            UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(self?.saveImageResult(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc private func saveImageResult(image _: UIImage, didFinishSavingWithError error: NSError?, contextInfo _: AnyObject) {
        if error != nil {
            showToast("图片保存相册失败")
        } else {
            showToast("图片保存相册成功")
        }
    }

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

        view.addSubview(circleProgressView)
        recordtimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(recordTick), userInfo: nil, repeats: true)

        view.addSubview(downLoadImagView)
        downLoadImage()
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

        circleProgressView.snp.makeConstraints { make in
            make.top.equalTo(sliderLable.snp.bottom).offset(20)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }

        downLoadImagView.snp.remakeConstraints { make in
            make.top.equalTo(circleProgressView.snp.bottom).offset(20)
            make.width.height.equalTo(100)
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

    private let circleProgressView = SCircleProgressView()
    private var recordtimer: Timer?
    private var currentIndex = 0

    let downLoadImagView = UIImageView().then {
        $0.image = UIImage(named: "gyhs_bigDefaultImage")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
}
