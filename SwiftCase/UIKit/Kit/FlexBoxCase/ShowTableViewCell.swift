//
//===--- ShowTableViewCell.swift - Defines the ShowTableViewCell class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/25.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class ShowTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var show: SCFlexBoxData! {
        didSet {
            self.textLabel?.text = show.title
            self.detailTextLabel?.text = show.length
            self.imageView?.image = UIImage(named: show.image)
        }
    }

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 14.0)
        textLabel?.numberOfLines = 2
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.minimumScaleFactor = 0.8

        detailTextLabel?.textColor = .lightGray

        let accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        accessoryView.image = UIImage(named: "download")
        self.accessoryView = accessoryView

        backgroundColor = .clear
        separatorInset = .zero
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
