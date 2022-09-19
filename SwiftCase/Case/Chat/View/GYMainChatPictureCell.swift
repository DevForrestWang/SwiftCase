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

    public func update(model: GYMainChatModel, dataSource: [String: [GYMainChatModel]]) {
        if model.messageTpye != .picture {
            return
        }

        super.update(model: model)
        allDataSource = dataSource

        messageImagView.image = UIImage(named: "gyhs_bigDefaultImage")
        contentBgView.backgroundColor = UIColor.hexColor(0xEEEEEE)

        if let msgDic = model.msg as? NSDictionary {
            if let strURL = msgDic["imgUrl"] as? String {
                messageImagView.kf.setImage(with: URL(string: strURL), placeholder: UIImage(named: "gyhs_bigDefaultImage"))
            }
        }

        reSetupConstraints()
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc override public func clickAction(recognizer _: UITapGestureRecognizer) {
        guard let dataSouce = allDataSource, let tmpCurModel = currentModel else {
            fwDebugPrint("The dataSource is empty.")
            return
        }

        guard let tmpClosure = gyMainChatCellClosure else {
            fwDebugPrint("The gyMainChatCellClosure is empty.")
            return
        }

        guard tmpCurModel.msg is NSDictionary else {
            fwDebugPrint("The current model is not dictionary.")
            return
        }

        var urlAry: [String] = []
        var currentIndex = 0
        var index = 0

        for itemModels in dataSouce.values {
            for model in itemModels {
                if model.messageTpye != .picture {
                    continue
                }

                guard let msgDic = model.msg as? NSDictionary else {
                    continue
                }

                guard let strURL = msgDic["imgUrl"] as? String else {
                    continue
                }
                urlAry.append(strURL)

                if tmpCurModel.isEqual(model) {
                    currentIndex = index
                }

                index += 1
            }
        }

        let dataDic: [String: Any] = [
            "index": currentIndex,
            "urlAry": urlAry,
        ]
        tmpClosure(.picture, dataDic)
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        fwDebugPrint("===========<loadClass: \(type(of: self))>===========")
        contentBgView.addSubview(messageImagView)
    }

    // MARK: - Constraints

    private func reSetupConstraints() {
        messageImagView.snp.remakeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(150)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        }
    }

    // MARK: - Property

    private var allDataSource: [String: [GYMainChatModel]]?

    private let messageImagView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
}
