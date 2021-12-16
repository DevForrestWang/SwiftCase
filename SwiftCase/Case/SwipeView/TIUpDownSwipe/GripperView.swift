//
//  GripperView.swift
//  TIUpDownSwipe
//
//  Created by Tomasz Iwaszek on 2/12/19.
//  Copyright © 2019 wachus77. All rights reserved.
//

import UIKit

enum GripperType {
    case caretUp, caretDown
}

class GripperView: UIView {
    private var type: GripperType!

    private let line1Layer = CAShapeLayer()
    private let line2Layer = CAShapeLayer()

    private var p1: CGPath!
    public var p2: CGPath!

    private var gCenter: CGPoint!
    private var gSize: CGFloat!
    private var gOffset: CGPoint!
    private var gHeightRatio: CGFloat!

    private lazy var allLayers: [CAShapeLayer] = {
        [self.line1Layer, self.line2Layer]
    }()

    @IBInspectable public var lineWidth: CGFloat = 3 {
        didSet { setupLayerPaths() }
    }

    @IBInspectable public var strokeColor: UIColor = .white {
        didSet { setupLayerPaths() }
    }

    // MARK: setup views

    func setup(center: CGPoint, size: CGFloat, heightRatio: CGFloat, offset: CGPoint, lineWidth: CGFloat, type: GripperType, minusHeight: CGFloat = 0) {
        gCenter = center
        gSize = size
        gHeightRatio = heightRatio
        gOffset = offset
        self.lineWidth = lineWidth
        self.type = type

        let firstSize = size
        let secondSize: CGFloat = (size / 12) + (type == .caretDown ? -minusHeight : minusHeight)

        var a: CGPoint!
        var b: CGPoint!
        var c: CGPoint!

        switch type {
        case .caretUp:
            a = CGPoint(x: center.x, y: center.y - secondSize)
            b = CGPoint(x: center.x - firstSize, y: center.y + secondSize)
            c = CGPoint(x: center.x + firstSize, y: center.y + secondSize)
        case .caretDown:
            a = CGPoint(x: center.x, y: center.y + secondSize)
            b = CGPoint(x: center.x - firstSize, y: center.y - secondSize)
            c = CGPoint(x: center.x + firstSize, y: center.y - secondSize)
        }

        let gravityCenter = CGPoint(x: (a.x + b.x + c.x) / 3, y: (a.y + b.y + c.y) / 3)
        let offsetFromCenter = CGPoint(x: center.x - gravityCenter.x, y: center.y - gravityCenter.y)

        let p1 = CGMutablePath()

        p1.move(to: CGPoint(x: offsetFromCenter.x + a.x, y: offsetFromCenter.y + a.y))
        p1.addLine(to: CGPoint(x: offsetFromCenter.x + b.x, y: offsetFromCenter.y + b.y))

        let p2 = CGMutablePath()

        p2.move(to: CGPoint(x: offsetFromCenter.x + a.x, y: offsetFromCenter.y + a.y))
        p2.addLine(to: CGPoint(x: offsetFromCenter.x + c.x, y: offsetFromCenter.y + c.y))

        self.p1 = p1
        self.p2 = p2

        for sublayer in allLayers {
            sublayer.removeFromSuperlayer()
        }

        for sublayer in allLayers {
            layer.addSublayer(sublayer)
        }

        setupLayerPaths()
    }

    func setupLayerPaths() {
        for sublayer in allLayers {
            sublayer.fillColor = UIColor.clear.cgColor
            sublayer.anchorPoint = CGPoint(x: 0, y: 0)
            sublayer.lineJoin = CAShapeLayerLineJoin.round
            sublayer.lineCap = CAShapeLayerLineCap.round
            sublayer.contentsScale = layer.contentsScale
            sublayer.path = UIBezierPath().cgPath
            sublayer.lineWidth = lineWidth
            sublayer.strokeColor = strokeColor.cgColor
        }

        line1Layer.path = p1
        line2Layer.path = p2
    }

    // MARK: Animations

    func animate(minusHeight: CGFloat) {
        setup(center: gCenter, size: gSize, heightRatio: gHeightRatio, offset: gOffset, lineWidth: lineWidth, type: type, minusHeight: minusHeight)
    }
}
