//
//===--- GYMainChatBaseInfoCell.swift - Defines the GYMainChatBaseInfoCell class ----------===//
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

import Kingfisher
import UIKit

class GYMainChatBaseInfoCell: UITableViewCell {
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // 执行析构过程
    deinit {
        SC.log("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    public func update(model: GYMainChatModel) {
        currentModel = model
        isMessageRevoke = isCanRevoke()
        sendType = model.sendType

        updateHeadInfo(model: model)
        contentBgView.backgroundColor = .white

        reSetupConstraints()
    }

    @objc public func clickAction(recognizer _: UITapGestureRecognizer) {
        SC.log("click Class: \(type(of: self))")
    }

    /// 定制弹出菜单
    public func getUIMenuItems() -> [UIMenuItem] {
        return []
    }

    /// 弹出子菜单项
    public func iShowMenumItems(action _: Selector) -> Bool {
        return false
    }

    /// 设置成为第一响应者
    override var canBecomeFirstResponder: Bool {
        true
    }

    /// 弹出子菜单项
    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        return iShowMenumItems(action: action)
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func longPressAction(recognizer _: UITapGestureRecognizer) {
        if UIMenuController.shared.isMenuVisible {
            SC.log("The menu is show.")
            return
        }

        // 要是当前cell成为第一响应者，否则菜单显示不出来
        becomeFirstResponder()

        let menu = UIMenuController.shared
        menu.menuItems = getUIMenuItems()
        menu.arrowDirection = .default

        if #available(iOS 13.0, *) {
            menu.showMenu(from: contentBgView, rect: contentBgView.bounds)
        } else {
            menu.setTargetRect(contentBgView.bounds, in: contentBgView)
            menu.setMenuVisible(true, animated: true)
        }
    }

    // MARK: - Private

    private func updateHeadInfo(model: GYMainChatModel) {
        gradeBgView.isHidden = true
        headImagView.image = UIImage(named: "gy_assistant_main_default_head")

        guard let userInfo = model.userInfo else {
            return
        }
        gradeBgView.isHidden = false

        // 设置头像
        headImagView.image = UIImage(named: "santa")

        userNameLable.text = model.userInfo?.userName

        let grade = " \(userInfo.levelName ?? "")"
        let iHeight = gradeLable.font.lineHeight
        gradeLable.attributedText = SCUtils.imageAndTitleAttribute(title: grade, iconName: "gy_tool_user", startX: 0, height: iHeight, color: UIColor.hexColor(0xE46900))
    }

    /// 是否能撤回
    private func isCanRevoke() -> Bool {
        guard let msgTimeStamp = currentModel?.msgTimeStamp else {
            return false
        }

        let diffTime = SCUtils.currenntDifferenceTime(timeStamp: msgTimeStamp)
        return diffTime > 60 * 2 ? false : true
    }

    // MARK: - UI

    private func setupUI() {
        SC.log("===========<loadClass: \(type(of: self))>===========")
        contentView.isUserInteractionEnabled = true

        backgroundColor = UIColor.hexColor(0xEEEEEE)
        addSubview(headImagView)
        addSubview(userNameLable)
        addSubview(gradeBgView)
        gradeBgView.addSubview(gradeLable)
        addSubview(contentBgView)

        // 内容点击事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        contentBgView.addGestureRecognizer(tapGesture)

        // 内容长按弹出菜单
        let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        contentBgView.addGestureRecognizer(longPressGest)
    }

    // MARK: - Constraints

    // 页面重新布局；由于cell复用，滑动时cell需要按照实际方向布局，否则会导致前面的布局使用后面的布局
    private func reSetupConstraints() {
        headImagView.snp.remakeConstraints { make in
            make.top.equalTo(10)
            make.width.height.equalTo(35)
            if sendType == .acceptInfo {
                make.left.equalToSuperview().offset(10)
            } else {
                make.right.equalToSuperview().offset(-10)
            }
        }

        userNameLable.snp.remakeConstraints { make in
            make.top.top.equalTo(10)
            make.height.equalTo(21)
            make.width.lessThanOrEqualTo(gScreenWidth / 2)

            if sendType == .acceptInfo {
                make.left.equalTo(headImagView.snp.right).offset(10)
            } else {
                make.right.equalTo(headImagView.snp.left).offset(-10)
            }
        }

        gradeBgView.snp.remakeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(21)
            make.width.equalTo(60)

            if sendType == .acceptInfo {
                make.left.equalTo(userNameLable.snp.right).offset(10)
            } else {
                make.right.equalTo(userNameLable.snp.left).offset(-10)
            }
        }

        gradeLable.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
        }

        contentBgView.snp.remakeConstraints { make in
            make.top.equalTo(userNameLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.lessThanOrEqualTo(contentWidth)

            if sendType == .acceptInfo {
                make.left.equalTo(headImagView.snp.right).offset(10)
            } else {
                make.right.equalTo(headImagView.snp.left).offset(-10)
            }
        }
    }

    // MARK: - Property

    public var gyMainChatCellClosure: ((_ messageType: GYMainChatMessageType, _ dataDic: [String: Any]) -> Void)?

    public var sendType: GYMainChatSendType? = .acceptInfo {
        didSet {
            print("change sendType: \(String(describing: sendType))")
        }
    }

    public var currentModel: GYMainChatModel?

    public var isMessageRevoke = false

    private let contentWidth = gScreenWidth - (50 + 10) * 2
    private let headImagView = UIImageView().then {
        $0.image = UIImage(named: "gy_assistant_main_default_head")
        $0.layer.cornerRadius = 17
        $0.layer.masksToBounds = true
    }

    private let userNameLable = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.hexColor(0x828282)
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }

    private let gradeBgView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.hexColor(0xE46900).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
    }

    private let gradeLable = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.hexColor(0xE46900)
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    public let contentBgView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
}
