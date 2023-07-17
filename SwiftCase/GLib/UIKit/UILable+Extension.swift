//
//===--- UILable+Extension.swift - Defines the UILable+Extension class ----------===//
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
    convenience init(text: String?,
                     textColor: UIColor?,
                     textFont: UIFont?,
                     textAlignment: NSTextAlignment = .left,
                     numberLines: Int = 1)
    {
        self.init()
        self.text = text
        self.textColor = textColor ?? UIColor.black
        font = textFont ?? UIFont.systemFont(ofSize: 17.0)
        self.textAlignment = textAlignment
        numberOfLines = numberLines
        clipsToBounds = false
    }

    /// 预计高度
    func pre_h(maxWidth: CGFloat, maxLine: Int = 0) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.backgroundColor = backgroundColor
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = maxLine
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    /// 预计宽度
    func pre_w(maxHeight: CGFloat, maxLine: Int = 0) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
        label.numberOfLines = 0
        label.backgroundColor = backgroundColor
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = maxLine
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.width
    }

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
