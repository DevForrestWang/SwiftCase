//
//  UILableExtension.swift
//  GYCompany
//
//  Created by wfd on 2022/5/14.
//  Copyright © 2022 归一. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 改变行间距
    func changeLineSpace(space: CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }

    /// 改变字间距
    func changeWordSpace(space: CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }

    /// 改变字间距和行间距
    func changeSpace(lineSpace: CGFloat, wordSpace: CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }
}
