//
//===--- SCErrorViewController.swift - Defines the SCErrorViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/12/9.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 错误类型使用
class SCErrorViewController: BaseViewController {
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

    private func testResult() {
        let result = contents(ofFile: "input.txt")
        switch result {
        case let .success(contents):
            print(contents)
        case let .failure(error):
            switch error {
            case .fileDoesNotExist:
                print("File not found")
            case .noPermission:
                print("No permission")
            }
        }
        // File not found
    }

    /// 模拟获取文件结果，
    private func contents(ofFile fileName: String) -> Result<String, FileError> {
        if fileName.count < 0 {
            return .failure(.fileDoesNotExist)
        }

        return .success("Sucessed")
    }

    // MARK: - UI

    private func setupUI() {
        title = "Error"

        testResult()
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}

/// 错误类型定义
enum FileError: Error {
    case fileDoesNotExist
    case noPermission
}
