//
//===--- SCNetworkLoggerPlugin.swift - Defines the SCNetworkLoggerPlugin class ----------===//
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

import Moya

/// 打印日志格式的插件
public final class SCNetworkLoggerPlugin: PluginType {
    public init() {}

    public func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            SC.log("[HTTP Request] invalid request")
            return
        }

        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"

        /// HTTP Request Summary
        var httpLog = """
        ===========<HTTP Request-path:\(target.path) tag:>===========
        URL: \(url)
        TARGET: \(target)
        METHOD: \(method)\n
        """

        /// HTTP Request Header
        httpLog.append("HEADER: [\n")
        httpRequest.allHTTPHeaderFields?.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")

        /// HTTP Request Body
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            httpLog.append("BODY: \n\(bodyString)\n")
        }
        httpLog.append("[HTTP Request End]")

        SC.log(httpLog)
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }

    private func onSuceed(_ response: Response, target: TargetType, isFromError _: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode

        /// HTTP Response Summary
        var httpLog = """
        ===========<HTTP Response-path:\(target.path) tag:>===========
        TARGET: \(target)
        URL: \(url)
        STATUS CODE: \(statusCode)\n
        """

        /// HTTP Response Header
        httpLog.append("HEADER: [\n")
        response.response?.allHeaderFields.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")

        /// HTTP Response Data
        httpLog.append("RESPONSE DATA: \n")

        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: response.data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            let responseString = String(data: prettyData, encoding: .utf8) ?? String(data: response.data, encoding: .utf8) ?? ""
            httpLog.append("\(responseString)\n")
        } catch {
            if let responseString = String(bytes: response.data, encoding: String.Encoding.utf8) {
                httpLog.append("\(responseString)\n")
            }
        }

        httpLog.append("[HTTP Response End]")

        SC.log(httpLog)
    }

    private func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }

        /// HTTP Error Summary
        var httpLog = """
        ===========<HTTP Error-path:\(target.path) tag:>===========
        TARGET: \(target)
        ERRORCODE: \(error.errorCode)\n
        """
        httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        httpLog.append("[HTTP Error End]")

        SC.log(httpLog)
    }
}
