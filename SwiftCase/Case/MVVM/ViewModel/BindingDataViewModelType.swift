//
//===--- BindingDataViewModelType.swift - Defines the BindingDataViewModelType class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// 数据绑定的协议
//
//===----------------------------------------------------------------------===//

import Foundation

protocol InputType {}

protocol OutputType {}

protocol BindingDataViewModelType {
    associatedtype Input: InputType

    associatedtype Output: OutputType

    func configure(input: Input) -> Output
}
