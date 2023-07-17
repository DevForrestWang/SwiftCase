//
//===--- SCImageTextButton.swift - Defines the SCImageTextButton class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// 图文混排，图片在上，文字在下
// https://codeleading.com/article/30281015726/
//===----------------------------------------------------------------------===//

import UIKit

public class SCImageTextButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        titleLabel?.textAlignment = .center
        // 图片填充模式:
        // scaleAspectFit 在保持长宽比的前提下，缩放图片，使得图片在容器内完整显示出来
        // scaleAspectFill 在保持长宽比的前提下，缩放图片，使图片充满容器
        // scaleToFill 缩放图片，使图片充满容器。图片未必保持长宽比例协调，有可能会拉伸至变形
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }

    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX = 0
        let titleY = contentRect.size.height * 0.35 + 5
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: CGFloat(titleX), y: titleY, width: titleW, height: titleH)
    }

    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.width
        let imageH = contentRect.size.height * 0.4
        return CGRect(x: 0, y: 5, width: imageW, height: imageH)
    }
}
