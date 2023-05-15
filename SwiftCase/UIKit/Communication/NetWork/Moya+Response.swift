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

        if let dataObj = jsonObject[dataName.data] as? String,
           let jsonData = try? JSONSerialization.data(withJSONObject: dataObj, options: [])
        {
            do {
                return try JSONDecoder().decode(T.self, from: jsonData)
            } catch {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }

        } else if let dataObj = jsonObject[dataName.data] as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: dataObj, options: [])
        {
            do {
                return try JSONDecoder().decode(T.self, from: jsonData)
            } catch {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
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

        if let strData = jsonObject[dataName.data] as? String,
           let jsonData = try? JSONSerialization.data(withJSONObject: strData, options: [])
        {
            do {
                return try JSONDecoder().decode([T].self, from: jsonData)
            } catch {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
        } else if let dataArray = jsonObject[dataName.data] as? NSArray,
                  let jsonData = try? JSONSerialization.data(withJSONObject: dataArray, options: [])
        {
            do {
                return try JSONDecoder().decode([T].self, from: jsonData)
            } catch {
                throw SCServiceError(retCode: retCode, msg: msgStr)
            }
        }

        var errorInfo = msgStr
        if errorInfo.isEmpty {
            errorInfo = "服务器开小差，请稍后重试"
        }

        throw SCServiceError(retCode: 9000, msg: errorInfo)
    }
}
