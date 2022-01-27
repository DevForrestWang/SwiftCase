//
//===--- SCFlexBoxData.swift - Defines the SCFlexBoxData class ----------===//
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

import Foundation

struct SCFlexBoxData {
    let title: String
    let length: String
    let detail: String
    let image: String
}

/// loading data form plist
extension SCFlexBoxData {
    static func loadShows() -> [SCFlexBoxData] {
        guard let path = Bundle.main.path(forResource: "Shows", ofType: "plist"),
              let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]]
        else {
            fatalError("Failed to reading Shows.plist")
        }

        var dataAry = [SCFlexBoxData]()
        for dic in dictArray {
            guard
                let title = dic["title"] as? String,
                let lenght = dic["length"] as? String,
                let detail = dic["detail"] as? String,
                let image = dic["image"] as? String
            else {
                fatalError("Failed to parsing dict \(dic)")
            }

            let data = SCFlexBoxData(title: title, length: lenght, detail: detail, image: image)
            dataAry.append(data)
        }

        return dataAry
    }
}
