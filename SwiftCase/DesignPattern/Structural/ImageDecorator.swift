//
//===--- ImageDecorator.swift - Defines the ImageDecorator class ----------===//
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

import Foundation
import UIKit
/*:
  ### 装饰者模式: 咖啡店有拿铁、其他，可以添加的Milk、soy、糖等是对咖啡的装饰
  ### 理论：
    1、如果你希望在无需修改代码的情况下即可使用对象，且希望在运行时为对象新增额外的行为，可以使用装饰模式。
    2、如果用继承来扩展对象行为的方案难以实现或者根本不可行，你可以使用该模式。

 ### 用法
     testImageDecorator()
 */

//===----------------------------------------------------------------------===//
//                              Resizer
//===----------------------------------------------------------------------===//
protocol ImageEditror: CustomStringConvertible {
    func applay() -> UIImage
}

extension UIImage: ImageEditror {
    func applay() -> UIImage {
        self
    }

    override open var description: String {
        return "Image"
    }
}

class ImageDecorator: ImageEditror {
    private var editor: ImageEditror

    required init(_ editor: ImageEditror) {
        self.editor = editor
    }

    func applay() -> UIImage {
        fwDebugPrint(editor.description + " applies changes")
        return editor.applay()
    }

    var description: String {
        return "ImageDecorator"
    }
}

class Resizer: ImageDecorator {
    private var xScale: CGFloat = 0
    private var yScale: CGFloat = 0
    private var hasAlpha = false

    required init(_ editor: ImageEditror) {
        super.init(editor)
    }

    convenience init(_ editor: ImageEditror, xScale: CGFloat = 0, yScale: CGFloat = 0, hasAlpha: Bool = false) {
        self.init(editor)
        self.xScale = xScale
        self.yScale = yScale
        self.hasAlpha = hasAlpha
    }

    override func applay() -> UIImage {
        let image = super.applay()
        let size = image.size.applying(CGAffineTransform(scaleX: xScale, y: yScale))

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, UIScreen.main.scale)
        image.draw(in: CGRect(origin: .zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage ?? image
    }

    override var description: String {
        return "Resizer"
    }
}

//===----------------------------------------------------------------------===//
//                                  装饰器
//===----------------------------------------------------------------------===//
class BaseFilter: ImageDecorator {
    fileprivate var filter: CIFilter?

    init(editor: ImageEditror, filtName: String) {
        filter = CIFilter(name: filtName)
        super.init(editor)
    }

    required init(_ editor: ImageEditror) {
        super.init(editor)
    }

    override func applay() -> UIImage {
        let image = super.applay()
        let content = CIContext(options: nil)

        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)

        guard let output = filter?.outputImage else {
            return image
        }

        guard let coreImage = content.createCGImage(output, from: output.extent) else {
            return image
        }

        return UIImage(cgImage: coreImage)
    }
}

class BlurFilter: BaseFilter {
    required init(_ editor: ImageEditror) {
        super.init(editor: editor, filtName: "CIGaussianBlur")
    }

    func update(radius: Double) {
        filter?.setValue(radius, forKey: "inputRadius")
    }

    override var description: String {
        return "BlurFilter"
    }
}

class ColorFilter: BaseFilter {
    required init(_ editor: ImageEditror) {
        super.init(editor: editor, filtName: "CIColorControls")
    }

    func update(saturation: Double) {
        filter?.setValue(saturation, forKey: "inputSaturation")
    }

    func update(brightness: Double) {
        filter?.setValue(brightness, forKey: "inputBrightness")
    }

    func update(contrast: Double) {
        filter?.setValue(contrast, forKey: "inputContrast")
    }
}

//===----------------------------------------------------------------------===//
//                              DecoratorClient
//===----------------------------------------------------------------------===//
class DecoratorClient {
    func clientCode(editor: ImageEditror) {
        let image = editor.applay()

        /// Note. You can stop an execution in Xcode to see an image preview.
        fwDebugPrint("Client: all changes have been applied for \(image)")
    }

    func loadImage(urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else {
            fatalError("Please enter a vaild URL")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot load an image")
        }

        guard let image = UIImage(data: data) else {
            fatalError("Cannot create an image form data")
        }

        return image
    }
}
