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
// https://github.com/kakaopensource/KakaJSON

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

    /*
      1、打印日志格式：
      ===========<request-id:140 tag:>===========
      https://dc.aadv.net:10443/mobile/reconsitution//customerPoints/createPointInvest
      httpBody:{
        "channel" : "41",
        "userType" : "2",
        "investAmount" : "100",
        "hsResNo" : "06016230005",
        "custName" : "黄伟",
        "transPwd" : "d1ca3aaf52b41acd68ebb3bf69079bd1",
        "custType" : "1",
        "custId" : "0601623000520171130"
      }
      ===========<response-id:140 tag:>===========
      {
        "data" : null,
        "retCode" : 200,
        "currentPageIndex" : 0,
        "msg" : null,
        "rows" : null,
        "totalPage" : 0
      }

      2、超时时间
      3、请求头设置
      4、响应数据：NSDictionary *responseObject, NSError *error

     [[GYNetRequest alloc] initWithBlock:url
      parameters:parameters requestMethod:requestMethod
      requestSerializer:GYNetRequestSerializerJSON
      respondBlock:^(NSDictionary *responseObject, NSError *error)

      */
}
