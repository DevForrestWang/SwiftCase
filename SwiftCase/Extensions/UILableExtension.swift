//
//===--- UILableExtension.swift - Defines the UILableExtension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

public extension UILabel {
    /// 改变行间距
    func changeLineSpace(space: CGFloat) {
        guard let text = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        attributedText = attributedString
        sizeToFit()
    }

    /// 改变字间距
    func changeWordSpace(space: CGFloat) {
        guard let text = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        attributedText = attributedString
        sizeToFit()
    }

    /// 改变字间距和行间距
    func changeSpace(lineSpace: CGFloat, wordSpace: CGFloat) {
        guard let text = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        attributedText = attributedString
        sizeToFit()
    }
}
