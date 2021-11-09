//
//===--- MessageTableViewCell.swift - Defines the MessageTableViewCell class ----------===//
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

class MessageTableViewCell: UITableViewCell {
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var viewContainer: UIView! {
        didSet {
            viewContainer.layer.cornerRadius = 8.0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ message: Message) {
        lblMessage.text = message.message ?? ""
        lblDate.text = SCUtils.formatDate(message.date ?? "", format: "HH:mm:ss")
    }
}
