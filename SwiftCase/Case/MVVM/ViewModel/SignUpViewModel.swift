//
//===--- SignUpViewModel.swift - Defines the SignUpViewModel class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import RxCocoa
import RxSwift
import UIKit

class SignUpViewModel: BindingDataViewModelType {
    // MARK: - UnidirectionalViewModelType

    struct Input: InputType {
        let username: Observable<String>
        let password: Observable<String>
    }

    struct Output: OutputType {
        let validatedUsername: Observable<ValidationResult>

        let validatedPassword: Observable<ValidationResult>

        let isLoginAllowed: Observable<Bool>
    }

    func configure(input: Input) -> Output {
        let usernameResult = input.username
            .flatMapLatest { [weak self] username in
                self!.validateUsername(username)
            }.share(replay: 1)

        let passwordResult = input.password.flatMapLatest { [weak self] password in
            self!.validatePassword(password)
        }.share(replay: 1)

        let isLoginAllowed = Observable.combineLatest(usernameResult, passwordResult) { username, password in
            username.isValid && password.isValid
        }.distinctUntilChanged().share(replay: 1)

        return Output(
            validatedUsername: usernameResult,
            validatedPassword: passwordResult,
            isLoginAllowed: isLoginAllowed
        )
    }

    // MARK: - Public method

    func loadDataFromNewWork() {
        // 模拟网络获取的数据
        var tmpTracks = [Track]()
        for index in 1 ... 5 {
            var t1 = Track()
            t1.name = "Track \(index)"
            tmpTracks.append(t1)
        }

        tracks.onNext(tmpTracks)
    }

    func clearTrackData() {
        let tmpTracks = [Track]()
        tracks.onNext(tmpTracks)
    }

    // MARK: - Private method

    /// 用户名称合法性校验
    private func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }

        // this obviously won't be
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }

        if username.count > 6 {
            return .just(.ok(message: "Username available"))
        } else {
            return .just(.failed(message: "Username must be at least 6 characters"))
        }
    }

    /// 密码合法性校验
    private func validatePassword(_ password: String) -> Observable<ValidationResult> {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .just(.empty)
        }

        if numberOfCharacters < 6 {
            return .just(.failed(message: "Password must be at least 6 characters"))
        }

        return .just(.ok(message: "Password acceptable"))
    }

    // MARK: - Property

    let tracks: PublishSubject<[Track]> = PublishSubject()
}
