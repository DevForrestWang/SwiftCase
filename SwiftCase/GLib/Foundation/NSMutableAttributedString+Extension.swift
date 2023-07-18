//
//  AttributedString.swift
//  AttributedString
//
//  Created by Swift Dev Center on 26/08/18.
//  Copyright © 2018 Swift Dev Center. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }

    func apply(attribute: [NSAttributedString.Key: Any], subString: String) {
        if let range = string.range(of: subString) {
            apply(attribute: attribute, onRange: NSRange(range, in: string))
        }
    }

    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            setAttributes(attribute, range: range)
        }
    }

    /********************* Color Attribute *********************/
    // Apply color on substring
    func apply(color: UIColor, subString: String) {
        if let range = string.range(of: subString) {
            apply(color: color, onRange: NSRange(range, in: string))
        }
    }

    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
        addAttributes([NSAttributedString.Key.foregroundColor: color],
                      range: onRange)
    }

    /********************* Font Attribute *********************/
    // Apply font on substring
    func apply(font: UIFont, subString: String) {
        if let range = string.range(of: subString) {
            apply(font: font, onRange: NSRange(range, in: string))
        }
    }

    // Apply font on given range
    func apply(font: UIFont, onRange: NSRange) {
        addAttributes([NSAttributedString.Key.font: font], range: onRange)
    }

    /********************* Background Color Attribute *********************/
    // Apply background color on substring
    func apply(backgroundColor: UIColor, subString: String) {
        if let range = string.range(of: subString) {
            apply(backgroundColor: backgroundColor, onRange: NSRange(range, in: string))
        }
    }

    // Apply background color on given range
    func apply(backgroundColor: UIColor, onRange: NSRange) {
        addAttributes([NSAttributedString.Key.backgroundColor: backgroundColor],
                      range: onRange)
    }

    /********************* Underline Attribute *********************/
    // Underline string
    func underLine(subString: String) {
        if let range = string.range(of: subString) {
            underLine(onRange: NSRange(range, in: string))
        }
    }

    // Underline string on given range
    func underLine(onRange: NSRange) {
        addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                      range: onRange)
    }

    /********************* Strikethrough Attribute *********************/
    // Apply Strikethrough on substring
    func strikeThrough(thickness: Int, subString: String) {
        if let range = string.range(of: subString) {
            strikeThrough(thickness: thickness, onRange: NSRange(range, in: string))
        }
    }

    // Apply Strikethrough on given range
    func strikeThrough(thickness _: Int, onRange: NSRange) {
        addAttributes([NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue],
                      range: onRange)
    }

    /********************* Stroke Attribute *********************/
    // Apply stroke on substring
    func applyStroke(color: UIColor, thickness: Int, subString: String) {
        if let range = string.range(of: subString) {
            applyStroke(color: color, thickness: thickness, onRange: NSRange(range, in: string))
        }
    }

    // Apply stroke on give range
    func applyStroke(color: UIColor, thickness: Int, onRange: NSRange) {
        addAttributes([NSAttributedString.Key.strokeColor: color],
                      range: onRange)
        addAttributes([NSAttributedString.Key.strokeWidth: thickness],
                      range: onRange)
    }

    /********************* Shadow Color Attribute *********************/
    // Apply shadow color on substring
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat,
                     shadowHeigt: CGFloat, shadowRadius: CGFloat,
                     subString: String)
    {
        if let range = string.range(of: subString) {
            applyShadow(shadowColor: shadowColor, shadowWidth: shadowWidth,
                        shadowHeigt: shadowHeigt, shadowRadius: shadowRadius,
                        onRange: NSRange(range, in: string))
        }
    }

    // Apply shadow color on given range
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat,
                     shadowHeigt: CGFloat, shadowRadius: CGFloat,
                     onRange: NSRange)
    {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: shadowWidth, height: shadowHeigt)
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        addAttributes([NSAttributedString.Key.shadow: shadow], range: onRange)
    }

    /********************* Paragraph Style  Attribute *********************/
    // Apply paragraph style on substring
    func alignment(alignment: NSTextAlignment, subString: String) {
        if let range = string.range(of: subString) {
            self.alignment(alignment: alignment, onRange: NSRange(range, in: string))
        }
    }

    // Apply paragraph style on give range
    func alignment(alignment: NSTextAlignment, onRange: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: onRange)
    }
}
