//
//===--- SCEncodingAndDecodingVC.swift - Defines the SCEncodingAndDecodingVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/12/14.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 编码解码
class SCEncodingAndDecodingVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    /// 解码操作
    private func encodingDemo() {
        let places = [
            Placemark(name: "Berlin", coordinate: Coordinate(latitude: 52, longitude: 13)),
            Placemark(name: "Cape Town", coordinate: Coordinate(latitude: -34, longitude: 18)),
        ]

        do {
            let jsonData = try JSONEncoder().encode(places) // 129 bytes
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            SC.log("\(jsonString)")
            /*
             [{"name":"Berlin","coordinate":{"longitude":13,"latitude":52}},
             {"name":"Cape Town","coordinate":{"longitude":18,"latitude":-34}}]
             */
        } catch {
            SC.log(error.localizedDescription)
        }
    }

    /// 解码
    private func decoderDemo() {
        do {
            guard let jsonData = "[{\"name\":\"Berlin\",\"coordinate\":{\"longitude\":13,\"latitude\":52}},{\"name\":\"Cape Town\",\"coordinate\":{\"longitude\":18,\"latitude\":-34}}]".data(using: .utf8) else {
                return
            }

            let decoded = try JSONDecoder().decode([Placemark].self, from: jsonData)
            SC.log("\(type(of: decoded))")
            // Array<Placemark>
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - UI

    private func setupUI() {
        encodingDemo()
        decoderDemo()
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    struct Coordinate: Codable {
        var latitude: Double
        var longitude: Double
    }

    struct Placemark: Codable {
        var name: String
        var coordinate: Coordinate
    }
}
