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

    /// 属性包装解码操作
    private func encodingByWrapperPDemo() {
        /// 属性包装器的结构体
        struct APlacemark: Codable {
            var name: String
            var coordinate: APCoordinate
        }

        /// 把 Coordinate 中的 Double 值表示为字符串
        struct APCoordinate: Codable {
            @CodedAsString var latitude: Double
            @CodedAsString var longitude: Double
        }

        let places = [
            APlacemark(name: "Berlin", coordinate: APCoordinate(latitude: 52, longitude: 13)),
            APlacemark(name: "Cape Town", coordinate: APCoordinate(latitude: -34, longitude: 18)),
        ]

        do {
            let jsonData = try JSONEncoder().encode(places)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            SC.log("Property Wrapper: \(jsonString)")
            /*
             [{"name":"Berlin","coordinate":{"latitude":"52.0","longitude":"13.0"}},
             {"name":"Cape Town","coordinate":{"longitude":"18.0","latitude":"-34.0"}}]
             */
        } catch {
            SC.log(error.localizedDescription)
        }
    }

    // MARK: - UI

    private func setupUI() {
        encodingDemo()
        decoderDemo()
        encodingByWrapperPDemo()
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

/// 属性包装器将字符串转换为Double类型
@propertyWrapper
struct CodedAsString: Codable {
    var wrappedValue: Double

    init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        guard let value = Double(str) else {
            let error = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Invalid string representation of double value"
            )
            throw EncodingError.invalidValue(str, error)
        }
        wrappedValue = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(wrappedValue))
    }
}
