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

    /// 编码、界面实例
    private func encodingAndDecoding() {
        struct Player: Codable {
            var name: String
            var highScore: Int = 0
            var history: [Int] = []

            /// 属性与Json字符串映射
            enum CodingKeys: String, CodingKey {
                case name = "Name"
                case highScore = "HighScore"
                case history = "History"
            }

            init(_ name: String) {
                self.name = name
            }

            /// 添加分数，更新最高分
            mutating func updateScore(_ newScore: Int) {
                history.append(newScore)
                if highScore < newScore {
                    SC.log("\(newScore)! A new high score for \(name)!  ")
                    highScore = newScore
                }
            }
        }

        // 1、对象的编码、解码
        do {
            do {
                var player = Player("Tomas")
                player.updateScore(30)
                player.updateScore(50)
                player.updateScore(40)

                // 编码
                // Model 转 Data
                let jsonData = try JSONEncoder().encode(player)
                // Data 转 String
                SC.log(String(data: jsonData, encoding: String.Encoding.utf8) ?? "")
                // {"History":[30,50,40],"Name":"Tomas","HighScore":50}

                // 解码
                let dePlayer = try JSONDecoder().decode(Player.self, from: jsonData)
                SC.log(dePlayer)
                // Player(name: "Tomas", highScore: 50, history: [30, 50, 40])
            } catch {
                SC.log(error.localizedDescription)
            }
        }

        // 2、将JSON字符串转成 Data及 Data转为对象
        do {
            let jsonString: String = """
            {
                "Name" : "Tomas",
                "HighScore" : 50,
                "History" : [30, 40, 50]
            }
            """

            guard let jsonData: Data = jsonString.data(using: String.Encoding.utf8) else {
                return
            }

            do {
                let player: Player = try JSONDecoder().decode(Player.self, from: jsonData)
                SC.log(player)
                // Player(name: "Tomas", highScore: 50, history: [30, 40, 50])
            } catch {
                SC.log(error.localizedDescription)
            }
        }

        // 3、标准的带转义的JSON字符串转字典及对象
        do {
            let jsonString = "{\"History\":[30,40,50],\"Name\":\"Tomas\",\"HighScore\":50}"

            // String 转 Data
            do {
                if let data = jsonString.data(using: String.Encoding.utf8),
                   let playDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                {
                    SC.log(playDic)

                    let player = convertFromDict(dict: playDic, Player.self)
                    SC.log(player ?? "")
                    // Player(name: "Tomas", highScore: 50, history: [30, 40, 50])
                }
            } catch {
                SC.log(error.localizedDescription)
            }
        }

        // 4、字典转Data及对象
        do {
            let dict: [String: Any] = ["Name": "Tomas",
                                       "HighScore": 50,
                                       "History": [30, 40, 50]]

            if JSONSerialization.isValidJSONObject(dict) == false {
                return
            }

            do {
                // 字典 转 data
                let data: Data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)

                // 将data转成字符串输出
                SC.log(String(data: data, encoding: String.Encoding.utf8) ?? "")
                // {"HighScore":50,"History":[30,40,50],"Name":"Tomas"}
            } catch {
                SC.log(error.localizedDescription)
            }

            if let player = convertFromDict(dict: dict as NSDictionary, Player.self) {
                SC.log(player)
                // Player(name: "Tomas", highScore: 50, history: [30, 40, 50])

                let playerDic = convertToDict(model: player, Player.self)
                SC.log(playerDic ?? "")
                /*
                 {
                     HighScore = 50;
                     History =     (
                         30,
                         40,
                         50
                     );
                     Name = Tomas;
                 }
                 */
            }
        }
    }

    /// 将字典转换为对象
    private func convertFromDict<T: Codable>(dict: NSDictionary, _: T.Type = T.self) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            SC.log(error.localizedDescription)
        }

        return nil
    }

    /// 将对象转换为字典
    private func convertToDict<T: Codable>(model: T, _: T.Type = T.self) -> NSDictionary? {
        do {
            let data = try JSONEncoder().encode(model)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
        } catch {
            print(error)
        }
        return nil
    }

    // MARK: - UI

    private func setupUI() {
        encodingDemo()
        decoderDemo()
        encodingByWrapperPDemo()
        encodingAndDecoding()
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
