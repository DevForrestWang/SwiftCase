//
//===--- SCSwipeViewController.swift - Defines the SCSwipeViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/14.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCSwipeViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc func pan(recognizer: UIPanGestureRecognizer) {
        // 1. Monitor the translation of view
        let translation = recognizer.translation(in: nil)
//        let progressX = (translation.x / 2) / view.bounds.width
//        let progressY = (translation.y / 2) / view.bounds.height

        let currentTouchPoint = recognizer.location(in: view)
//        print("---t.y:\(translation.y), cur.y:\(currentTouchPoint.y), deltaY:\(currentTouchPoint.y - translation.y)")
//        let previousTouchPoint = recognizer.previousLocation(in:view)
//        let deltaY = currentTouchPoint.y - previousTouchPoint.y

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

            let currentPos = CGPoint(x: view.center.x, y: translation.y + view.center.y)
            let opacity = currentPos.y / (view.bounds.height - 50)

            print("---currentTouchPoint.y:\(currentTouchPoint.y), midTopConstraint:\(midTopConstraint.constant)")

            if upDownProgress == 1 {
                print("up y:\(currentPos.y), opacity:\(opacity)")

                upView.layer.opacity = Float(opacity)
//                middleView.layer.opacity = Float(opacity)

//                middleView.layer.transform = CATransform3DMakeTranslation(0, currentPos.y + 50, 0)
                midBottomConstraint.constant = currentTouchPoint.y

            } else if upDownProgress == -1 {
                print("down y:\(currentPos.y), opacity:\(opacity)")
                upView.layer.opacity = Float(opacity)
//                middleView.layer.opacity = Float(opacity)

//                middleView.layer.transform = CATransform3DMakeTranslation(0, currentPos.y + 50, 0)

                midTopConstraint.constant = currentTouchPoint.y

//                middleView.frame = CGRect(x: middleView.frame.origin.x, y: currentPos.y,
//                                          width: middleView.frame.size.width, height: middleView.frame.size.height - currentPos.y)
//                print("middleView.frame: \(middleView.frame)")

//                let transformSclae = CATransform3DMakeScale(1, opacity, 1)
//                middleView.layer.transform = transformSclae
            }

         //            let currentPos2 = CGPoint(x: translation.x + view.center.x, y: view.center.y)
         //            print("currentPos2:\(currentPos2)")

        // 3.3 Gesture state end to finish the animation
        default:
            print("defaule")
        }
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "Swipe"
        view.backgroundColor = .white

        view.addSubview(upView)
        view.addSubview(middleView)
        view.addSubview(downView)

        // upView.layer.opacity = 0
        // middleView.layer.opacity = 0
        downView.layer.opacity = 0

        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        middleView.addGestureRecognizer(panGR)
    }

    // MARK: - Constraints

    func setupConstraints() {
        upView.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-100)
            make.width.equalToSuperview().offset(-40)
            make.center.equalToSuperview()
        }

        // 添加约束 autolayout
        midTopConstraint = middleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        midTopConstraint.isActive = true
        middleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        midBottomConstraint = middleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        midBottomConstraint.isActive = true
        middleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        downView.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-100)
            make.width.equalToSuperview().offset(-40)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Property

    var panGR: UIPanGestureRecognizer!
    var upDownProgress: Int = 0
    weak var midTopConstraint: NSLayoutConstraint!
    weak var midBottomConstraint: NSLayoutConstraint!

    let upView = UIView().then {
        $0.backgroundColor = .cyan
    }

    let middleView = UIView().then {
        $0.backgroundColor = .orange
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let downView = UIView().then {
        $0.backgroundColor = .green
    }
}
