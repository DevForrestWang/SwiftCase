//
//===--- PermissionAccessor.swift - Defines the PermissionAccessor class ----------===//
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

import AVFoundation
import Foundation
import PhotosUI

/*:
  ### 模板方法模式: 它在超类中定义了一个算法的框架，允许子类在不修改结构的情况下重写算法的特定步骤。
  ### 理论：
    1、当你只希望客户端扩展某个特定算法步骤，而不是整个算法或其结构时，可使用模板方法模式。
    2、当多个类的算法除一些细微不同之外几乎完全一样时， 你可使用该模式。但其后果就是，只要算法发生变化，你就可能需要修改所有的类。

 ### 用法
     testAccessorTemplate()
 */

//===----------------------------------------------------------------------===//
//                              Template
//===----------------------------------------------------------------------===//
class PermissionAccessor: CustomStringConvertible {
    typealias Completion = (Bool) -> Void

    func requestAccessIfNeeded(_ completion: @escaping Completion) {
        guard !hasAccess() else {
            completion(true)
            return
        }

        willReciveAccess()
        requestAccess { status in
            status ? self.didReciveAccess() : self.didRejectAccess()
            completion(status)
        }
    }

    func requestAccess(_: @escaping Completion) {
        fatalError("Should be overriden")
    }

    func hasAccess() -> Bool {
        fatalError("Should be overridden")
    }

    var description: String {
        return "PermissionAccessor"
    }

    /// Hooks
    func willReciveAccess() {}

    func didReciveAccess() {}

    func didRejectAccess() {}
}

//===----------------------------------------------------------------------===//
//                              Template implementation
//===----------------------------------------------------------------------===//
class CameraAccessor: PermissionAccessor {
    override func requestAccess(_ completion: @escaping PermissionAccessor.Completion) {
//        AVCaptureDevice.requestAccess(for: .video) { status in
//            completion(status)
//        }
        completion(true)
    }

    override func hasAccess() -> Bool {
//        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        return true
    }

    override var description: String {
        return "Camera"
    }
}

class MicrophoneAccessor: PermissionAccessor {
    override func requestAccess(_ completion: @escaping PermissionAccessor.Completion) {
//        AVAudioSession.sharedInstance().requestRecordPermission { status in
//            completion(status)
//        }
        completion(false)
    }

    override func hasAccess() -> Bool {
//        return AVAudioSession.sharedInstance().recordPermission == .granted
        return false
    }

    override var description: String {
        return "Microphone"
    }
}

class PhotoLibraryAccessor: PermissionAccessor {
    override func requestAccess(_ completion: @escaping PermissionAccessor.Completion) {
//        PHPhotoLibrary.requestAuthorization { status in
//            completion(status == .authorized)
//        }
        completion(true)
    }

    override func hasAccess() -> Bool {
//        return PHPhotoLibrary.authorizationStatus() == .authorized
        return true
    }

    override var description: String {
        return "PhotoLibrary"
    }

    override func didReciveAccess() {
        /// We want to track how many people give access to the PhotoLibrary.
        SC.log("PhotoLibrary Accessor: Receive access. Updating analytics...")
    }

    override func didRejectAccess() {
        /// ... and also we want to track how many people rejected access.
        SC.log("PhotoLibrary Accessor: Rejected with access. Updating analytics...")
    }
}
