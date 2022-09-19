//
//===--- GYMainChatTextCell.swift - Defines the GYMainChatTextCell class ----------===//
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

class GYMainChatTextCell: GYMainChatBaseInfoCell {
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        reSetupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 执行析构过程
    deinit {
        fwDebugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    override public func update(model: GYMainChatModel) {
        if model.messageTpye != .text {
            return
        }

        super.update(model: model)

        if let message = model.msg as? String {
            messageLable.text = message
        }
        contentBgView.backgroundColor = UIColor.hexColor(0xFFF7EB)

        reSetupConstraints()
    }

    override public func getUIMenuItems() -> [UIMenuItem] {
        let item1 = UIMenuItem(title: "复制", action: #selector(copyAction))
        let item2 = UIMenuItem(title: "撤回", action: #selector(revokeAction))
        return [item1, item2]
    }

    override public func iShowMenumItems(action: Selector) -> Bool {
        let actions = [#selector(copyAction), #selector(revokeAction)]
        return actions.contains(action)
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc func copyAction() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = messageLable.text
    }

    @objc func revokeAction() {
        fwDebugPrint(#function)
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        fwDebugPrint("===========<loadClass: \(type(of: self))>===========")
        contentBgView.addSubview(messageLable)
    }

    // MARK: - Constraints

    private func reSetupConstraints() {
        messageLable.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }

        if sendType == .acceptInfo {
            messageLable.textAlignment = .left
        } else {
            messageLable.textAlignment = .right
        }
    }

    // MARK: - Property

    private let messageLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
}
