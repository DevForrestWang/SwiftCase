//
//===--- TextViewMemento.swift - Defines the TextViewMemento class ----------===//
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
import UIKit
/*:
  ###    备忘录是一种行为设计模式，允许生成对象状态的快照并在以后将其还原。word的回退功能
  ### 理论：
    1、当你需要创建对象状态快照来恢复其之前的状态时，可以使用备忘录模式。
    2、当直接访问对象的成员变量、获取器或设置器将导致封装被突破时，可以使用该模式。

 ### 用法
     testTextViewMemento()
 */

//===----------------------------------------------------------------------===//
//                              UITextView Memento
//===----------------------------------------------------------------------===//
protocol TMMemento: CustomStringConvertible {
    var text: String { get }
    var date: Date { get }
}

extension UITextView {
    struct TextViewMemento: TMMemento {
        var text: String
        var date = Date()

        let textColor: UIColor?
        let selectedRange: NSRange

        var description: String {
            let time = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
            let color = String(describing: textColor)
            return "Text: \(text)\n" + "Date: \(time.description)\n"
                + "Color: \(color)\n" + "Range: \(selectedRange)\n\n"
        }
    }

    var memento: TMMemento {
        return TextViewMemento(text: text, textColor: textColor, selectedRange: selectedRange)
    }

    func restore(with memento: TMMemento) {
        guard let textViewMemento = memento as? TextViewMemento else {
            return
        }

        text = textViewMemento.text
        textColor = textViewMemento.textColor
        selectedRange = textViewMemento.selectedRange
    }
}

//===----------------------------------------------------------------------===//
//                              UndoStack
//===----------------------------------------------------------------------===//
class TMUndoStack: CustomStringConvertible {
    private lazy var mementos = [TMMemento]()
    private let textView: UITextView

    init(_ textView: UITextView) {
        self.textView = textView
    }

    func save() {
        mementos.append(textView.memento)
    }

    func undo() {
        guard !mementos.isEmpty else {
            return
        }
        textView.restore(with: mementos.removeLast())
    }

    var description: String {
        return mementos.reduce("") { $0 + $1.description }
    }
}
