//
//  GYMainChatBaseInfoCell.swift
//  GYCompany
//
//  Created by wfd on 2022/5/26.
//  Copyright © 2022 归一. All rights reserved.
//

import Kingfisher
import UIKit

class GYMainChatBaseInfoCell: UITableViewCell {
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

    public func update(model: GYMainChatModel) {
        sendType = model.sendType
        if sendType == .sendInfo {
            rightSetupConstraints()
        }

        // 设置头像
        let userAvatar = model.userInfo?.userAvatar ?? ""
        headImagView.kf.setImage(with: URL(string: userAvatar), placeholder: UIImage(named: "placeholder"))

        userNameLable.text = model.userInfo?.userName

        let grade = " \(model.userInfo?.levelName ?? "")"
        // let iHeight = gradeLable.font.lineHeight
        // gradeLable.attributedText = GYCompanyUtils.imageAndTitleAttribute(title: grade, iconName: "gy_tool_user", startX: 0, height: iHeight, color: UIColor.hexColor(0xE46900))
        gradeLable.text = grade

        contentBgView.backgroundColor = .white
        if model.messageTpye == .text {
            if let message = model.msg as? String {
                messageLable.text = message
                messageLable.isHidden = false
            }
            contentBgView.backgroundColor = UIColor.hexColor(0xFFF7EB)
        } else if model.messageTpye == .picture {
            if let msgDic = model.msg as? NSDictionary {
                if let strURL = msgDic["imgUrl"] as? String {
                    messageLable.isHidden = true
                    messageImagView.kf.setImage(with: URL(string: strURL), placeholder: UIImage(named: "gyhs_bigDefaultImage"))

                    messageImagView.snp.makeConstraints { make in
                        make.width.equalTo(110)
                        make.height.equalTo(150)
                    }
                }
                contentBgView.backgroundColor = UIColor.hexColor(0xEEEEEE)
            }
        } else if model.messageTpye == .voice {
            if let msgDic = model.msg as? NSDictionary {
                if let second = msgDic["second"] as? Int64, let remoteAudioUrl = msgDic["remoteAudioUrl"] as? String {
                    messageLable.text = "\(second) '' "
                }
                messageLable.isHidden = false
                messageLable.snp.makeConstraints { make in
                    make.width.equalTo(100)
                    make.height.equalTo(30)
                }
                contentBgView.backgroundColor = UIColor.hexColor(0xFFF7EB)
            }
        }

        messageImagView.isHidden = !messageLable.isHidden
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
        backgroundColor = UIColor.hexColor(0xEEEEEE)
        addSubview(headImagView)
        addSubview(userNameLable)
        addSubview(gradeBgView)
        gradeBgView.addSubview(gradeLable)
        addSubview(contentBgView)
        contentBgView.addSubview(messageLable)
        contentBgView.addSubview(messageImagView)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        headImagView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.width.height.equalTo(35)
            if sendType == .acceptInfo {
                make.left.equalToSuperview().offset(10)
            } else {
                make.right.equalToSuperview().offset(-10)
            }
        }

        userNameLable.snp.makeConstraints { make in
            make.top.top.equalTo(10)
            make.height.equalTo(21)
            make.width.lessThanOrEqualTo(gScreenWidth / 2)

            if sendType == .acceptInfo {
                make.left.equalTo(headImagView.snp.right).offset(10)
            } else {
                make.right.equalTo(headImagView.snp.left).offset(-10)
            }
        }

        gradeBgView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(21)
            make.width.equalTo(60)

            if sendType == .acceptInfo {
                make.left.equalTo(userNameLable.snp.right).offset(10)
            } else {
                make.right.equalTo(userNameLable.snp.left).offset(-10)
            }
        }

        gradeLable.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
        }

        contentBgView.snp.makeConstraints { make in
            make.top.equalTo(userNameLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.lessThanOrEqualTo(contentWidth)

            if sendType == .acceptInfo {
                make.left.equalTo(headImagView.snp.right).offset(10)
            } else {
                make.right.equalTo(headImagView.snp.left).offset(-10)
            }
        }

        messageLable.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        if sendType == .acceptInfo {
            messageLable.textAlignment = .left
        } else {
            messageLable.textAlignment = .right
        }

        messageImagView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }

    private func rightSetupConstraints() {
        headImagView.snp.remakeConstraints { make in
            make.top.equalTo(10)
            make.width.height.equalTo(35)
            make.right.equalToSuperview().offset(-10)
        }

        userNameLable.snp.remakeConstraints { make in
            make.top.top.equalTo(10)
            make.height.equalTo(21)
            make.width.lessThanOrEqualTo(gScreenWidth / 2)
            make.right.equalTo(headImagView.snp.left).offset(-10)
        }

        gradeBgView.snp.remakeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(21)
            make.width.equalTo(60)
            make.right.equalTo(userNameLable.snp.left).offset(-10)
        }

        contentBgView.snp.remakeConstraints { make in
            make.top.equalTo(userNameLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(headImagView.snp.left).offset(-10)
            make.width.lessThanOrEqualTo(contentWidth)
        }

        messageLable.textAlignment = .right
    }

    // MARK: - Property

    var sendType: GYMainChatSendType? = .acceptInfo
    let contentWidth = gScreenWidth - (50 + 10) * 2
    let headImagView = UIImageView().then {
        $0.image = UIImage(named: "gy_assistant_main_default_head")
        $0.layer.cornerRadius = 17
        $0.layer.masksToBounds = true
    }

    let userNameLable = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.hexColor(0x828282)
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }

    let gradeBgView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.hexColor(0xE46900).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
    }

    let gradeLable = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.hexColor(0xE46900)
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    let contentBgView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }

    let messageLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    let messageImagView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
}
