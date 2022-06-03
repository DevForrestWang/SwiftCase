//
//  GYChatInputCollectionViewCell.swift
//  GYCompany
//
//  Created by wfd on 2022/5/27.
//  Copyright © 2022 归一. All rights reserved.
//

import UIKit

class GYChatInputCollectionViewCell: UICollectionViewCell {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }

    // 执行析构过程
    deinit {
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    public func update(emoji: String) {
        // 解决表情长度计算不准问题
        let emojiOCStr = NSString(format: "%@", emoji)
        // 设置表情符号大小
        let emojiAttr = NSMutableAttributedString(string: emoji).then {
            $0.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 35), range: NSMakeRange(0, emojiOCStr.length))
        }
        emojiLable.attributedText = emojiAttr
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
        addSubview(emojiLable)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        emojiLable.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.height.equalTo(45)
        }
    }

    // MARK: - Property

    let emojiLable = UILabel().then {
        $0.textAlignment = .center
    }
}
