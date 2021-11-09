//
//===--- DPInterpreter.swift - Defines the DPInterpreter class ----------===//
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
/*:
  ###

  ### 理论：解释器模式
    1、解释器模式为某个语言定义它的语法（或者叫文法）表示，并定义一个解释器用来处理这个语法。
    2、它的代码实现的核心思想，就是将语法解析的工作拆分到各个小类中，以此来避免大而全的解析类。

 ### 用法
     testDPInterpreter()
 */

/// 保存变量与值的关系
final class IntegerContext {
    private var data: [Character: Int] = [:]

    func lookup(name: Character) -> Int {
        return data[name]!
    }

    func assign(expression: IntegerVariableExpression, value: Int) {
        data[expression.name] = value
    }
}

protocol IntegerExpression {
    func evaluate(_ context: IntegerContext) -> Int

    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression

    func copied() -> IntegerExpression
}

final class IntegerVariableExpression: IntegerExpression {
    let name: Character

    init(name: Character) {
        self.name = name
    }

    func evaluate(_ context: IntegerContext) -> Int {
        return context.lookup(name: name)
    }

    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return integerExpression.copied()
        } else {
            return IntegerVariableExpression(name: self.name)
        }
    }

    func copied() -> IntegerExpression {
        return IntegerVariableExpression(name: name)
    }
}

final class AddExpression: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression

    init(op1: IntegerExpression, op2: IntegerExpression) {
        operand1 = op1
        operand2 = op2
    }

    func evaluate(_ context: IntegerContext) -> Int {
        return operand1.evaluate(context) + operand2.evaluate(context)
    }

    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return AddExpression(op1: operand1.replace(character: character, integerExpression: integerExpression),
                             op2: operand2.replace(character: character, integerExpression: integerExpression))
    }

    func copied() -> IntegerExpression {
        return AddExpression(op1: operand1, op2: operand2)
    }
}

final class SubtractionExpresion: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression

    init(op1: IntegerExpression, op2: IntegerExpression) {
        operand1 = op1
        operand2 = op2
    }

    func evaluate(_ context: IntegerContext) -> Int {
        return operand1.evaluate(context) - operand2.evaluate(context)
    }

    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return SubtractionExpresion(op1: operand1.replace(character: character, integerExpression: integerExpression),
                                    op2: operand2.replace(character: character, integerExpression: integerExpression))
    }

    func copied() -> IntegerExpression {
        return SubtractionExpresion(op1: operand1, op2: operand2)
    }
}
