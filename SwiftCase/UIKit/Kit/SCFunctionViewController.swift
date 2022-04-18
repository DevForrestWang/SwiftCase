//
//===--- SCFunctionViewController.swift - Defines the SCFunctionViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information:
// String: https://developer.51cto.com/art/202105/664242.htm
// Learn to Code for Free: https://www.programiz.com/
//
//===----------------------------------------------------------------------===//

import UIKit

class SCFunctionViewController: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - String

    private func stringFunction() {
        baseString()
        appentString()
        formatString()
        lengthString()
        emptyString()
        iterationString()
        operationString()
        equalString()
        containString()
        splitString()
        joinString()
        subString()
        replateString()
        insertString()
        deleteInfoByString()
        convertData()

        // Other Built-in Functions
        // isEmpty        determines if a string is empty or not
        // capitalized    capitalizes the first letter of every word in a string
        // uppercased()   converts string to uppercase
        // lowercase()    converts string to lowercase
        // hasPrefix()    determines if a string starts with certain characters or not
        // hasSuffix()    determines if a string ends with certain characters or not

        // 首字母大写，
        print("wo xiao wo ku".capitalized) // Wo Xiao Wo Ku
        print("已选择: \("已选择".transformToPinYin())")
    }

    /// 字符基本
    private func baseString() {
        printEnter(message: "String")

        // 多行字符串字面量
        let quotation = """
        The White Rabbit put on his spectacles.  "Where shall I begin,
        please your Majesty?" he asked.

        "Begin at the beginning," the King said gravely, "and go on
        till you come to the end; then stop."
        """
        yxc_debugPrint(quotation)

        yxc_debugPrint("0.01: \("0.01".isPureFloat())")
        yxc_debugPrint("1.00: \("1.00".isPureFloat())")
        yxc_debugPrint("2: \("2".isPureFloat())")

        yxc_debugPrint("2: \("2".isPureInt())")
        yxc_debugPrint("2.1: \("2.1".isPureInt())")
    }

    /// 字符串拼接
    private func appentString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = str1 + " " + str2
        yxc_debugPrint(str3)

        var str4 = "Hello"
        str4.append(" Word")
        yxc_debugPrint(str4)
    }

    ///  字符串格式化
    private func formatString() {
        let str1 = String(2)
        let str2 = String(5.0)
        let str3 = str1 + str2
        yxc_debugPrint(str3)

        let str4 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        yxc_debugPrint(str4)

        // [String Format Specifiers](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
        let s1 = "lazy"
        yxc_debugPrint(String(format: "%@ boy %.2f", s1, 12.344))
        
        // 不足两位前面补0
        yxc_debugPrint(String(format: "%02d", 1))
        yxc_debugPrint(String(format: "%02d", 11))
    }

    /// 获取字符串长度
    private func lengthString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        yxc_debugPrint(str1.count)
    }

    private func emptyString() {
        let str1 = "Swift"
        let str2 = ""

        yxc_debugPrint(str1.isEmpty)
        yxc_debugPrint(str2.isEmpty)
    }

    /// 遍历字符串
    private func iterationString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        for char in str1 {
            yxc_debugPrint(char)
        }
    }

    /// 字符串操作
    private func operationString() {
        //  获取首字符
        let str1 = "Swift"
        yxc_debugPrint(str1[str1.startIndex])

        // 删除首字符
        var str2 = "ABC"
        str2.removeFirst() // str2.remove(at: str2.startIndex)
        yxc_debugPrint(str2)

        // 删除指定位置
        var str3 = "ABCDEFGH"
        str3.remove(at: str3.index(str3.startIndex, offsetBy: 2)) // delete: C
        yxc_debugPrint(str3)

        // 删除最后一个字符
        var str4 = "ABC"
        str4.removeLast()
        // str4.remove(at: str4.index(str4.endIndex, offsetBy: -1))
        yxc_debugPrint(str4)

        // 删除所有内容
        var str5 = "ABCDEFGH"
        str5.removeAll()

        // 删除头尾指定位数内容
        var str6 = "ABCDEFGH"
        str6.removeFirst(2)
        str6.removeLast(2)
        yxc_debugPrint(str6) // CDEF
    }

    /// 判断字符串相等
    private func equalString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = "Hello World"

        // 需要知道大小, 枚举 ComparisonResult -1 0 1
        let isSame = str1.compare(str3)
        yxc_debugPrint(isSame.rawValue) // -1
        yxc_debugPrint(str1.compare(str2).rawValue) // 0

        // 只需要知道内容是否相等
        yxc_debugPrint(str1 == str2)
    }

    /// 判断字符串包含另一个字符串
    private func containString() {
        let str1 = "Hello"
        let str2 = "Hello World"
        let result = str2.contains(str1)
        yxc_debugPrint(result)
    }

    /// 字符串分割
    private func splitString() {
        let str1 = "Hello World"
        let strAry = str1.split(separator: " ")
        yxc_debugPrint(strAry)
    }

    /// 数组拼接字符串
    private func joinString() {
        let tArry = ["Hello", "World"]
        let str1 = tArry.joined()
        yxc_debugPrint(str1)

        let str2 = tArry.joined(separator: " : ")
        yxc_debugPrint(str2)
    }

    /// 字符串截取
    private func subString() {
        // 头部截取
        let str1 = "asdfghjkl;"
        let str2 = str1.prefix(2)
        yxc_debugPrint(str2) // as

        // 尾部截取
        let str3 = str1.suffix(3)
        yxc_debugPrint(str3) // kl;

        // range 截取
        let indexStart4 = str1.index(str1.startIndex, offsetBy: 3)
        let indexEnd4 = str1.index(str1.startIndex, offsetBy: 5)
        let str4 = str1[indexStart4 ... indexEnd4]
        yxc_debugPrint(str4) // fgh

        // 获取指定位置字符串
        let range = str1.range(of: "jk")
        yxc_debugPrint(str1[str1.startIndex ..< range!.lowerBound]) // asdfgh
        yxc_debugPrint(str1[str1.startIndex ..< range!.upperBound]) // asdfghjk

        let greeting = "Hello, world!"
        let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
        let beginning = greeting[..<index]
        // beginning is "Hello"
        yxc_debugPrint("beginning: \(String(beginning))")
    }

    /// 字符串替换
    private func replateString() {
        let str1 = "all the world"
        let str2 = str1.replacingOccurrences(of: "all", with: "haha")
        yxc_debugPrint(str2)
    }

    /// 字符串插入
    private func insertString() {
        var str1 = "ABCDEFGH"
        // 单个字符
        str1.insert("X", at: str1.index(str1.startIndex, offsetBy: 6))
        yxc_debugPrint(str1)

        // 多个字符
        str1.insert(contentsOf: "888", at: str1.index(before: str1.endIndex))
        yxc_debugPrint(str1)

        let multiplier = 3
        let str2 = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        yxc_debugPrint(str2)
    }

    /// 字符串删除某段内容
    private func deleteInfoByString() {
        var str1 = "ABCDEFGH"
        let startIndex = str1.index(str1.startIndex, offsetBy: 2)
        let endIndex = str1.index(str1.endIndex, offsetBy: -2)
        str1.removeSubrange(startIndex ... endIndex)
        yxc_debugPrint(str1) // ABH
    }

    private func convertData() {
        // Convert Int To String
        let tInt = 10
        let sValue = String(tInt)

        // Convert String to Int
        let sData = "10"
        let iData = Int(sData)

        yxc_debugPrint("sValue:\(sValue), iData:\(iData ?? 0)")
    }

    // MARK: - Array

    public func arrayAction() {
        printEnter(message: "Array")

        // Create an Empty Array
        let someInts = [Int]()
        let threeDouble = Array(repeating: 0.0, count: 3)
        var numbers = [21, 34, 54, 12]
        var evenNumbers = [4, 6, 8]
        yxc_debugPrint("Array, someInts:\(someInts), threeDouble:\(threeDouble)")

        // Add Elements to an Array
        numbers.append(32)
        numbers.append(contentsOf: evenNumbers)
        numbers.insert(32, at: 1)
        yxc_debugPrint("Array, Add numbers:\(numbers)")

        // Modify the Elements of an Array
        numbers[1] = 16

        yxc_debugPrint("Array, Modify numbers:\(numbers)")

        // Remove an Element
        numbers.removeLast()
        evenNumbers.removeAll()
        numbers.remove(at: 1)
        yxc_debugPrint("Array, Remove numbers:\(numbers), evenNumbers:\(evenNumbers)")

        /// Other Array Methods
        // sort()     sorts array elements
        // shuffle()  changes the order of array elements
        // forEach()  calls a function for each element
        // contains() searches for the element in an array
        // swapAt()   exchanges the position of array elements
        // reverse()  reverses the order of array elements

        // Looping Through Array
        for num in numbers {
            yxc_debugPrint(num)
        }

        // Find Number of Array Elements
        yxc_debugPrint("Array, Number: \(numbers.count)")

        // Check if an Array is Empty
        yxc_debugPrint("Array, Empty: \(evenNumbers.isEmpty)")

        // Array With Mixed Data Types
        let address: [Any] = ["Scranton", 570]
        yxc_debugPrint("Array, address: \(address)")
        
        // 倒叙循环
        for year in stride(from:2022, through: 2019, by: -1) {
            yxc_debugPrint("year: \(year)")
        }
    }

    // MARK: - Dictionaries

    public func dictionaryAction() {
        printEnter(message: "Dictionary")

        // Create a dictionary
        var capitalCity = ["Nepal": "Kathmandu", "Italy": "Rome", "England": "London"]
        var studentID = [111: "Eric", 112: "Kyle", 113: "Butters"]
        let emptyDictionary = [Int: String]()
        yxc_debugPrint("Dictionary, capitalCity: \(capitalCity)")
        yxc_debugPrint("Dictionary, studentID: \(studentID)")
        yxc_debugPrint("Dictionary, emptyDictionary: \(emptyDictionary)")

        // Add Elements
        capitalCity["Japan"] = "Tokyo"
        yxc_debugPrint("Dictionary, Add \(capitalCity)")

        // Change Value of Dictionary
        studentID[112] = "Stan"
        yxc_debugPrint("Dictionary, Change \(studentID)")

        // Access Elements
        yxc_debugPrint("Dictionary, Access keys: \(Array(capitalCity.keys))")
        yxc_debugPrint("Dictionary, Access values: \(Array(capitalCity.values))")

        // Remove an Element
        let removedValue = studentID.removeValue(forKey: 112)
        yxc_debugPrint("Dictionary, Remove \(String(describing: removedValue))")

        /// Other Dictionary Methods
        // sorted()         sorts dictionary elements
        // shuffled()       changes the order of dictionary elements
        // contains()       checks if the specified element is present
        // randomElement()  returns a random element from the dictionary
        // firstIndex()     returns the index of the specified element

        // Iterate Over a Dictionary
        let ariPorts: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

        for (key, value) in ariPorts {
            yxc_debugPrint("\(key): \(value)")
        }

        // Find Number of Dictionary Elements
        yxc_debugPrint("Dictionary, Number \(studentID.count)")
    }

    // MARK: - sets

    public func setAction() {
        printEnter(message: "Set")

        // Create a Set
        var studentID: Set<Int> = [112, 114, 116, 118, 115]
        let emptySet = Set<Int>()
        yxc_debugPrint("Set, emptySet: \(emptySet)")

        // Add Elements
        studentID.insert(113)
        yxc_debugPrint("Set, insert: \(studentID)")

        // Remove an Element
        let removedValue = studentID.remove(115)
        var languages: Set = ["Swift", "Java", "Python"]
        languages.removeAll()
        yxc_debugPrint("Set, remove: \(String(describing: removedValue)), languages:\(languages)")

        // Other Set Methods
        // sorted()          sorts set elements
        // forEach()         performs the specified actions on each element
        // contains()        searches the specified element in a set
        // randomElement()   returns a random element from the set
        // firstIndex()      returns the index of the given element

        // Iterate Over a Set
        let fruits: Set = ["Apple", "Peach", "Mango"]
        for fruit in fruits {
            yxc_debugPrint("Set, fruit: \(fruit)")
        }

        // Find Number of Set Elements
        yxc_debugPrint("Set, count: \(fruits.count)")

        // Union of Two Sets
        let setA: Set = [1, 3, 5]
        let setB: Set = [0, 1, 2, 3, 4]
        yxc_debugPrint("Set, setA: \(setA)")
        yxc_debugPrint("Set, setB: \(setB)")
        yxc_debugPrint("Set, A union B: \(Array(setA.union(setB)).sorted())")

        // Intersection between Two Sets
        yxc_debugPrint("Set, A intersection B: \(setA.intersection(setB))")

        // The difference between two sets A and B include elements of set A that are not present on set B.
        yxc_debugPrint("Set, B subtracting A: \(setB.subtracting(setA))")

        // The symmetric difference between two sets A and B includes all elements of A and B without the common elements.
        yxc_debugPrint("Set, A symmetric difference B: \(setA.symmetricDifference(setB))")

        // Check Subset of a Set
        let setC: Set = [1, 2, 3, 5, 4]
        let setD: Set = [1, 2]
        print("Set, D subset C: ", setD.isSubset(of: setC))

        let setE: Set = [2, 1]
        if setD == setE {
            print("Set D and Set E are equal")
        } else {
            print("Set D and Set E are different")
        }
    }

    // MARK: - Tuple

    public func tupleAction() {
        printEnter(message: "Tuple")
        // Create A Tuple
        var product = ("MacBook", 1099.99)
        yxc_debugPrint("Tuple, product: \(product)")

        // Access Tuple
        yxc_debugPrint("Tuple, access, Name: \(product.0), Price:\(product.1)")

        // Modify Tuple
        product.1 = 1299.99
        yxc_debugPrint("Tuple, modify, Name: \(product.0), Price:\(product.1)")

        // Named Tuples
        let company = (product: "Programiz App", version: 2.1)
        yxc_debugPrint("Tuple, name, company: \(company.product), version:\(company.version)")
    }

    // MARK: - swift-algorithms

    // 用法参考：[apple/swift-algorithms](https://github.com/apple/swift-algorithms)
    public func swiftAlgorithms() {
        printEnter(message: "swift-algorithms")

        // let numbers = [1, 2, 3, 3, 2, 3, 3, 2, 2, 2, 1]
        // let unique = numbers.uniqued()
        // yxc_debugPrint("Array(unique): \(Array(unique))") // [1, 2, 3]
    }

    // MARK: - UI

    func setupUI() {
        title = "Function"
        showToast("console logs")

        stringFunction()
        arrayAction()
        dictionaryAction()
        setAction()
        tupleAction()
        swiftAlgorithms()
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property
}
