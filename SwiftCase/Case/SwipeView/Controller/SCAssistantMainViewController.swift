//
//===--- SCAssistantMainViewController.swift - Defines the SCAssistantMainViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCAssistantMainViewController: UIViewController, SCAssimtantCarouseViewProtocol {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - SCAssimtantCarouseViewProtocol

    func currentView(viewType: SCAssimationViewType) {
        print("type: \(viewType)")
    }

    // MARK: - IBActions

    // MARK: - Private

    @objc func upSwipAction(recognizer: UIPanGestureRecognizer) {
        upDownProgress = 0
        if recognizer.direction == .up {
            upDownProgress = 1
        } else if recognizer.direction == .down {
            upDownProgress = -1
        }

        if recognizer.state == .ended {
            if upDownProgress == 1 {
                print("up up")
                upView.isHidden = true
                astCarouseView.isHidden = false
                bottomView.isHidden = true
            }
        }
    }

    @objc func middleSwipAction(recognizer: UIPanGestureRecognizer) {
        upDownProgress = 0
        if recognizer.direction == .up {
            upDownProgress = 1
        } else if recognizer.direction == .down {
            upDownProgress = -1
        }

        if recognizer.state == .ended {
            if upDownProgress == 1 {
                print("up")
                upView.isHidden = true
                astCarouseView.isHidden = true
                bottomView.isHidden = false
            } else if upDownProgress == -1 {
                print("down")
                upView.isHidden = false
                astCarouseView.isHidden = true
                bottomView.isHidden = true
            }
        }
    }

    @objc func bottomSwipAction(recognizer: UIPanGestureRecognizer) {
        upDownProgress = 0
        if recognizer.direction == .up {
            upDownProgress = 1
        } else if recognizer.direction == .down {
            upDownProgress = -1
        }

        if recognizer.state == .ended {
            if upDownProgress == -1 {
                print("down")
                upView.isHidden = true
                astCarouseView.isHidden = false
                bottomView.isHidden = true
            }
        }
    }

    // MARK: - UI

    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(upView)
        view.addSubview(bottomView)
        view.addSubview(astCarouseView)
        astCarouseView.astCarouseViewDelegate = self

        // 上下面页面隐藏，滑动时才显示
        upView.isHidden = true
        bottomView.isHidden = true

        let upPanGR = UIPanGestureRecognizer(target: self, action: #selector(upSwipAction))
        upView.addGestureRecognizer(upPanGR)

        let middlePanGR = UIPanGestureRecognizer(target: self, action: #selector(middleSwipAction))
        astCarouseView.addGestureRecognizer(middlePanGR)

        let bottomPanGR = UIPanGestureRecognizer(target: self, action: #selector(bottomSwipAction))
        bottomView.addGestureRecognizer(bottomPanGR)
    }

    // MARK: - Constraints

    func setupConstraints() {
        upView.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height - 74)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height - 74)
        }

        astCarouseView.snp.makeConstraints { maker in
            maker.top.equalTo(64)
            maker.left.right.equalTo(0)
            maker.height.equalTo(UIScreen.main.bounds.height - 74)
        }
    }

    // MARK: - Property

    var upDownProgress: Int = 0
    let astCarouseView = SCAssimtantCarouseView().then {
        $0.backgroundColor = .white
    }

    let upView = SCUpCarouseView().then {
        $0.backgroundColor = .yellow
    }

    let bottomView = SCBottomCarouseView().then {
        $0.backgroundColor = .brown
    }
}
