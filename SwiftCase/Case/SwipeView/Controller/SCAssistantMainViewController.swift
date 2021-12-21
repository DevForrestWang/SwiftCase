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

class SCAssistantMainViewController: UIViewController {
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

    // MARK: - IBActions

    // MARK: - Private

    @objc func swipAction(recognizer: UIPanGestureRecognizer) {
        // 1. Monitor the direction of view
        upDownProgress = 0
        if recognizer.direction == .up {
            print("up")
            upDownProgress = 1
        } else if recognizer.direction == .down {
            print("down")
            upDownProgress = -1
        } else if recognizer.direction == .left {
            print("left")
        } else if recognizer.direction == .right {
            print("right")
        }

        // 3. Gesture states
        switch recognizer.state {
        // 3.1 Gesture states began to check the pan direction the user initiated
        case .began:
            print("began")

        // 3.2 Gesture state changed to Translate the view according to the user pan gesture
        case .changed:
            if upDownProgress == 1 {
                print("up")
            } else if upDownProgress == -1 {
                print("down")
            }
        // 3.3 Gesture state end to finish the animation
        default:
            print("defaule")
        }
    }

    // MARK: - UI

    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(upView)
        view.addSubview(bottomView)
        view.addSubview(astCarouseView)

        // 上下面页面隐藏，滑动时才显示
        upView.isHidden = true
        bottomView.isHidden = true

        panGR = UIPanGestureRecognizer(target: self, action: #selector(swipAction))
        view.addGestureRecognizer(panGR)
    }

    // MARK: - Constraints

    func setupConstraints() {
        astCarouseView.snp.makeConstraints { maker in
            maker.top.equalTo(64)
            maker.left.right.equalTo(0)
            maker.height.equalTo(UIScreen.main.bounds.height - 74)
        }
    }

    // MARK: - Property

    var panGR: UIPanGestureRecognizer!
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
