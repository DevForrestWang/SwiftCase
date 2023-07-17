//
//===--- UIImage+Extension.swift - Defines the UIImage+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/17.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import UIKit

public extension UIImage {
    /// 根据颜色生成图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }

    /// 质量压缩
    func compress(maxSize: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = jpegData(compressionQuality: 1) else { return nil }
        if data.count < maxSize {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxSize) {
                min = compression
            } else if data.count > maxSize {
                max = compression
            } else {
                break
            }
        }
        return data
    }

    /// 尺寸压缩
    func compress(maxLength: CGFloat) -> UIImage? {
        if maxLength <= 0 {
            return self
        }

        var imgMax: CGFloat = 0
        if size.width / size.height >= 1 {
            imgMax = size.width
        } else {
            imgMax = size.height
        }
        if imgMax > maxLength {
            let ratio = maxLength / imgMax
            let newW = size.width * ratio
            let newH = size.height * ratio

            let newSize = CGSize(width: newW, height: newH)
            UIGraphicsBeginImageContext(newSize)
            draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let _img = img else { return nil }
            return _img
        } else {
            return self
        }
    }
}
