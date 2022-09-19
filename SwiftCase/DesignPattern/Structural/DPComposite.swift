//
//===--- DPComposite.swift - Defines the DPComposite class ----------===//
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

  ### 理论：组合模式是一种结构型设计模式，你可以使用它将对象组合成树状结构，并且能像使用独立对象一样使用它们
           示例：大部分国家的军队都采用层次结构管理。每支部队包括几个师，师由旅构成，旅由团构成，团可以继续划分为排。
    1、如果你需要实现树状对象结构，可以使用组合模式。
    2、如果你希望客户端代码以相同方式处理简单和复杂元素，可以使用该模式。

 ### 用法
     testDPComposite()
 */

//===----------------------------------------------------------------------===//
//                              Component
//===----------------------------------------------------------------------===//

/// The base Component class declares common operations for both simple and
/// complex objects of a composition.
protocol DPComponent {
    /// The base Component may optionally declare methods for setting and
    /// accessing a parent of the component in a tree structure. It can also
    /// provide some default implementation for these methods.
    var parent: DPComponent? { get set }

    /// In some cases, it would be beneficial to define the child-management
    /// operations right in the base Component class. This way, you won't need
    /// to expose any concrete component classes to the client code, even during
    /// the object tree assembly. The downside is that these methods will be
    /// empty for the leaf-level components.
    func add(component: DPComponent)

    func remove(component: DPComponent)

    /// You can provide a method that lets the client code figure out whether a
    /// component can bear children.
    func isComposite() -> Bool

    /// The base Component may implement some default behavior or leave it to
    /// concrete classes.
    func operation() -> String
}

extension DPComponent {
    func add(component _: DPComponent) {}
    func remove(component _: DPComponent) {}
    func isComposite() -> Bool {
        return false
    }
}

/// The Leaf class represents the end objects of a composition. A leaf can't
/// have any children.
///
/// Usually, it's the Leaf objects that do the actual work, whereas Composite
/// objects only delegate to their sub-components.
class DPLeaf: DPComponent {
    var parent: DPComponent?

    func operation() -> String {
        return "Leaf"
    }
}

//===----------------------------------------------------------------------===//
//                              Composite
//===----------------------------------------------------------------------===//
/// The Composite class represents the complex components that may have
/// children. Usually, the Composite objects delegate the actual work to their
/// children and then "sum-up" the result.
class DPComposite: DPComponent {
    var parent: DPComponent?

    /// This fields contains the conponent subtree.
    private var children = [DPComponent]()

    /// A composite object can add or remove other components (both simple or
    /// complex) to or from its child list.
    func add(component: DPComponent) {
        var item = component
        item.parent = self
        children.append(item)
    }

    func remove(component _: DPComponent) {
        // ...
    }

    func isComposite() -> Bool {
        return true
    }

    /// The Composite executes its primary logic in a particular way. It
    /// traverses recursively through all its children, collecting and summing
    /// their results. Since the composite's children pass these calls to their
    /// children and so forth, the whole object tree is traversed as a result.
    func operation() -> String {
        let result = children.map { $0.operation() }
        return "Branch(" + result.joined(separator: " ") + ") End "
    }
}

//===----------------------------------------------------------------------===//
//                              Client
//===----------------------------------------------------------------------===//
enum ComponentClient {
    static func clientCode(component: DPComponent) {
        fwDebugPrint("Result: " + component.operation())
    }

    static func moreComplexClient(leftComponent: DPComponent, rightComponent: DPComponent) {
        if leftComponent.isComposite() {
            leftComponent.add(component: rightComponent)
        }
        fwDebugPrint("Result: " + leftComponent.operation())
    }
}
