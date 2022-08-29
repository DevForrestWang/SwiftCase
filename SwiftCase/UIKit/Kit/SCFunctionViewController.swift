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

import CryptoSwift
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
        checkString()

        // Other Built-in Functions
        // isEmpty        determines if a string is empty or not
        // capitalized    capitalizes the first letter of every word in a string
        // uppercased()   converts string to uppercase
        // lowercase()    converts string to lowercase
        // hasPrefix()    determines if a string starts with certain characters or not
        // hasSuffix()    determines if a string ends with certain characters or not
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

        // 首字母大写，
        yxc_debugPrint("wo xiao wo ku".capitalized) // Wo Xiao Wo Ku
        yxc_debugPrint("已选择: \("已选择".transformToPinYin())")

        // 查找字符串位置
        let letters = "abcdefg"

        let char: Character = "c"
        if let distance = letters.distance(of: char) {
            yxc_debugPrint("character \(char) was found at position #\(distance)") // "character c was found at position #2\n"
        } else {
            yxc_debugPrint("character \(char) was not found")
        }

        let string = "cde"
        if let distance = letters.distance(of: string) {
            yxc_debugPrint("string \(string) was found at position #\(distance)") // "string cde was found at position #2\n"
        } else {
            yxc_debugPrint("string \(string) was not found")
        }

        // md5 使用
        let password = "your password"
        yxc_debugPrint("The \(password) md5: \(password.md5())")

        yxc_debugPrint("localized: \("string_id".localized)")
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

        //
        yxc_debugPrint("\(greeting), first 4:\(String(greeting[...4]))")
        yxc_debugPrint("\(greeting), 3-4:\(String(greeting[3 ... 4]))")
        yxc_debugPrint("\(greeting), from 7:\(String(greeting[7...]))")
        yxc_debugPrint("\(greeting), substring 1:\(String(greeting[1]))")
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

    private func checkString() {
        let a1 = "12345".containsOnlyDigits // true
        let a2 = "a12345".containsOnlyDigits // false
        yxc_debugPrint("containsOnlyDigits: \(a1)-\(a2)")

        let b1 = "abcde".containsOnlyLetters // true
        let b2 = "abcde1".containsOnlyLetters // false
        yxc_debugPrint("containsOnlyLetters: \(b1)-\(b2)")

        let c1 = "abcde12345".isAlphanumeric // true
        let c2 = "abcde.12345".isAlphanumeric // false
        yxc_debugPrint("isAlphanumeric: \(c1)-\(c2)")

        // 为空检查
        let spaceStr = "     "
        let newLine = "\n"
        yxc_debugPrint("space: \(spaceStr.isBlank)-newLine:\(newLine.isBlank)")
    }

    // MARK: - Array

    public func arrayAction() {
        printEnter(message: "Array")

        // Create an Empty Array
        let someInts = [Int]()
        let threeDouble = Array(repeating: 0.0, count: 3)

        // 数组的初始
        var numbers = [21, 34, 54, 12]
        var evenNumbers = [4, 6, 8]
        yxc_debugPrint("Array, someInts:\(someInts), threeDouble:\(threeDouble)")

        let initArray = Array(0 ... 20)
        yxc_debugPrint("initArray: \(initArray)")

        // Add Elements to an Array
        numbers.append(32)
        numbers.append(contentsOf: evenNumbers)
        numbers += [1, 2, 3]
        numbers.insert(32, at: 1)
        yxc_debugPrint("Array, Add numbers:\(numbers)")
        yxc_debugPrint("find 5, result: \(numbers.contains(5))")

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

        // 0到9
        for i in 0 ..< 10 {
            yxc_debugPrint(i)
        }

        // 0到10
        for i in 0 ... 10 {
            yxc_debugPrint(i)
        }

        // 反向遍历
        for i in (0 ..< 10).reversed() {
            yxc_debugPrint(i)
        }

        for num in numbers {
            yxc_debugPrint(num)
        }

        // 同时遍历索引和元素
        for (index, num) in numbers.enumerated() {
            yxc_debugPrint("\(index): \(num)")
        }

        numbers.forEach { num in
            yxc_debugPrint(num)
        }

        // 倒叙循环
        for year in stride(from: 2022, through: 2019, by: -1) {
            yxc_debugPrint("year: \(year)")
        }

        // Find Number of Array Elements
        yxc_debugPrint("Array, Number: \(numbers.count)")

        // Check if an Array is Empty
        yxc_debugPrint("Array, Empty: \(evenNumbers.isEmpty)")

        // Array With Mixed Data Types
        let address: [Any] = ["Scranton", 570]
        yxc_debugPrint("Array, address: \(address)")

        // 数组的索引
        yxc_debugPrint("startIndex and EndIndex: \(numbers[numbers.startIndex ..< numbers.endIndex])")

        // filter
        let numAry = numbers.filter { $0 > 10 }
        yxc_debugPrint("filter more 10: \(numAry)")

        let arry = ["123Z", "456Z", "789"]
        let num2Ary = arry.filter { str -> Bool in
            str.contains("Z")
        }
        yxc_debugPrint("filter contain Z: \(num2Ary)")

        // map 将原来数组元素映射到新数组中；映射数组、转换元素
        let mapAry1 = numbers.map { num -> String in
            "\(num)Z"
        }
        yxc_debugPrint("Map add Z: \(mapAry1)")

        let mapAry2 = (1 ... 5).map { $0 * 3 }
        yxc_debugPrint("map multiplicat 3: \(mapAry2)")

        // compactMap 空值过滤，去掉数组中nil元素
        let latMapAry = ["1", "2", "3", nil].compactMap { $0 }
        yxc_debugPrint("Filter nil: \(latMapAry)")

        // compactMap 强制解包
        let baseFlat: [String?] = ["123", "456", "789"]
        yxc_debugPrint("map: \(baseFlat.map { $0 })")
        yxc_debugPrint("flatMap: \(baseFlat.compactMap { $0 })")

        // 嵌套数组的压平
        let baseFlat2 = [[1], [2], [3, 4], [5, 6]]
        yxc_debugPrint("\(baseFlat2.compactMap { $0 })")

        // reduce 把数组变成一个元素， 初始化值、闭包规则
        yxc_debugPrint("1...5 = \((1 ... 5).reduce(0, +))")

        let reduceAry2 = numbers.reduce("strengthen") { a1, a2 -> String in
            "\(a1)" + "\(a2)"
        }
        yxc_debugPrint("number + strengthen:  \(reduceAry2)")

        yxc_debugPrint("numbers first 3:  \(numbers.prefix(upTo: 3))")
        yxc_debugPrint("numbers from 3:  \(numbers.suffix(from: 3))")

        // 从头部开始的3个元素
        yxc_debugPrint("delete first 3 nums:  \(numbers.dropFirst(3))")

        yxc_debugPrint("delete last 3 nums:  \(numbers.dropLast(3))")
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

        // 是否包含key
        let hasKey = capitalCity.keys.contains("Italy")
        yxc_debugPrint("Dictionary, capitalCity contains, Italy: \(hasKey)")

        let hasKey2 = capitalCity.contains(key: "Italy")
        yxc_debugPrint("Dictionary, capitalCity contains, Italy: \(hasKey2)")

        // 字典取值
        yxc_debugPrint("Dictionary read, Key:Italy, value: \(capitalCity["Italy"] ?? "")")

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

        let dicString = "{\"cmd\":\"CustomCmdMsg\",\"data\":{\"cmdType\":\"4\",\"msg\":{\"fileReturnId\":\"F00AgKdVBvCR1TZyBTJrD1T\",\"imgUrl\":\"https://dc.aadv.net:10443/fsServerUrl/fs/download/F00AgKdVBvCR1TZyBTJrD1T\"},\"userId\":\"0121400015000020000\",\"userInfo\":{\"groupId\":\"11202112091420160000060113\",\"userName\":\"测试二号\",\"userAvatar\":\"F00AgKdVBvCR1ThXBTVfC1T\",\"entCustId\":\"0121400015020211117\",\"custId\":\"0121400015000020000\",\"resNo\":\"01214000150\",\"operNo\":\"0002\",\"levelName\":\"店员\",\"levelImg\":\"user_icon.png\"},\"sendTime\":\"2022-05-27 17:43:57\"}}"

        let dicObj = dicString.toDictionary()
        yxc_debugPrint("string to dictionary: \(dicObj.toJsonString() ?? "")")
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
        yxc_debugPrint("Set, D subset C: ", setD.isSubset(of: setC))

        let setE: Set = [2, 1]
        if setD == setE {
            yxc_debugPrint("Set D and Set E are equal")
        } else {
            yxc_debugPrint("Set D and Set E are different")
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

    public func changeNunber() {
        let value1 = 4.0
        let value2 = 4.2
        let value3 = 4.5
        let value4 = 4.7

        yxc_debugPrint("raw   value: \(value1) \(value2) \(value3) \(value4)")
        // floor向下取整
        yxc_debugPrint("floor value: \(floor(value1)) \(floor(value2)) \(floor(value3)) \(floor(value4))")
        // ceil 向上取整
        yxc_debugPrint("ceil  value: \(ceil(value1)) \(ceil(value2)) \(ceil(value3)) \(ceil(value4))")
        // round 四舍五入取整
        yxc_debugPrint("round value: \(round(value1)) \(round(value2)) \(round(value3)) \(round(value4))")
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
        changeNunber()

        let monthDic = SCUtils.generatorMonths(baseYear: 2021, baseMonth: 9)
        yxc_debugPrint("the monthDic:\(monthDic)")

        let maxDay = SCUtils.lastDay(yearAndMonth: "2021-02", separateFlag: "-", isCurentDay: true)
        yxc_debugPrint("2021-02 max day:\(maxDay)")
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property
}
