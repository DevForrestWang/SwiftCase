//
//===--- GYMainChatPictureCell.swift - Defines the GYMainChatPictureCell class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by Forrest on 2022/6/3.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class GYMainChatPictureCell: GYMainChatBaseInfoCell {
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
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
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    override public func update(model: GYMainChatModel) {
        super.update(model: model)

        if model.messageTpye == .picture {
            if let msgDic = model.msg as? NSDictionary {
                if let strURL = msgDic["imgUrl"] as? String {
                    messageImagView.kf.setImage(with: URL(string: strURL), placeholder: UIImage(named: "gyhs_bigDefaultImage"))
                }
                contentBgView.backgroundColor = UIColor.hexColor(0xEEEEEE)
            }
        }
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
        messageLable.removeFromSuperview()
        contentBgView.addSubview(messageImagView)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        messageImagView.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(150)

//            if sendType == .acceptInfo {
//                make.left.equalToSuperview().offset(10)
//            } else {
//                make.right.equalToSuperview().offset(-10)
//            }
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }

    // MARK: - Property

    let messageImagView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
}
