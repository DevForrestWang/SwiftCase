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

      ===========<request-id:3 tag:>===========
      https://dc.aadv.net:10443/mobile/reconsitution//common/custGlobalData
      2023-04-18 10:02:05.310680+0800 HMCommunity[77949:8328911] Request Header:{
          appName = hmsq;
          channelType = 41;
          custId = 0601912002520161029;
          token = ab7db3d28fe81c29f403431985963ce5fcb3ad07aeab3174c08ad3d7a470ef3d;
          version = 5.0.0;
      }

      ===========<request-id:4 tag:>===========
      https://dp.aaij.net:8443/hsim-bservice/friend/queryFriendList
      httpBody:{
        "loginToken" : "ab7db3d28fe81c29f403431985963ce5fcb3ad07aeab3174c08ad3d7a470ef3d",
        "data" : {
          "accountId" : "c_0601912002520161029"
        },
        "channelType" : "41",
        "custId" : "0601912002520161029"
      }
      2023-04-18 10:02:05.320777+0800 HMCommunity[77949:8328911] Request Header:{
          channelType = 41;
          appName = hmsq;
          GToken = ab7db3d28fe81c29f403431985963ce5fcb3ad07aeab3174c08ad3d7a470ef3d;
          custId = 0601912002520161029;
          token = ab7db3d28fe81c29f403431985963ce5fcb3ad07aeab3174c08ad3d7a470ef3d;
          version = 5.0.0;
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
