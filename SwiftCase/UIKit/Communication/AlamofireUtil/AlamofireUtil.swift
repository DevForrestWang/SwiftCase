//
//===--- AlamofireUtil.swift - Defines the AlamofireUtil class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/4/17.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Alamofire
import UIKit

// https://blog.csdn.net/kicinio/article/details/111998294
// https://github.com/Alamofire/Alamofire
// https://juejin.cn/post/6844903924864909319
// https://www.cnblogs.com/lfri/p/14067146.html

class AlamofireUtil: NSObject {
    // MARK: - Lifecycle

    // 执行析构过程
    deinit {
        print("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    static func getRequest(_ URLString: String, _ parameters: [String: Any]?, _ callback: @escaping (_ result: Any) -> Void) {
        requestData(type: MethodType.get, URLString: URLString, parameters: parameters, finishedCallback: callback)
    }

    static func postRequest(_ URLString: String, _ parameters: [String: Any]?, _ callback: @escaping (_ result: Any) -> Void) {
        requestData(type: MethodType.post, URLString: URLString, parameters: parameters, finishedCallback: callback)
    }

    // MARK: - Protocol

    // MARK: - Private

    static func requestData(type: MethodType,
                            URLString: String,
                            parameters: [String: Any]? = nil,
                            finishedCallback: @escaping (_ result: Any) -> Void)
    {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post

        Alamofire.AF.request(URLString,
                             method: method,
                             parameters: parameters,
                             encoding: URLEncoding.default,
                             headers: getHeads()).responseString { response in
            switch response.result {
            case let .success(json):
                finishedCallback(json)
            case let .failure(error):
                print("error:\(error)")
            }
        }
    }

    static func getHeads() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]

        return headers
    }

    // MARK: - Property

    enum MethodType {
        case get
        case post
    }
}
