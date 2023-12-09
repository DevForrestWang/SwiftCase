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
        let result = contentsResult(ofFile: "")
        switch result {
        case let .success(contents):
            print(contents)
        case let .failure(error):
            switch error {
            case .fileDoesNotExist:
                print("File not found")
            case .noPermission:
                print("No permission")
            case let .warning(message: message):
                print("message:\(message)")
            }
        }
        // File not found
    }

    /// 模拟获取文件结果，
    private func contentsResult(ofFile fileName: String) -> Result<String, FileError> {
        if fileName.count <= 0 {
            return .failure(.fileDoesNotExist)
        }

        return .success("Sucessed")
    }

    /// 抛出异常测试
    private func testThrows() {
        do {
            let result = try contentsThrows(ofFile: "")
            print(result)
        } catch FileError.fileDoesNotExist {
            print("File not found")
        } catch FileError.noPermission {
            print("no Permission")
        } catch let FileError.warning(message) {
            print("warning: \(message)")
        } catch {
            print(error.localizedDescription)
        }

        // warning: File is not exist.
    }

    private func contentsThrows(ofFile filename: String) throws -> String {
        if filename.count <= 0 {
            throw FileError.warning(message: "File is not exist.")
        }
        return "File content."
    }

    // MARK: - UI

    private func setupUI() {
        title = "Error"

        testResult()
        testThrows()
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}

/// 错误类型定义
enum FileError: Error {
    case fileDoesNotExist
    case noPermission
    case warning(message: String)
}
