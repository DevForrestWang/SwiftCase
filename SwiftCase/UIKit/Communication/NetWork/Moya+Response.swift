//
//===--- Moya+Response.swift - Defines the Moya+Response class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import Moya
import RxSwift

/// 扩展Moya+RxSwift扩展，支持.mapObject .mapArray
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapObject<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) -> Single<T> {
        return map { response in
            try response.mapObject(T.self, dataName: dataName)
        }
    }

    func mapArray<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) -> Single<[T?]?> {
        return map { response in
            try response.mapArray(T.self, dataName: dataName)
        }
    }
}

public extension ObservableType where Element == Response {
    func mapObject<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) -> Observable<T> {
        return map { response in
            try response.mapObject(T.self, dataName: dataName)
        }
    }

    func mapArray<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) -> Observable<[T?]?> {
        return map { response in
            try response.mapArray(T.self, dataName: dataName)
        }
    }
}

/// Moya 响应数据的扩展
public extension Response {
    func mapObject<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) throws -> T {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw SCServiceError(retCode: 9000, msg: "服务器开小差，请稍后重试")
        }

        var msgStr = "解析服务器数据失败"
        if let tmpMsg = jsonObject[dataName.msg] as? String {
            msgStr = tmpMsg
        }

        guard let retCode = jsonObject[dataName.retCode] as? Int else {
            throw SCServiceError(retCode: 9001, msg: msgStr)
        }

        if retCode != 200 {
            throw SCServiceError(retCode: retCode, msg: msgStr)
        }

        if let dataObj = jsonObject[dataName.data] as? String {
            guard let object = T.deserialize(from: dataObj) else {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
            return object
        } else if let dataObj = jsonObject[dataName.data] as? [String: Any] {
            guard let object = T.deserialize(from: dataObj) else {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
            return object
        } else if let dataObj = jsonObject[dataName.data] as? [String: Any] {
            // func mapObject<T: BaseMappable>(_ type: T.Type, dataName: SCResponseName) throws -> T {
            //  return Mapper<T>().map(JSONObject: dataObj)!
            // let jsonString = String.init(data: dataObj as! Data, encoding: .utf8)
            guard let object = T.deserialize(from: dataObj) else {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
            return object
        }

        var errorInfo = msgStr
        if errorInfo.isEmpty {
            errorInfo = "服务器开小差，请稍后重试"
        }

        throw SCServiceError(retCode: 9000, msg: errorInfo)
    }

    func mapArray<T: SCJsonModel>(_: T.Type, dataName: SCResponseName) throws -> [T?]? {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw SCServiceError(retCode: 9000, msg: "服务器开小差，请稍后重试")
        }

        var msgStr = "解析服务器数据失败"
        if let tmpMsg = jsonObject[dataName.msg] as? String {
            msgStr = tmpMsg
        }

        guard let retCode = jsonObject[dataName.retCode] as? Int else {
            throw SCServiceError(retCode: 9001, msg: msgStr)
        }

        if retCode != 200 {
            throw SCServiceError(retCode: retCode, msg: msgStr)
        }

        if let strData = jsonObject[dataName.data] as? String {
            return [T].deserialize(from: strData)
        } else if let dataArray = jsonObject[dataName.data] as? NSArray {
            // func mapArray<T: BaseMappable>(_ type: T.Type, dataName: SCResponseName) throws -> [T]
            // return Mapper<T>().mapArray(JSONObject: dataArray)!
            return [T].deserialize(from: dataArray)
        }

        var errorInfo = msgStr
        if errorInfo.isEmpty {
            errorInfo = "服务器开小差，请稍后重试"
        }

        throw SCServiceError(retCode: 9000, msg: errorInfo)
    }
}
