//
//===--- ChatListTableViewCell.swift - Defines the ChatListTableViewCell class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// Inspirations are taken from:
// https://medium.com/mindful-engineering/sockets-mvvm-in-swift-8f32b1401aa5
//
//===----------------------------------------------------------------------===//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewOnlineStatus: UIView! {
        didSet {
            viewOnlineStatus.layer.cornerRadius = viewOnlineStatus.frame.width / 2
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ user: User) {
        lblName.text = user.nickname ?? ""
        viewOnlineStatus.isHidden = !(user.isConnected ?? false)
    }
}
