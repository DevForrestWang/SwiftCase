//
//===--- URLBuilder.swift - Defines the URLBuilder class ----------===//
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

class URLBuilder {
    private var components: URLComponents

    init() {
        components = URLComponents()
    }

    func set(scheme: String) -> URLBuilder {
        components.scheme = scheme
        return self
    }

    func set(host: String) -> URLBuilder {
        components.host = host
        return self
    }

    func set(port: Int) -> URLBuilder {
        components.port = port
        return self
    }

    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        components.path = path
        return self
    }

    func addQueryItem(name: String, value: String) -> URLBuilder {
        if components.queryItems == nil {
            components.queryItems = []
        }

        components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }

    func build() -> URL? {
        return components.url
    }
}
