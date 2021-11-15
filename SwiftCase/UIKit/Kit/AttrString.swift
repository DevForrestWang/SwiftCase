//
//===--- AttrString.swift - Defines the AttrString class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/15.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://swift.gg/2019/10/18/swift5-stringinterpolation-part2/
//
//===----------------------------------------------------------------------===//

import Foundation

struct AttrString {
    let attributedString: NSAttributedString
}

extension AttrString: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension AttrString: CustomStringConvertible {
    var description: String {
        return String(describing: attributedString)
    }
}

extension AttrString: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }

    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString

        init(literalCapacity _: Int, interpolationCount _: Int) {
            attributedString = NSMutableAttributedString()
        }

        func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            attributedString.append(astr)
        }

        func appendInterpolation(_ string: String, attributes: [NSAttributedString.Key: Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            attributedString.append(astr)
        }
    }
}

extension AttrString {
    struct Style {
        let attributes: [NSAttributedString.Key: Any]
        static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }

        static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor: color])
        }

        static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor: color])
        }

        static func link(_ link: String) -> Style {
            return .link(URL(string: link)!)
        }

        static func link(_ link: URL) -> Style {
            return Style(attributes: [.link: link])
        }

        static let oblique = Style(attributes: [.obliqueness: 0.1])

        static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue,
            ])
        }

        static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.alignment = alignment
            return Style(attributes: [.paragraphStyle: ps])
        }
    }
}

extension AttrString.StringInterpolation {
    func appendInterpolation(_ string: String, _ style: AttrString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        attributedString.append(astr)
    }
}

extension AttrString.StringInterpolation {
    func appendInterpolation(image: UIImage, scale: CGFloat = 1.0) {
        let attachment = NSTextAttachment()
        if let cgImage = image.cgImage {
            attachment.image = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
            attributedString.append(NSAttributedString(attachment: attachment))
        }
    }
}

extension AttrString.StringInterpolation {
    func appendInterpolation(wrap string: AttrString, _ style: AttrString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex ..< mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        attributedString.append(mas)
    }
}
