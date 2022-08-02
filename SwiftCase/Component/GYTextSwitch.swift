//
//===--- GYTextSwitch.swift - Defines the GYTextSwitch class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2022/6/14.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class GYTextSwitch: UIView {
    // MARK: - public

    public init(size: CGSize, isOn: Bool, onColor: UIColor, offColor: UIColor, onName: String, offName: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        clipsToBounds = true
        self.isOn = isOn
        self.onColor = onColor
        self.offColor = offColor

        let fWidth = frame.width
        let fHeight = frame.height
        leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fWidth * 0.5, height: fHeight))
        leftLabel.text = offName
        leftLabel.font = .boldSystemFont(ofSize: 12)
        leftLabel.textAlignment = .right
        leftLabel.adjustsFontSizeToFitWidth = true
        addSubview(leftLabel)

        rightLabel = UILabel(frame: CGRect(x: fWidth * 0.5, y: 0, width: fWidth * 0.5, height: fHeight))
        rightLabel.text = onName
        rightLabel.font = .boldSystemFont(ofSize: 12)
        rightLabel.textAlignment = .left
        rightLabel.adjustsFontSizeToFitWidth = true
        addSubview(rightLabel)

        var selectColor = offColor
        var xPoint: CGFloat = 1
        if isOn {
            selectColor = onColor
            xPoint = CGFloat(fWidth - fHeight + 1)
        }

        let swithHeight = fHeight - 4
        imageSwitch = UIImageView(frame: CGRect(x: xPoint, y: 2, width: swithHeight, height: swithHeight))
        addSubview(imageSwitch)
        imageSwitch.backgroundColor = selectColor
        imageSwitch.layer.cornerRadius = swithHeight / 2

        layer.borderWidth = 1
        layer.borderColor = selectColor.cgColor
        layer.cornerRadius = fHeight / 2

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true

        changeState(isOpen: isOn)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Private

    @objc private func handleTap() {
        isOn = !isOn
        if let tmpClourse = gyTextSwitchClosure {
            tmpClourse(isOn)
        }
        animationSwitcher()
    }

    private func animationSwitcher() {
        isUserInteractionEnabled = false
        if isOn {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.imageSwitch.frame.origin = CGPoint(x: self.frame.width - self.frame.height + 1, y: 2)
                self.changeState(isOpen: true)
            }, completion: { _ in
            })

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.imageSwitch.frame.origin = CGPoint(x: 2, y: 2)
                self.changeState(isOpen: false)
            }, completion: { _ in
            })
        }
        isUserInteractionEnabled = true
    }

    private func changeState(isOpen: Bool) {
        if isOpen {
            imageSwitch.backgroundColor = offColor
            layer.borderColor = offColor?.cgColor
            leftLabel.textColor = offColor
        } else {
            imageSwitch.backgroundColor = onColor
            layer.borderColor = onColor?.cgColor
            rightLabel.textColor = onColor
        }

        leftLabel.isHidden = !isOpen
        rightLabel.isHidden = !leftLabel.isHidden
    }

    // MARK: - Property

    public var gyTextSwitchClosure: ((_ isOn: Bool) -> Void)?

    var imageSwitch: UIImageView!
    var leftLabel: UILabel!
    var rightLabel: UILabel!

    var onColor: UIColor?
    var offColor: UIColor?

    private(set) var isOn: Bool!
}
