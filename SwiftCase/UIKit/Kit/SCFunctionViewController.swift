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
            SC.log("I've been injected: \(self)")
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
        parseJson()
        stringSeparator()

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
        SC.printEnter(message: "String")

        // 多行字符串字面量
        let quotation = """
        The White Rabbit put on his spectacles.  "Where shall I begin,
        please your Majesty?" he asked.

        "Begin at the beginning," the King said gravely, "and go on
        till you come to the end; then stop."
        """
        SC.log(quotation)

        SC.log("0.01: \("0.01".isPureFloat())")
        SC.log("1.00: \("1.00".isPureFloat())")
        SC.log("2a: \("2a".isPureFloat())")

        SC.log("2: \("2".isPureInt())")
        SC.log("2.1: \("2.1".isPureInt())")
    }

    /// 字符串拼接
    private func appentString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = str1 + " " + str2
        SC.log(str3)

        var str4 = "Hello"
        str4.append(" Word")
        SC.log(str4)
    }

    ///  字符串格式化
    private func formatString() {
        let str1 = String(2)
        let str2 = String(5.0)
        let str3 = str1 + str2
        SC.log(str3)

        let str4 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        SC.log(str4)

        // [String Format Specifiers](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
        let s1 = "lazy"
        SC.log(String(format: "%@ boy %.2f", s1, 12.344))

        // 不足两位前面补0
        SC.log(String(format: "%02d", 1))
        SC.log(String(format: "%02d", 11))
    }

    /// 获取字符串长度
    private func lengthString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        SC.log(str1.count)
    }

    private func emptyString() {
        let str1 = "Swift"
        let str2 = ""

        SC.log(str1.isEmpty)
        SC.log(str2.isEmpty)
    }

    /// 遍历字符串
    private func iterationString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        for char in str1 {
            SC.log(char)
        }
    }

    /// 字符串操作
    private func operationString() {
        //  获取首字符
        let str1 = "Swift"
        SC.log(str1[str1.startIndex])

        // 删除首字符
        var str2 = "ABC"
        str2.removeFirst() // str2.remove(at: str2.startIndex)
        SC.log(str2)

        // 删除指定位置
        var str3 = "ABCDEFGH"
        str3.remove(at: str3.index(str3.startIndex, offsetBy: 2)) // delete: C
        SC.log(str3)

        // 删除最后一个字符
        var str4 = "ABC"
        str4.removeLast()
        // str4.remove(at: str4.index(str4.endIndex, offsetBy: -1))
        SC.log(str4)

        // 删除所有内容
        var str5 = "ABCDEFGH"
        str5.removeAll()

        // 删除头尾指定位数内容
        var str6 = "ABCDEFGH"
        str6.removeFirst(2)
        str6.removeLast(2)
        SC.log(str6) // CDEF

        // 首字母大写，
        SC.log("wo xiao wo ku".capitalized) // Wo Xiao Wo Ku
        SC.log("已选择: \("已选择".transformToPinYin())")

        // 查找字符串位置
        let letters = "abcdefg"

        let char: Character = "c"
        if let distance = letters.distance(of: char) {
            SC.log("character \(char) was found at position #\(distance)") // "character c was found at position #2\n"
        } else {
            SC.log("character \(char) was not found")
        }

        let string = "cde"
        if let distance = letters.distance(of: string) {
            SC.log("string \(string) was found at position #\(distance)") // "string cde was found at position #2\n"
        } else {
            SC.log("string \(string) was not found")
        }

        // md5 使用
        let password = "your password"
        SC.log("The \(password) md5: \(password.md5)")

        SC.log("localized: \("string_id".localized)")
    }

    /// 判断字符串相等
    private func equalString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = "Hello World"

        // 需要知道大小, 枚举 ComparisonResult -1 0 1
        let isSame = str1.compare(str3)
        SC.log(isSame.rawValue) // -1
        SC.log(str1.compare(str2).rawValue) // 0

        // 只需要知道内容是否相等
        SC.log(str1 == str2)
    }

    /// 判断字符串包含另一个字符串
    private func containString() {
        let str1 = "Hello"
        let str2 = "Hello World"
        let result = str2.contains(str1)
        SC.log(result)
    }

    /// 字符串分割
    private func splitString() {
        let str1 = "Hello World"
        let strAry = str1.split(separator: " ")
        SC.log(strAry)
    }

    /// 数组拼接字符串
    private func joinString() {
        let tArry = ["Hello", "World"]
        let str1 = tArry.joined()
        SC.log(str1)

        let str2 = tArry.joined(separator: " : ")
        SC.log(str2)
    }

    /// 字符串截取
    private func subString() {
        // 头部截取
        let str1 = "asdfghjkl;"
        let str2 = str1.prefix(2)
        SC.log(str2) // as

        // 尾部截取
        let str3 = str1.suffix(3)
        SC.log(str3) // kl;

        // range 截取
        let indexStart4 = str1.index(str1.startIndex, offsetBy: 3)
        let indexEnd4 = str1.index(str1.startIndex, offsetBy: 5)
        let str4 = str1[indexStart4 ... indexEnd4]
        SC.log(str4) // fgh

        // 获取指定位置字符串
        let range = str1.range(of: "jk")
        SC.log(str1[str1.startIndex ..< range!.lowerBound]) // asdfgh
        SC.log(str1[str1.startIndex ..< range!.upperBound]) // asdfghjk

        let greeting = "Hello, world!"
        let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
        let beginning = greeting[..<index]
        // beginning is "Hello"
        SC.log("beginning: \(String(beginning))")

        //
        SC.log("\(greeting), first 4:\(String(greeting[...4]))")
        SC.log("\(greeting), 3-4:\(String(greeting[3 ... 4]))")
        SC.log("\(greeting), from 7:\(String(greeting[7...]))")
        SC.log("\(greeting), substring 1:\(String(greeting[1]))")

        // 字符串截取
        let str = "123456789"
        let start = str.startIndex // 表示str的开始位置
        let startOffset = str.index(start, offsetBy: 2) // 表示str的开始位置 + 2
        let endOffset = str.index(str.endIndex, offsetBy: -2) // 表示str的结束位置 - 2
        SC.log(str[start]) // 输出 1 第1个字符
        SC.log(str[startOffset]) // 输出 3 第3个字符
        SC.log(str[endOffset]) // 输出 8 第8个字符（10-2）

        let mainStr = "Strengthen"
        let findIndex = (mainStr.distance(of: "eng") ?? 0) + "eng".count
        SC.log("\(mainStr.substring(from: findIndex))")

        // 字符串截取
        let stText = "www.stackoverflow.com/questions/28182441/swift-how-to-get-substring-from-start-to-last-index-of-character"
        SC.log("subStirng:\(stText)")
        SC.log(stText.character(3)) // .
        SC.log(stText.substring(0 ..< 3)) // www
        SC.log(stText.substring(from: 4)) // stackoverflow.com...
        SC.log(stText.substring(to: 16)) // www.stackoverflow
        SC.log(stText.between(".", ".") ?? "") // stackoverflow
        SC.log(stText.lastIndexOfCharacter(".") ?? "") // 17
    }

    /// 字符串替换
    private func replateString() {
        let str1 = "all the world"
        let str2 = str1.replacingOccurrences(of: "all", with: "haha")
        SC.log(str2)
    }

    /// 字符串插入
    private func insertString() {
        var str1 = "ABCDEFGH"
        // 单个字符
        str1.insert("X", at: str1.index(str1.startIndex, offsetBy: 6))
        SC.log(str1)

        // 多个字符
        str1.insert(contentsOf: "888", at: str1.index(before: str1.endIndex))
        SC.log(str1)

        let multiplier = 3
        let str2 = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        SC.log(str2)
    }

    /// 字符串删除某段内容
    private func deleteInfoByString() {
        var str1 = "ABCDEFGH"
        let startIndex = str1.index(str1.startIndex, offsetBy: 2)
        let endIndex = str1.index(str1.endIndex, offsetBy: -2)
        str1.removeSubrange(startIndex ... endIndex)
        SC.log(str1) // ABH
    }

    private func convertData() {
        // Convert Int To String
        let tInt = 10
        let sValue = String(tInt)

        // Convert String to Int
        let sData = "10"
        let iData = Int(sData)

        SC.log("sValue:\(sValue), iData:\(iData ?? 0)")
    }

    private func checkString() {
        let a1 = "12345".containsOnlyDigits // true
        let a2 = "a12345".containsOnlyDigits // false
        SC.log("containsOnlyDigits: \(a1)-\(a2)")

        let b1 = "abcde".containsOnlyLetters // true
        let b2 = "abcde1".containsOnlyLetters // false
        SC.log("containsOnlyLetters: \(b1)-\(b2)")

        let c1 = "abcde12345".isAlphanumeric // true
        let c2 = "abcde.12345".isAlphanumeric // false
        SC.log("isAlphanumeric: \(c1)-\(c2)")

        // 为空检查
        let spaceStr = "     "
        let newLine = "\n"
        SC.log("space: \(spaceStr.isBlank)-newLine:\(newLine.isBlank)")

        // 邮箱检查
        let strEmail = "test@test.com"
        SC.log("\(strEmail) is email: \(strEmail.isValidEmail)")
    }

    private func parseJson() {
        let dict: [String: Any] = [
            "name": "John",
            "surname": "Doe",
            "age": 31,
        ]
        SC.log(dict) // ["surname": "Doe", "name": "John", "age": 31]

        let json = String(json: dict)
        SC.log(json ?? "") // Optional("{\"surname\":\"Doe\",\"name\":\"John\",\"age\":31}")

        let restoredDict = json?.jsonToDictionary()
        SC.log(restoredDict ?? []) // Optional(["name": John, "surname": Doe, "age": 31])
    }

    private func stringSeparator() {
        var cardNumber = "1234567890123456"
        cardNumber.insert(separator: " ", every: 4)
        SC.log(cardNumber) // 1234 5678 9012 3456

        let pin = "7690"
        let pinWithDashes = pin.inserting(separator: "-", every: 1)
        SC.log(pinWithDashes) // 7-6-9-0
    }

    // MARK: - Array

    public func arrayAction() {
        SC.printEnter(message: "Array")

        // Create an Empty Array
        let someInts = [Int]()
        let threeDouble = Array(repeating: 0.0, count: 3)

        // 数组的初始
        var numbers = [21, 34, 54, 12]
        var evenNumbers = [4, 6, 8]
        SC.log("Array, someInts:\(someInts), threeDouble:\(threeDouble)")

        let initArray = Array(0 ... 20)
        SC.log("initArray: \(initArray)")

        // Add Elements to an Array
        numbers.append(32)
        numbers.append(contentsOf: evenNumbers)
        numbers += [1, 2, 3]
        numbers.insert(32, at: 1)
        SC.log("Array, Add numbers:\(numbers)")
        SC.log("find 5, result: \(numbers.contains(5))")

        // Modify the Elements of an Array
        numbers[1] = 16

        SC.log("Array, Modify numbers:\(numbers)")

        // Remove an Element
        numbers.removeLast()
        evenNumbers.removeAll()
        numbers.remove(at: 1)
        SC.log("Array, Remove numbers:\(numbers), evenNumbers:\(evenNumbers)")

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
            SC.log(i)
        }

        // 0到10
        for i in 0 ... 10 {
            SC.log(i)
        }

        // 反向遍历
        for i in (0 ..< 10).reversed() {
            SC.log(i)
        }

        // 迭代数组
        for num in numbers {
            SC.log(num)
        }

        // 两个长度相等的数组遍历
        do {
            let numberOneAry = [1, 2, 3, 4]
            let numberTwoAry = [4, 5, 6, 7]

            if numberOneAry.count != numberTwoAry.count {
                return
            }

            for (o, t) in zip(numberOneAry, numberTwoAry) {
                SC.log("O:\(o), T:\(t)")
            }
        }

        // 除了第一个元素以外的数组其余部分
        SC.log("dropFirst before, number:\(numbers)")
        for num in numbers.dropFirst() {
            SC.log("dropFirst:\(num)")
        }

        // 返回从头部开始的3个元素
        SC.log("dropFirst(3) before, number:\(numbers)")
        SC.log("dropFirst(3) nums:  \(numbers.dropFirst(3))")
        SC.log("dropFirst(3) after, number:\(numbers)")

        // 返回从尾部开始的除3个元素外的元素
        SC.log("numbers.dropLast(3) before, number:\(numbers)")
        SC.log("numbers.dropLast(3) nums:  \(numbers.dropLast(3))")
        SC.log("numbers.dropLast(3) before, number:\(numbers)")

        // 想要为数组中的所有元素编号
        for (num, element) in numbers.enumerated() {
            SC.log("enumerated: num:\(num), element:\(element)")
        }

        // 想要列举下标和元素？
        for (index, element) in zip(numbers.indices, numbers) {
            SC.log("indices: num:\(index), element:\(element)")
        }

        // 想要寻找一个指定元素的位置？
        if let idx = numbers.firstIndex(where: { $0 == 54 }) {
            SC.log("idx:\(idx)")
        }

        // 同时遍历索引和元素
        for (index, num) in numbers.enumerated() {
            SC.log("\(index): \(num)")
        }

        numbers.forEach { num in
            SC.log(num)
        }

        // 倒叙循环
        for year in stride(from: 2022, through: 2019, by: -1) {
            SC.log("year: \(year)")
        }

        // Find Number of Array Elements
        SC.log("Array, Number: \(numbers.count)")

        // Check if an Array is Empty
        SC.log("Array, Empty: \(evenNumbers.isEmpty)")

        // Array With Mixed Data Types
        let address: [Any] = ["Scranton", 570]
        SC.log("Array, address: \(address)")

        // 数组的索引
        SC.log("startIndex and EndIndex: \(numbers[numbers.startIndex ..< numbers.endIndex])")

        // filter
        let numAry = numbers.filter { $0 > 10 }
        SC.log("filter more 10: \(numAry)")

        let arry = ["123Z", "456Z", "789"]
        let num2Ary = arry.filter { str -> Bool in
            str.contains("Z")
        }
        SC.log("filter contain Z: \(num2Ary)")

        // map 将原来数组元素映射到新数组中；映射数组、转换元素
        let mapAry1 = numbers.map { num -> String in
            "\(num)Z"
        }
        SC.log("Map add Z: \(mapAry1)")

        let mapAry2 = (1 ... 5).map { $0 * 3 }
        SC.log("map multiplicat 3: \(mapAry2)")

        // compactMap 空值过滤，去掉数组中nil元素
        let latMapAry = ["1", "2", "3", nil].compactMap { $0 }
        SC.log("Filter nil: \(latMapAry)")

        // compactMap 强制解包
        let baseFlat: [String?] = ["123", "456", "789"]
        SC.log("map: \(baseFlat.map { $0 })")
        SC.log("flatMap: \(baseFlat.compactMap { $0 })")

        // 嵌套数组的压平
        let baseFlat2 = [[1], [2], [3, 4], [5, 6]]
        SC.log("\(baseFlat2.compactMap { $0 })")

        // reduce 把数组变成一个元素， 初始化值、闭包规则
        SC.log("1...5 = \((1 ... 5).reduce(0, +))")

        let reduceAry2 = numbers.reduce("strengthen") { a1, a2 -> String in
            "\(a1)" + "\(a2)"
        }
        SC.log("number + strengthen:  \(reduceAry2)")

        SC.log("numbers first 3:  \(numbers.prefix(upTo: 3))")
        SC.log("numbers from 3:  \(numbers.suffix(from: 3))")

        // 通过下标获取值
        do {
            let numbers = [21, 34, 54, 12]
            SC.log("numbers[guarded: 1]: \(numbers[guarded: 1] ?? 0)")
            SC.log("numbers[guarded: 5]: \(numbers[guarded: 5] ?? 0)")
            SC.log("numbers[guarded: -1]: \(numbers[guarded: -1] ?? 0)")
            // numbers[guarded: 1]: 34
            // numbers[guarded: 5]: 0
            // numbers[guarded: -1]: 0
        }
    }

    // MARK: - Dictionaries

    public func dictionaryAction() {
        SC.printEnter(message: "Dictionary")

        do {
            // Create a dictionary
            // 初始一个索引为String，值为Int的字典
            let someDict = [String: Int]()
            let someDict2: [String: Int] = [:]
            // 使用Dictionary，初始化索引为String，值为Int的字典
            let someDict3 = [String: Int]()
            let someDict4: [String: Int] = [:]
            // 给定值创建字典
            let someDict5: [String: Int] = ["One": 1, "Two": 2, "Three": 3]
            SC.log("\(someDict), \(someDict2), \(someDict3), \(someDict4), \(someDict5)")

            // 基于序列的初始化
            let cities = ["Delhi", "Bangalore", "Hyderabad"]
            let Distance = [2000, 10, 620]
            // 给定值创建字典的示例, 将创建一个字典，其中城市作为键，距离作为值
            let cityDistanceDict = Dictionary(uniqueKeysWithValues: zip(cities, Distance))
            SC.log("cityDistanceDict: \(cityDistanceDict)")
            // ["Hyderabad": 620, "Bangalore": 10, "Delhi": 2000]

            // 字典过滤
            let closeCities = cityDistanceDict.filter { $0.value < 1000 }
            SC.log("closeCities: \(closeCities)")
            // ["Bangalore": 10, "Hyderabad": 620]
        }

        // 字典分组
        do {
            let cities = ["Delhi", "Bangalore", "Hyderabad", "Dehradun", "Bihar"]
            // 根据第一个字母对字典的值进行分组
            let groupedCities = Dictionary(grouping: cities) { $0.first! }
            SC.log("groupedCities: \(groupedCities)")
            // ["B": ["Bangalore", "Bihar"], "D": ["Delhi", "Dehradun"], "H": ["Hyderabad"]]
        }

        // 访问字典
        do {
            let someDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]
            let someVar = someDict[1]
            SC.log("Value of key = 1 is \(someVar ?? "")")
            SC.log("Value of key = 2 is \(someDict[2] ?? "")")
        }

        // 添加、修改词典
        do {
            var someDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]
            let oldVal = someDict.updateValue("New value of one", forKey: 1)
            let newVal = someDict[1]

            // 通过在给定键处分配新值来修改字典的现有元素，
            someDict[2] = "New value of one"

            // 添加数据
            someDict[4] = "Four"
            SC.log("Old value of key = 1 is \(oldVal ?? "")")
            SC.log("Value of key = 1 is \(newVal ?? "")")
            SC.log("Value of key = 2 is \(someDict[2] ?? "")")
            SC.log("Value of key = 4 is \(someDict[4] ?? "")")
        }

        // 删除键值对
        do {
            var someDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]
            // 使用 removeValueForKey（）删除键值对，如果存在并返回已删除的值，不存在值，则返回nil
            let removedValue = someDict.removeValue(forKey: 2)
            // 使用下标语法从字典中删除键值对，方法是为该键分配值 nil
            someDict[3] = nil

            SC.log("removedValue is \(removedValue ?? "")")
            SC.log("Value of key = 1 is \(someDict[1] ?? "nil")")
            SC.log("Value of key = 2 is \(someDict[2] ?? "nil")")
            SC.log("Value of key = 3 is \(someDict[3] ?? "nil")")
        }

        // 遍历字典
        do {
            let someDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]

            // 使用 for-in 循环遍历字典中的整个键值对集
            for (index, keyValue) in someDict {
                SC.log("Dictionary key \(index) - Dictionary value \(keyValue)")
            }

            // 使用 enumerate（）函数，该函数返回项目的索引及其（键、值）对
            for (key, value) in someDict.enumerated() {
                SC.log("Dictionary, enumerated key \(key) - Dictionary value \(value)")
            }

            // 只要健名不要值
            for key in someDict.keys {
                SC.log("Dictionary key \(key)")
            }

            // 只要值，不要键名
            for value in someDict.values {
                SC.log("Dictionary value \(value)")
            }

            // dictionary 转为 元组
            let result = someDict.map { key, value in
                SC.log("Dictionary, map key:\(key), value: \(value)")
                return (key, value)
            }

            if result.count > 0 {
                SC.log("key:\(result[0].0), value:\(result[0].1)")
            }
        }

        // 转换为数组
        do {
            let someDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]

            let dictKeys = [Int](someDict.keys)
            let dictValues = [String](someDict.values)

            SC.log("Dictionary Keys: \(dictKeys)")
            SC.log("Dictionary Values: \(dictValues)")
            // Dictionary Keys: [3, 2, 1]
            // Dictionary Values: ["Three", "Two", "One"]
        }

        // 计数属性
        do {
            let someDict1: [Int: String] = [1: "One", 2: "Two", 3: "Three"]
            SC.log("Total items in someDict1 = \(someDict1.count)")
            // Total items in someDict1 = 3
        }

        // 空属性
        do {
            let someDict1: [Int: String] = [1: "One", 2: "Two", 3: "Three"]
            let someDict2: [Int: String] = .init()
            SC.log("someDict1 = \(someDict1.isEmpty)")
            SC.log("someDict2 = \(someDict2.isEmpty)")
            // someDict1 = false
            // omeDict2 = true
        }

        // key或value是否包含某个值
        do {
            let someDict = ["Nepal": "Kathmandu", "Italy": "Rome", "England": "London"]

            let hasKey = someDict.keys.contains("Italy")
            let hasKey2 = someDict.contains(key: "Italy2")
            let hasValue = someDict.values.contains("Kathmandu")

            SC.log("Dictionary, contains, hasKey: \(hasKey)")
            SC.log("Dictionary, contains, hasKey2: \(hasKey2)")
            SC.log("Dictionary, contains, hasValue: \(hasValue)")
            // Dictionary, contains, hasKey: true
            // Dictionary, contains, hasKey2: false
            // Dictionary, contains, hasValue: true
        }

        // 使用merge进行合并的键值对
        do {
            var settingDic: [String: String] = [
                "Age": "20",
                "Name": "My iPhone",
            ]

            let overriddenSetDic = ["Name": "Jane's iPhone"]
            // 合并策略 $1，使用overriddenSetDic值覆盖
            settingDic.merge(overriddenSetDic, uniquingKeysWith: { $1 })
            SC.log("settingDic:\(settingDic)")
        }

        // 使用mapValues，保持字典的结构，只对其中的值进行变换
        do {
            enum Setting {
                case text(String)
                case int(Int)
                case bool(Bool)
            }
            let defaultSettings: [String: Setting] = [
                "Airplane Mode": .bool(false),
                "Name": .text("My iPhone"),
                "Age": .int(20),
            ]

            let settingsAsStrings = defaultSettings.mapValues { value -> String in
                // 值进行转换
                switch value {
                case let .text(text): return text
                case let .int(number): return String(number)
                case let .bool(value): return String(value)
                }
            }
            SC.log("settingsAsStrings:\(settingsAsStrings)")
            // ["Airplane Mode": "false", "Name": "My iPhone", "Age": "20"]
        }

        // 字符串json转字典，及字典转字符串
        do {
            let dicString = "{\"cmd\":\"CustomCmdMsg\",\"data\":{\"cmdType\":\"4\",\"msg\":{\"fileReturnId\":\"F00AgKdVBvCR1TZyBTJrD1T\",\"imgUrl\":\"https://dc.aadv.net:10443/fsServerUrl/fs/download/F00AgKdVBvCR1TZyBTJrD1T\"},\"userId\":\"0121400015000020000\",\"userInfo\":{\"groupId\":\"11202112091420160000060113\",\"userName\":\"测试二号\",\"userAvatar\":\"F00AgKdVBvCR1ThXBTVfC1T\",\"entCustId\":\"0121400015020211117\",\"custId\":\"0121400015000020000\",\"resNo\":\"01214000150\",\"operNo\":\"0002\",\"levelName\":\"店员\",\"levelImg\":\"user_icon.png\"},\"sendTime\":\"2022-05-27 17:43:57\"}}"

            let dicObj = dicString.jsonToDictionary()
            SC.log("string to dictionary: \(dicObj?.toJsonString() ?? "")")
        }
    }

    public func saveDataAction() {
        let age = 25
        age.store(key: "age")
        SC.log(Int(key: "age") ?? 0) // Optional(25)
        SC.log(Float(key: "age") ?? 0) // Optional(25.0)
        SC.log(String(key: "age") ?? 0) // Optional("25")
        SC.log(String(key: "age1") ?? "") // nil

        let dict: [String: Any] = [
            "name": "John",
            "surname": "Doe",
            "occupation": "Swift developer",
            "experienceYears": 5,
            "age": 32,
        ]
        dict.store(key: "employee")
        SC.log(Dictionary(key: "employee") ?? [])
    }

    // MARK: - sets

    public func setAction() {
        SC.printEnter(message: "Set")

        // Set 遵守 ExpressibleByArrayLiteral 协议，可以用数组字面量的方式初始化一个集合
        do {
            let naturals: Set = [1, 2, 3, 2]
            SC.log("naturals:\(naturals)")
            SC.log("contains(3):\(naturals.contains(3))")
            SC.log("contains(0):\(naturals.contains(0))")
            // naturals:[2, 1, 3]
            // contains(3):true
            // contains(0):false

            let emptySet = Set<Int>()
            SC.log("Set, emptySet: \(emptySet)")
        }

        // 集合插入、删除
        do {
            var languages: Set = ["Swift", "Java", "Python"]
            // 插入元素
            languages.insert("C++")
            SC.log("Set insert: \(languages)")
            // Set insert: ["Java", "Python", "Swift", "C++"]

            // 删除原生
            let removedValue = languages.remove("Java") ?? ""
            SC.log("Set remove: \(removedValue)")
            // Set remove: Java

            languages.removeAll()
            SC.log("Set removeAll:\(languages)")
            // Set removeAll:[]
        }

        // 遍历集合、个数
        do {
            let languages: Set = ["Swift", "Java", "Python", "go", "C++"]
            for lang in languages {
                SC.log("Set language: \(lang)")
            }
            // Set language: Swift
            // Set language: Java
            // ...

            SC.log("Set count: \(languages.count)")
            // Set count: 5
        }

        // 在一个集合中求另一个集合的补集(A 集合减去B集合)
        do {
            let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
            let discontinuedIPods: Set = ["iPod mini", "iPod Classic", "iPod nano", "iPod shuffle"]
            let currentIPods = iPods.subtracting(discontinuedIPods)
            SC.log("currentIPods: \(currentIPods)")
            // currentIPods: ["iPod touch"]
        }

        // 求两个集合的交集，找出两个集合中都含有的元素
        do {
            let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
            let touchscreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
            let iPodsWithTouch = iPods.intersection(touchscreen)
            SC.log("iPodsWithTouch: \(iPodsWithTouch)")
            // iPodsWithTouch: ["iPod nano", "iPod touch"]
        }

        // 两个集合的并集，将两个集合合并为一个集合，使用formUnion改变原来的集合；union返回合并集合
        do {
            var discontinued: Set = ["iBook", "Powerbook", "Power Mac"]
            let discontinuedIPods: Set = ["iPod mini", "iPod Classic", "iPod nano", "iPod shuffle"]

            let allAiscontinued = discontinued.union(discontinuedIPods)
            SC.log("allAiscontinued: \(allAiscontinued)")
            // allAiscontinued: ["iPod shuffle", "Power Mac", "iPod nano", "iPod mini", "Powerbook", "iPod Classic", "iBook"]

            discontinued.formUnion(discontinuedIPods)
            SC.log("discontinued:\(discontinued)")
            // iscontinued:["iPod Classic", "Powerbook", "Power Mac", "iPod shuffle", "iPod mini", "iBook", "iPod nano"]
        }

        // 不包含公共的两个集合的所有元素
        do {
            let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
            let touchscreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
            SC.log("Set symmetricDifference: \(iPods.symmetricDifference(touchscreen))")
            // Set symmetricDifference: ["iPod Classic", "iPod mini", "iPod shuffle", "iPad", "iPhone"]
        }

        // 检查是否是子集
        do {
            let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
            let subiPods: Set = ["iPod mini", "iPod shuffle", "iPod Classic"]
            SC.log("Set isSubset:", subiPods.isSubset(of: iPods))
            // Set isSubset: true
        }

        // 保证序列中所有的元素唯一且顺序保存不变
        do {
            SC.log("unique: \([1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique())")
            // unique: [1, 2, 3, 12, 4, 5, 6]
        }
    }

    // MARK: - Range

    public func rangAction() {
        SC.printEnter(message: "Range")

        // String.Index
        do {
            let str = "a😀bcdefghigklmn"
            let zero = String.Index(utf16Offset: 0, in: str)
            let second = String.Index(utf16Offset: 2, in: str)
            let five = String.Index(utf16Offset: 5, in: str)

            SC.log("String.Index zero: \(str[zero])")
            SC.log("String.Index second: \(str[second])")
            SC.log("String.Index five: \(str[five])")
            // String.Index zero: a
            // String.Index second: 😀
            // String.Index five: d

            let start = str.startIndex
            let end = str.endIndex
            let startOffset = str.index(start, offsetBy: 2)
            let endOffset = str.index(end, offsetBy: -2)

            SC.log("startIndex: \(str[start])")
            SC.log("startOffset:\(str[startOffset])")
            SC.log("endOffset: \(str[endOffset])")
            // SC.log(str[end]) 索引越界
            // startIndex: a
            // startOffset:b
            // endOffset: m
        }

        // Range<T>
        do {
            let array = ["a", "b", "c", "d", "e", "f"]
            let range1: ClosedRange = 1 ... 4
            let range2: CountableClosedRange = 1 ... 4

            let range3: Range = 1 ..< 4
            let range4: CountableRange = 1 ..< 4

            SC.log("Range: \(array[range1])")
            SC.log("Count Range: \(array[range2])")
            SC.log("Half Range: \(array[range3])")
            SC.log("Count Half Range: \(array[range4])")
            // Range: ["b", "c", "d", "e"]
            // Count Range: ["b", "c", "d", "e"]
            // Half Range: ["b", "c", "d"]
            // Count Half Range: ["b", "c", "d"]
        }

        // lowerBound、upperBound访问Range的起始位置和结束位置
        do {
            let array = ["a", "b", "c", "d", "e", "f"]
            let range1: ClosedRange = 1 ... 4
            let range3: Range = 1 ..< 4

            SC.log("lowerBound: \(range1.lowerBound)")
            SC.log("array[lowerBound]: \(array[range1.lowerBound])")
            SC.log("upperBound: \(range1.upperBound)")
            SC.log("array[upperBound]: \(array[range1.upperBound])")
            SC.log("half upperBound: \(range3.upperBound)")
            SC.log("half array[upperBound]: \(array[range3.upperBound])")
            // lowerBound: 1
            // array[lowerBound]: b
            // upperBound: 4
            // array[upperBound]: e
            // half upperBound: 4
            // half array[upperBound]: e
        }

        // Closed Ranges: a...b
        do {
            let closeRange: ClosedRange = 1 ... 3
            let chartArray = ["a", "b", "c", "d", "e"]
            SC.log("closeRange: \(chartArray[closeRange])")
            // closeRange: ["b", "c", "d"]

            let countRange: CountableClosedRange = 1 ... 3
            SC.log("countRange: \(chartArray[countRange])")
            // countRange: ["b", "c", "d"]
            for index in countRange {
                SC.log(chartArray[index])
            }
            // b
            // c
            // d

            // 检查是否包含
            SC.log("\(closeRange.contains(9))")
            let lowerLetters = Character("a") ... Character("z")
            SC.log("\(lowerLetters.overlaps("c" ..< "f"))")
        }

        // Half-Open Range:a..<b
        do {
            let halfRange: Range = 1 ..< 3
            let chartArray = ["a", "b", "c", "d", "e"]
            SC.log("halfRange: \(chartArray[halfRange])")
            // halfRange: ["b", "c"]

            let halfCountRange: CountableRange = 1 ..< 3
            SC.log("halfCountRange: \(chartArray[halfCountRange])")
            //  halfCountRange: ["b", "c"]
            for index in halfCountRange {
                SC.log(chartArray[index])
            }
            // b
            // c
        }

        // 单侧区间
        do {
            // 部分范围有三种类型
            let range1: PartialRangeThrough = ...4
            let range2: PartialRangeFrom = 1...
            let range3: PartialRangeUpTo = ..<4

            let array = ["a", "b", "c", "d", "e", "f"]
            SC.log("PartialRangeThrough: \(array[range1])")
            SC.log("PartialRangeFrom: \(array[range2])")
            SC.log("PartialRangeUpTo: \(array[range3])")
            // PartialRangeThrough: ["a", "b", "c", "d", "e"]
            // PartialRangeFrom: ["b", "c", "d", "e", "f"]
            // PartialRangeUpTo: ["a", "b", "c", "d"]
        }

        // Ranges with String
        do {
            // Range
            let letter = "abcdefghigklmn"
            let start = letter.index(letter.startIndex, offsetBy: 1)
            let end = letter.index(letter.startIndex, offsetBy: 4)
            let range = start ..< end
            SC.log("Rande index: \(letter[range])")
            // Rande index: bcd

            // Range<Int>不能用来获取String的某一部分的值，需要用Range<String.Index>获取
            let index1 = String.Index(utf16Offset: 1, in: letter)
            let index5 = String.Index(utf16Offset: 5, in: letter)
            let index7 = String.Index(utf16Offset: 7, in: letter)

            let range1: ClosedRange = index1 ... index5
            let range2: Range = index5 ..< index7
            let range3: PartialRangeThrough = ...index5
            let range4: PartialRangeFrom = index1...
            let range5: PartialRangeUpTo = ..<index7

            // String.SubSequence 类型
            let subRange1 = letter[range1]
            SC.log("index1 ... index5: \(subRange1)")
            // String类型
            SC.log("String, index1 ... index5: \(String(subRange1))")
            SC.log("index5 ..< index7: \(letter[range2])")
            SC.log("...index5: \(letter[range3])")
            SC.log("index1...: \(letter[range4])")
            SC.log("..<index7: \(letter[range5])")
            // index1 ... index5: bcdef
            // String, index1 ... index5: bcdef
            // index5 ..< index7: fg
            // ...index5: abcdef
            // index1...: bcdefghigklmn
            // ..<index7: abcdefg

            // NSRange
            let nsRange = NSRange(location: 1, length: 3)
            let nsString: NSString = "abcde"
            SC.log("NSRande: \(nsString.substring(with: nsRange))")
            // NSRande: bcd
        }

        // Ranges with emoji String
        do {
            // Range
            let letter = "a😀cde"
            let start = letter.index(letter.startIndex, offsetBy: 1)
            let end = letter.index(letter.startIndex, offsetBy: 4)
            let range = start ..< end
            SC.log("Rande emoji index: \(letter[range])")
            // Rande emoji index: 😀cd

            // NSRange
            let nsLetter: NSString = "a😀cde"
            let nsRange = NSRange(location: 1, length: 3)
            // emoji笑脸占用了两个UTF-16单元去存储
            SC.log("NSRande emoji: \(nsLetter.substring(with: nsRange))")
            // NSRande emoji: 😀c
        }

        // String中查找或者截取字符串
        do {
            let str = "123456789"
            guard let range = str.range(of: "4567") else {
                return
            }

            SC.log("range lowerBound: \(str[..<range.lowerBound])")
            SC.log("range upperBound: \(str[range.upperBound...])")
            SC.log("prefix lowerBound: \(str.prefix(upTo: range.lowerBound))")
            SC.log("suffix upperBound: \(str.suffix(from: range.upperBound))")
            // range lowerBound: 123
            // range upperBound: 89
            // prefix lowerBound: 123
            // suffix upperBound: 89
        }

        // subscript 下标访问
        do {
            SC.log("\(String("abcde"[1 ... 3]))")
            // bcd
            SC.log("\(String("abcde"[1 ..< 3]))")
            // bc
        }
    }

    // MARK: - Tuple

    public func tupleAction() {
        SC.printEnter(message: "Tuple")
        // Create A Tuple
        var product = ("MacBook", 1099.99)
        SC.log("Tuple, product: \(product)")

        // Access Tuple
        SC.log("Tuple, access, Name: \(product.0), Price:\(product.1)")

        // Modify Tuple
        product.1 = 1299.99
        SC.log("Tuple, modify, Name: \(product.0), Price:\(product.1)")

        // Named Tuples
        let company = (product: "Programiz App", version: 2.1)
        SC.log("Tuple, name, company: \(company.product), version:\(company.version)")
    }

    // MARK: - swift-algorithms

    // 用法参考：[apple/swift-algorithms](https://github.com/apple/swift-algorithms)
    public func swiftAlgorithms() {
        SC.printEnter(message: "swift-algorithms")

        // let numbers = [1, 2, 3, 3, 2, 3, 3, 2, 2, 2, 1]
        // let unique = numbers.uniqued()
        // SC.log("Array(unique): \(Array(unique))") // [1, 2, 3]
    }

    public func changeNunber() {
        let value1 = 4.0
        let value2 = 4.2
        let value3 = 4.5
        let value4 = 4.7

        SC.log("raw   value: \(value1) \(value2) \(value3) \(value4)")
        // floor向下取整
        SC.log("floor value: \(floor(value1)) \(floor(value2)) \(floor(value3)) \(floor(value4))")
        // ceil 向上取整
        SC.log("ceil  value: \(ceil(value1)) \(ceil(value2)) \(ceil(value3)) \(ceil(value4))")
        // round 四舍五入取整
        SC.log("round value: \(round(value1)) \(round(value2)) \(round(value3)) \(round(value4))")
    }

    // MARK: - 基础数据类型

    public func baskNumber() {
        let n1 = 12.4540
        let n2 = 12.004
        let n3 = 0.30
        let n4 = 0.305

        // Double类型清理0
        SC.log("cleanZero")
        SC.log("\(n1): \(n1.cleanZero)")
        SC.log("\(n2): \(n2.cleanZero)")
        SC.log("\(n3): \(n3.cleanZero)")
        SC.log("\(n4): \(n4.cleanZero)")

        // 字符串数字保留位数
        SC.log("saveNumberDecimal")
        SC.log("\(n1): \(String(n1).saveNumberDecimal())")
        SC.log("\(n2): \(String(n2).saveNumberDecimal())")
        SC.log("\(n3): \(String(n3).saveNumberDecimal())")
        SC.log("\(n4): \(String(n4).saveNumberDecimal())")

        // 字符串数字保留位数，清理0
        SC.log("formatNumberCutZero")
        SC.log("\(n1): \(String(n1).formatNumberCutZero())")
        SC.log("\(n2): \(String(n2).formatNumberCutZero())")
        SC.log("\(n3): \(String(n3).formatNumberCutZero())")
        SC.log("\(n4): \(String(n4).formatNumberCutZero())")
    }

    // MARK: - map、filter、reduce

    // map、filter、reduce 函数的使用
    // https://github.com/pro648/tips/blob/master/sources/map%E3%80%81filter%E3%80%81reduce%E7%9A%84%E7%94%A8%E6%B3%95.md
    public func higherOrderFun() {
        // map 数组、字典相通操作
        let values = [2.0, 4.0, 5.0, 7.0]
        let squares2 = values.map { $0 * $0 }
        SC.log("squares2:\(squares2)")

        // 数据类型转换, 数字 转换为 英文
        let scores = [0, 28, 648]
        let words = scores.map { NumberFormatter.localizedString(from: $0 as NSNumber, number: .spellOut) }
        // ["zero", "twenty-eight", "six hundred forty-eight"]
        SC.log("words:\(words)")

        // 字典操作
        let milesToPoint = ["point1": 120.0, "point2": 50.0, "point3": 70.0]
        let kmToPoint = milesToPoint.map { $1 * 1.6093 }
        SC.log("kmToPoint:\(kmToPoint)")

        // filter, 返回符合指定条件的有序数组
        let digits = [1, 4, 10, 15]
        let even = digits.filter { $0 % 2 == 0 }
        // 获取偶数
        SC.log("even:\(even)")

        // reduce,将集合中的所有元素合并为一个新的值
        do {
            // 下面将数组元素值与初始值10相加：
            let items = [2.0, 4.0, 5.0, 7.0]
            let total = items.reduce(10.0) { partialResult, value in
                partialResult + value
            }
            let reduceTotal = items.reduce(10.0, +)
            SC.log("totle:\(total), reduceTotal:\(reduceTotal)")

            // 用于拼接数组中的字符串：
            let codes = ["abc", "def", "ghi"]
            let text = codes.reduce("1", +)
            SC.log("text:\(text)") // 1abcdefghi
        }

        // flatMap用于处理序列，并返回序列
        do {
            // 序列调用flatMap后，每个元素都会执行闭包逻辑，并返回 flatten 结果：
            let results = [[5, 2, 7], [4, 8], [9, 1, 3]]
            let allResults = results.flatMap { $0 }
            SC.log("allResults:\(allResults)") // [5, 2, 7, 4, 8, 9, 1, 3]

            let passMarks = results.flatMap { $0.filter { $0 > 5 } }
            SC.log("passMarks:\(passMarks)") // [7, 8, 9]
        }

        // latMap 一个常见使用情景是将不同数组里的元素进行合并
        let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
        let ranks = ["J", "Q", "K", "A"]
        let result = suits.flatMap { suit in
            ranks.map { rank in
                (suit, rank)
            }
        }
        SC.log("result:\(result)")

        // compactMap处理序列，返回可选类型, 为移除数组中的nil元素提供了一种简便操作
        do {
            let keys: [String?] = ["Tom", nil, "Peter", nil, "Harry"]
            let validNames = keys.compactMap { $0 }
            SC.log("validNames:\(validNames)") // ["Tom", "Peter", "Harry"]

            let counts = keys.compactMap { $0?.count }
            SC.log("counts:\(counts)") // [3, 5, 5]
        }
    }

    /// 可选操作符使用
    public func operationAction() {
        let bodyTemperature: Double? = 37.0
        let bloodGlucose: Double? = nil
        SC.log("bodyTemperature: \(bodyTemperature ?? 0)")
        SC.log("bloodGlucose: \(bloodGlucose ?? 0)")
        // bodyTemperature: 37.0
        // bloodGlucose: 0.0

        SC.log("bodyTemperature ???: \(bodyTemperature ??? "n/a")")
        SC.log("bloodGlucose ???: \(bloodGlucose ??? "n/a")")
        // bodyTemperature ???: 37.0
        // bloodGlucose ???: n/a

        let value: String = bodyTemperature ??? "n/a"
        SC.log("value:\(value)")
        // value:37.0
    }

    /// 强制解包示例
    public func forcedUnpacking() {
        // 数据类型转换
        let strAbc = "abc"
        let defaultValue = Int(strAbc) !? 0
        SC.log("abc to Int: \(defaultValue)")
        SC.log("8 to Int: \(Int("8") !? 0)")

        let defaultWithInfo = Int("8") !? (0, "Expected integer")
        SC.log("8 to Int with info: \(defaultWithInfo)")
        // abc to Int: 0
        // 8 to Int: 8
        // 8 to Int with info: 8

        // 字符串进行强制解包
        var strVlue: String? = "String"
        SC.log("String: \(strVlue !? "n/a")")
        strVlue = nil
        SC.log("String is nil: \(strVlue !? "n/a")")
        // String: String
        // String is nil: n/a

        // 浮点型强制解包
        let floatOptional: Float? = nil
        SC.log("floatOptional init nil: \(floatOptional !? 0)")
        // floatOptional init nil: 0.0

        let arrayOptional: [String]? = nil
        let arrayOptionalStrings: [String?]? = [nil]
        SC.log("arrayOptional init nil: \(arrayOptional !? [])")
        SC.log("arrayOptionalStrings init [nil]: \(arrayOptionalStrings?[0] !? "n/a")")
        // arrayOptional init nil: []
        // arrayOptionalStrings init [nil]: n/a
    }

    // 属性包装器使用
    public func propertyWrapperAction() {
        do {
            struct User {
                @SCAtomic @SCapitalized var firstName: String
                @SCAtomic @SCapitalized var lastName: String
            }

            let user = User(firstName: "jack", lastName: "long")
            print(user.firstName, user.lastName)
            // Jack Long

            user.firstName = "tom"
            user.lastName = "short"
            print(user.firstName, user.lastName)
            // Tom Short
        }

        do {
            enum UserDefaultsConfig {
                @SCUserDefault("hadShownGuideView", defaultValue: false)
                static var hadShownGuideView: Bool
            }

            print(UserDefaultsConfig.hadShownGuideView)
            UserDefaultsConfig.hadShownGuideView = true
            print(UserDefaultsConfig.hadShownGuideView)
            // false，第二次：true
            // true
        }
    }

    /// 打印内存指针
    public func showPointer() {
        // 普通类型数据
        var x = 42
        var y = 3.14
        var z = "foo"
        var obj = NSObject()

        SC.log("Base type pointer")
        SC.printPointer(ptr: &x)
        SC.printPointer(ptr: &y)
        SC.printPointer(ptr: &z)

        SC.printPointer(ptr: &obj)
        withUnsafePointer(to: &obj) { ptr in SC.log(ptr) }
        // Base type pointer
        // 0x000000016d4e6b80
        // 0x000000016d4e6b78
        // 0x000000016d4e6b68
        // 0x000000016d4e6b60 printPointer 与 withUnsafePointer 获取地址相同
        // 0x000000016d4e6b60

        // 数组类型
        var ary1 = ["aaa", "bbb", "ccc"]
        // 指向同一个地址
        var ary2 = ary1

        SC.log("ary2 = ary1")
        // 指针地址
        SC.log(SC.getPointer(of: &ary1))
        SC.log(SC.getPointer(of: &ary2))

        // 指向对象地址
        SC.printPointer(ptr: &ary1)
        SC.printPointer(ptr: &ary2)
        // ary2 = ary1
        // 0x000000016d4e6b58 ary1 与 ary2 指针地址没有改变
        // 0x000000016d4e6b50
        // 0x0000000283a89740 ary1 与 ary2 指向相通对象
        // 0x0000000283a89740

        // 指向不同地址
        ary1.append("ddd")
        ary2.removeFirst()

        SC.log("change array")
        // 指针地址
        SC.log(SC.getPointer(of: &ary1))
        SC.log(SC.getPointer(of: &ary2))

        // 指向对象地址
        SC.printPointer(ptr: &ary1)
        SC.printPointer(ptr: &ary2)
        // change array
        // 0x000000016d4e6b58
        // 0x000000016d4e6b50
        // 0x00000002837bc820 ary1 与 ary2 指向不同对象
        // 0x0000000283a89740

        // 打印对象地址：getPointer(of: &ary1) 等价与 withUnsafePointer(to: &ary1) { ptr in print(ptr) }
        // 调试模式，打印地址值：x 0x00000002826e5c40
    }

    // MARK: - UI

    func setupUI() {
        title = "Function"
        SC.toast("console logs")
        SC.log("Log example", "message one", "message two", separator: "\n")

        stringFunction()
        arrayAction()
        dictionaryAction()
        setAction()
        rangAction()
        tupleAction()
        swiftAlgorithms()
        changeNunber()

        let monthDic = SCUtils.generatorMonths(baseYear: 2021, baseMonth: 9)
        SC.log("the monthDic:\(monthDic)")

        let maxDay = SCUtils.lastDay(yearAndMonth: "2021-02", separateFlag: "-", isCurentDay: true)
        SC.log("2021-02 max day:\(maxDay)")

        saveDataAction()

        // APP 系统信息
        SC.log("deviceInfo:  \(SC.deviceInfo())")

        // 文件名称、扩展名
        let filePath = "/user/abc/hello.abc.swift"
        SC.log("fileName: \(filePath.fileName ?? "")")
        SC.log("fileExtension: \(filePath.fileExtension ?? "")")

        // 获取指定下标的值的集合
        SC.log("Collection subscript: \(Array("abcdefghijklmnopqrstuvwxyz")[indices: 0, 7, 4, 11, 11, 14])")
        // Collection subscript: ["a", "h", "e", "l", "l", "o"]

        baskNumber()
        higherOrderFun()
        operationAction()
        forcedUnpacking()
        propertyWrapperAction()
        showPointer()
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property
}
