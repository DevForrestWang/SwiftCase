//
//===--- SCUIEventViewVC.swift - Defines the SCUIEventViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by forrestm on 2021/10/7.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information:
// https://juejin.cn/post/6959479035273412645
// https://itisjoe.gitbooks.io/swiftgo/content/uikit/uigesturerecognizer.html
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

@objc(SCUIEventViewVCDelegate)
public protocol SCUIEventViewVCDelegate: NSObjectProtocol {
    func delecageMethod() -> Void
}

class SCUIEventViewVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            SC.log("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    @objc public func closureTest(_ closure: @escaping () -> Void) {
        myClosure = closure
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc func singleTap(recognizer: UITapGestureRecognizer) {
        fwShowToast("single tap")
        findFingerPositon(recognizer: recognizer)

        // 回调执行
        if let tmpClosure = myClosure {
            tmpClosure()
        }

        if let tmpDelegate = delegate {
            tmpDelegate.delecageMethod()
        }
    }

    @objc func longPress(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .began {
            fwShowToast("start long press")
        } else if recognizer.state == .ended {
            fwShowToast("end long press")
        }
    }

    @objc func swipeAction(recognizer: UISwipeGestureRecognizer) {
        let point = swipeView.center
        if recognizer.direction == .up {
            SC.log("Go Up")
            if point.y >= 150 {
                swipeView.center = CGPoint(
                    x: swipeView.center.x,
                    y: swipeView.center.y - 100
                )
            } else {
                swipeView.center = CGPoint(x: swipeView.center.x, y: 50)
            }
        } else if recognizer.direction == .left {
            SC.log("Go Left")
            if point.x >= 150 {
                swipeView.center = CGPoint(
                    x: swipeView.center.x - 100,
                    y: swipeView.center.y
                )
            } else {
                swipeView.center = CGPoint(x: 50, y: swipeView.center.y)
            }
        } else if recognizer.direction == .down {
            SC.log("Go Down")
            if point.y <= fullSize.height - 150 {
                swipeView.center = CGPoint(
                    x: swipeView.center.x,
                    y: swipeView.center.y + 100
                )
            } else {
                swipeView.center = CGPoint(x: swipeView.center.x, y: fullSize.height - 50)
            }
        } else if recognizer.direction == .right {
            SC.log("Go Right")
            if point.x <= fullSize.width - 150 {
                swipeView.center = CGPoint(
                    x: swipeView.center.x + 100,
                    y: swipeView.center.y
                )
            } else {
                swipeView.center = CGPoint(x: fullSize.width - 50, y: swipeView.center.y)
            }
        }
    }

    @objc func panAction(recognizer: UISwipeGestureRecognizer) {
        let point = recognizer.location(in: view)
        panView.center = point
    }

    @objc func pinchAction(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            SC.log("Began to zoom")
        } else if recognizer.state == .changed {
            let frm = pinchImageView.frame
            let w = frm.width
            let h = frm.height

            // 缩放比例
            let scale = recognizer.scale

            // 縮放比例的限制為 0.5 ~ 2 倍
            if w * scale > 100, w * scale < 400 {
                // 缩放时回复未旋转时状态
                pinchImageView.transform = CGAffineTransform(rotationAngle: 0)

                var tWidth = w * scale
                if w * scale < h * scale {
                    tWidth = h * scale
                }
                pinchImageView.frame = CGRect(x: (gScreenWidth - tWidth) / 2,
                                              y: (gScreenHeight - tWidth) / 2,
                                              width: tWidth, height: tWidth)
                SC.log("pinchImage:\(pinchImageView.frame), tWidth:\(tWidth)")
            }
        } else if recognizer.state == .ended {
            SC.log("End to zoom")
        }
    }

    @objc func rotationAction(recognizer: UIRotationGestureRecognizer) {
        // 弧度
        let radian = recognizer.rotation
        // 旋转的弧度转换为角度
        let angle = radian * (180 / CGFloat(Float.pi))

        pinchImageView.transform = CGAffineTransform(rotationAngle: radian)
        SC.log("Rotation angle： \(angle)")
    }

    // MARK: - Private

    private func findFingerPositon(recognizer: UITapGestureRecognizer) {
        let number = recognizer.numberOfTouches
        for i in 0 ..< number {
            let point = recognizer.location(ofTouch: i, in: recognizer.view)
            SC.log("The position of the \(i + 1) finger：\(NSCoder.string(for: point))")
        }
    }

    private func addSwipeGesture() {
        // 滑动
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipeUp)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    // MARK: - Touch event

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.tapCount == 2 {
                view.backgroundColor = .white
            } else if t.tapCount == 1 {
                view.backgroundColor = .cyan
            }

            SC.log("Event begin")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch: AnyObject in touches {
            let _: UITouch = touch as! UITouch
            // yxc_debugPrint(t.location(in: view))
        }
    }

    // 两点触摸时，计算两点间的距离，以及角度
    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        if touches.count == 2 {
            // 获取触摸点
            let first = (touches as NSSet).allObjects[0] as! UITouch
            let second = (touches as NSSet).allObjects[1] as! UITouch

            // 获取触摸点坐标
            let firstPoint = first.location(in: view)
            let secondPoint = second.location(in: view)

            // 计算两点间的距离
            let deltaX = secondPoint.x - firstPoint.x
            let deltaY = secondPoint.y - firstPoint.y
            let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
            SC.log("distance: \(String(format: "%.2f", distance))")

            // 计算两点间的角度
            let height = secondPoint.y - firstPoint.y
            let width = firstPoint.x - secondPoint.x
            let rads = atan(height / width)
            let degrees = 180.0 * Double(rads) / .pi
            SC.log("Degress: \(String(format: "%.2f", degrees))")
        }
    }

    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        SC.log("Event canceled!")
    }

    // MARK: - UI

    func setupUI() {
        title = "Event"

        // 支持多点触摸, 默认不支持
        view.isMultipleTouchEnabled = true

        view.addSubview(singleView)
        // 单击
        let singleFinger = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        // 几根手指触发
        singleFinger.numberOfTapsRequired = 1
        // 点击次数
        singleFinger.numberOfTouchesRequired = 1
        singleView.addGestureRecognizer(singleFinger)

        if myClosure != nil {
            singleView.text = "Click Closure"
            singleView.font = .systemFont(ofSize: 14)
        } else if delegate != nil {
            singleView.text = "Click Delegate"
            singleView.font = .systemFont(ofSize: 14)
        }

        view.addSubview(longPressView)
        // 长按
        let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressView.addGestureRecognizer(longPressGest)

        view.addSubview(swipeView)
        addSwipeGesture()

        view.addSubview(panView)
        // 拖拽
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        pan.minimumNumberOfTouches = 3
        pan.maximumNumberOfTouches = 3
        view.addGestureRecognizer(pan)

        // 旋转
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationAction))
        view.addGestureRecognizer(rotation)

        pinchImageView.frame = CGRect(x: (gScreenWidth - 200) / 2, y: (gScreenHeight - 200) / 2,
                                      width: 200, height: 200)
        view.addSubview(pinchImageView)
        // 缩放
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        view.addGestureRecognizer(pinch)
    }

    // MARK: - Constraints

    func setupConstraints() {
        singleView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
            make.top.equalTo(20)
            make.left.equalTo(20)
        }

        longPressView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
            make.top.equalTo(20)
            make.left.equalTo(singleView.snp.right).offset(20)
        }

        swipeView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
            make.top.equalTo(20)
            make.left.equalTo(longPressView.snp.right).offset(20)
        }

        panView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
            make.top.equalTo(singleView.snp.bottom).offset(20)
            make.left.equalTo(20)
        }
    }

    // MARK: - Property

    var myClosure: (() -> Void)?
    @objc public weak var delegate: SCUIEventViewVCDelegate?

    // 屏幕尺寸
    var fullSize = UIScreen.main.bounds.size

    let singleView = UILabel().then {
        $0.backgroundColor = UIColor.hexColor(0xF06663)
        $0.textColor = .white
        $0.text = "Click"
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }

    let longPressView = UILabel().then {
        $0.backgroundColor = UIColor.hexColor(0xCE8A00)
        $0.textColor = .white
        $0.text = "Long press"
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }

    let swipeView = UILabel().then {
        $0.backgroundColor = .blue
        $0.textColor = .white
        $0.text = "Swipe"
        $0.textAlignment = .center
    }

    let panView = UILabel().then {
        $0.backgroundColor = .orange
        $0.textColor = .white
        $0.text = "Three drag"
        $0.textAlignment = .center
    }

    let pinchImageView = UIImageView().then {
        $0.image = UIImage(named: "manor.jpg")
    }
}
