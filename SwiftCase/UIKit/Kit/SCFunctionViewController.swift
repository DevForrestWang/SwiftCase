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
            fwDebugPrint("I've been injected: \(self)")
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
        fwPrintEnter(message: "String")

        // 多行字符串字面量
        let quotation = """
        The White Rabbit put on his spectacles.  "Where shall I begin,
        please your Majesty?" he asked.

        "Begin at the beginning," the King said gravely, "and go on
        till you come to the end; then stop."
        """
        fwDebugPrint(quotation)

        fwDebugPrint("0.01: \("0.01".isPureFloat())")
        fwDebugPrint("1.00: \("1.00".isPureFloat())")
        fwDebugPrint("2a: \("2a".isPureFloat())")

        fwDebugPrint("2: \("2".isPureInt())")
        fwDebugPrint("2.1: \("2.1".isPureInt())")
    }

    /// 字符串拼接
    private func appentString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = str1 + " " + str2
        fwDebugPrint(str3)

        var str4 = "Hello"
        str4.append(" Word")
        fwDebugPrint(str4)
    }

    ///  字符串格式化
    private func formatString() {
        let str1 = String(2)
        let str2 = String(5.0)
        let str3 = str1 + str2
        fwDebugPrint(str3)

        let str4 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        fwDebugPrint(str4)

        // [String Format Specifiers](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
        let s1 = "lazy"
        fwDebugPrint(String(format: "%@ boy %.2f", s1, 12.344))

        // 不足两位前面补0
        fwDebugPrint(String(format: "%02d", 1))
        fwDebugPrint(String(format: "%02d", 11))
    }

    /// 获取字符串长度
    private func lengthString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        fwDebugPrint(str1.count)
    }

    private func emptyString() {
        let str1 = "Swift"
        let str2 = ""

        fwDebugPrint(str1.isEmpty)
        fwDebugPrint(str2.isEmpty)
    }

    /// 遍历字符串
    private func iterationString() {
        let str1 = String(format: "The course %d, price: %.2f", 1, 5.6876)
        for char in str1 {
            fwDebugPrint(char)
        }
    }

    /// 字符串操作
    private func operationString() {
        //  获取首字符
        let str1 = "Swift"
        fwDebugPrint(str1[str1.startIndex])

        // 删除首字符
        var str2 = "ABC"
        str2.removeFirst() // str2.remove(at: str2.startIndex)
        fwDebugPrint(str2)

        // 删除指定位置
        var str3 = "ABCDEFGH"
        str3.remove(at: str3.index(str3.startIndex, offsetBy: 2)) // delete: C
        fwDebugPrint(str3)

        // 删除最后一个字符
        var str4 = "ABC"
        str4.removeLast()
        // str4.remove(at: str4.index(str4.endIndex, offsetBy: -1))
        fwDebugPrint(str4)

        // 删除所有内容
        var str5 = "ABCDEFGH"
        str5.removeAll()

        // 删除头尾指定位数内容
        var str6 = "ABCDEFGH"
        str6.removeFirst(2)
        str6.removeLast(2)
        fwDebugPrint(str6) // CDEF

        // 首字母大写，
        fwDebugPrint("wo xiao wo ku".capitalized) // Wo Xiao Wo Ku
        fwDebugPrint("已选择: \("已选择".transformToPinYin())")

        // 查找字符串位置
        let letters = "abcdefg"

        let char: Character = "c"
        if let distance = letters.distance(of: char) {
            fwDebugPrint("character \(char) was found at position #\(distance)") // "character c was found at position #2\n"
        } else {
            fwDebugPrint("character \(char) was not found")
        }

        let string = "cde"
        if let distance = letters.distance(of: string) {
            fwDebugPrint("string \(string) was found at position #\(distance)") // "string cde was found at position #2\n"
        } else {
            fwDebugPrint("string \(string) was not found")
        }

        // md5 使用
        let password = "your password"
        fwDebugPrint("The \(password) md5: \(password.md5())")

        fwDebugPrint("localized: \("string_id".localized)")
    }

    /// 判断字符串相等
    private func equalString() {
        let str1 = "Hello"
        let str2 = "Hello"
        let str3 = "Hello World"

        // 需要知道大小, 枚举 ComparisonResult -1 0 1
        let isSame = str1.compare(str3)
        fwDebugPrint(isSame.rawValue) // -1
        fwDebugPrint(str1.compare(str2).rawValue) // 0

        // 只需要知道内容是否相等
        fwDebugPrint(str1 == str2)
    }

    /// 判断字符串包含另一个字符串
    private func containString() {
        let str1 = "Hello"
        let str2 = "Hello World"
        let result = str2.contains(str1)
        fwDebugPrint(result)
    }

    /// 字符串分割
    private func splitString() {
        let str1 = "Hello World"
        let strAry = str1.split(separator: " ")
        fwDebugPrint(strAry)
    }

    /// 数组拼接字符串
    private func joinString() {
        let tArry = ["Hello", "World"]
        let str1 = tArry.joined()
        fwDebugPrint(str1)

        let str2 = tArry.joined(separator: " : ")
        fwDebugPrint(str2)
    }

    /// 字符串截取
    private func subString() {
        // 头部截取
        let str1 = "asdfghjkl;"
        let str2 = str1.prefix(2)
        fwDebugPrint(str2) // as

        // 尾部截取
        let str3 = str1.suffix(3)
        fwDebugPrint(str3) // kl;

        // range 截取
        let indexStart4 = str1.index(str1.startIndex, offsetBy: 3)
        let indexEnd4 = str1.index(str1.startIndex, offsetBy: 5)
        let str4 = str1[indexStart4 ... indexEnd4]
        fwDebugPrint(str4) // fgh

        // 获取指定位置字符串
        let range = str1.range(of: "jk")
        fwDebugPrint(str1[str1.startIndex ..< range!.lowerBound]) // asdfgh
        fwDebugPrint(str1[str1.startIndex ..< range!.upperBound]) // asdfghjk

        let greeting = "Hello, world!"
        let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
        let beginning = greeting[..<index]
        // beginning is "Hello"
        fwDebugPrint("beginning: \(String(beginning))")

        //
        fwDebugPrint("\(greeting), first 4:\(String(greeting[...4]))")
        fwDebugPrint("\(greeting), 3-4:\(String(greeting[3 ... 4]))")
        fwDebugPrint("\(greeting), from 7:\(String(greeting[7...]))")
        fwDebugPrint("\(greeting), substring 1:\(String(greeting[1]))")

        // 字符串截取
        let str = "123456789"
        let start = str.startIndex // 表示str的开始位置
        let startOffset = str.index(start, offsetBy: 2) // 表示str的开始位置 + 2
        let endOffset = str.index(str.endIndex, offsetBy: -2) // 表示str的结束位置 - 2
        fwDebugPrint(str[start]) // 输出 1 第1个字符
        fwDebugPrint(str[startOffset]) // 输出 3 第3个字符
        fwDebugPrint(str[endOffset]) // 输出 8 第8个字符（10-2）

        let mainStr = "Strengthen"
        let findIndex = (mainStr.distance(of: "eng") ?? 0) + "eng".count
        fwDebugPrint("\(mainStr.subStringFrom(findIndex))")

        // 字符串截取
        let stText = "www.stackoverflow.com/questions/28182441/swift-how-to-get-substring-from-start-to-last-index-of-character"
        fwDebugPrint("subStirng:\(stText)")
        fwDebugPrint(stText.character(3)) // .
        fwDebugPrint(stText.substring(0 ..< 3)) // www
        fwDebugPrint(stText.substring(from: 4)) // stackoverflow.com...
        fwDebugPrint(stText.substring(to: 16)) // www.stackoverflow
        fwDebugPrint(stText.between(".", ".") ?? "") // stackoverflow
        fwDebugPrint(stText.lastIndexOfCharacter(".") ?? "") // 17
    }

    /// 字符串替换
    private func replateString() {
        let str1 = "all the world"
        let str2 = str1.replacingOccurrences(of: "all", with: "haha")
        fwDebugPrint(str2)
    }

    /// 字符串插入
    private func insertString() {
        var str1 = "ABCDEFGH"
        // 单个字符
        str1.insert("X", at: str1.index(str1.startIndex, offsetBy: 6))
        fwDebugPrint(str1)

        // 多个字符
        str1.insert(contentsOf: "888", at: str1.index(before: str1.endIndex))
        fwDebugPrint(str1)

        let multiplier = 3
        let str2 = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        fwDebugPrint(str2)
    }

    /// 字符串删除某段内容
    private func deleteInfoByString() {
        var str1 = "ABCDEFGH"
        let startIndex = str1.index(str1.startIndex, offsetBy: 2)
        let endIndex = str1.index(str1.endIndex, offsetBy: -2)
        str1.removeSubrange(startIndex ... endIndex)
        fwDebugPrint(str1) // ABH
    }

    private func convertData() {
        // Convert Int To String
        let tInt = 10
        let sValue = String(tInt)

        // Convert String to Int
        let sData = "10"
        let iData = Int(sData)

        fwDebugPrint("sValue:\(sValue), iData:\(iData ?? 0)")
    }

    private func checkString() {
        let a1 = "12345".containsOnlyDigits // true
        let a2 = "a12345".containsOnlyDigits // false
        fwDebugPrint("containsOnlyDigits: \(a1)-\(a2)")

        let b1 = "abcde".containsOnlyLetters // true
        let b2 = "abcde1".containsOnlyLetters // false
        fwDebugPrint("containsOnlyLetters: \(b1)-\(b2)")

        let c1 = "abcde12345".isAlphanumeric // true
        let c2 = "abcde.12345".isAlphanumeric // false
        fwDebugPrint("isAlphanumeric: \(c1)-\(c2)")

        // 为空检查
        let spaceStr = "     "
        let newLine = "\n"
        fwDebugPrint("space: \(spaceStr.isBlank)-newLine:\(newLine.isBlank)")

        // 邮箱检查
        let strEmail = "test@test.com"
        fwDebugPrint("\(strEmail) is email: \(strEmail.isValidEmail)")
    }

    private func parseJson() {
        let dict: [String: Any] = [
            "name": "John",
            "surname": "Doe",
            "age": 31,
        ]
        fwDebugPrint(dict) // ["surname": "Doe", "name": "John", "age": 31]

        let json = String(json: dict)
        fwDebugPrint(json ?? "") // Optional("{\"surname\":\"Doe\",\"name\":\"John\",\"age\":31}")

        let restoredDict = json?.jsonToDictionary()
        fwDebugPrint(restoredDict ?? []) // Optional(["name": John, "surname": Doe, "age": 31])
    }

    private func stringSeparator() {
        var cardNumber = "1234567890123456"
        cardNumber.insert(separator: " ", every: 4)
        fwDebugPrint(cardNumber) // 1234 5678 9012 3456

        let pin = "7690"
        let pinWithDashes = pin.inserting(separator: "-", every: 1)
        fwDebugPrint(pinWithDashes) // 7-6-9-0
    }

    // MARK: - Array

    public func arrayAction() {
        fwPrintEnter(message: "Array")

        // Create an Empty Array
        let someInts = [Int]()
        let threeDouble = Array(repeating: 0.0, count: 3)

        // 数组的初始
        var numbers = [21, 34, 54, 12]
        var evenNumbers = [4, 6, 8]
        fwDebugPrint("Array, someInts:\(someInts), threeDouble:\(threeDouble)")

        let initArray = Array(0 ... 20)
        fwDebugPrint("initArray: \(initArray)")

        // Add Elements to an Array
        numbers.append(32)
        numbers.append(contentsOf: evenNumbers)
        numbers += [1, 2, 3]
        numbers.insert(32, at: 1)
        fwDebugPrint("Array, Add numbers:\(numbers)")
        fwDebugPrint("find 5, result: \(numbers.contains(5))")

        // Modify the Elements of an Array
        numbers[1] = 16

        fwDebugPrint("Array, Modify numbers:\(numbers)")

        // Remove an Element
        numbers.removeLast()
        evenNumbers.removeAll()
        numbers.remove(at: 1)
        fwDebugPrint("Array, Remove numbers:\(numbers), evenNumbers:\(evenNumbers)")

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
            fwDebugPrint(i)
        }

        // 0到10
        for i in 0 ... 10 {
            fwDebugPrint(i)
        }

        // 反向遍历
        for i in (0 ..< 10).reversed() {
            fwDebugPrint(i)
        }

        for num in numbers {
            fwDebugPrint(num)
        }

        // 同时遍历索引和元素
        for (index, num) in numbers.enumerated() {
            fwDebugPrint("\(index): \(num)")
        }

        numbers.forEach { num in
            fwDebugPrint(num)
        }

        // 倒叙循环
        for year in stride(from: 2022, through: 2019, by: -1) {
            fwDebugPrint("year: \(year)")
        }

        // Find Number of Array Elements
        fwDebugPrint("Array, Number: \(numbers.count)")

        // Check if an Array is Empty
        fwDebugPrint("Array, Empty: \(evenNumbers.isEmpty)")

        // Array With Mixed Data Types
        let address: [Any] = ["Scranton", 570]
        fwDebugPrint("Array, address: \(address)")

        // 数组的索引
        fwDebugPrint("startIndex and EndIndex: \(numbers[numbers.startIndex ..< numbers.endIndex])")

        // filter
        let numAry = numbers.filter { $0 > 10 }
        fwDebugPrint("filter more 10: \(numAry)")

        let arry = ["123Z", "456Z", "789"]
        let num2Ary = arry.filter { str -> Bool in
            str.contains("Z")
        }
        fwDebugPrint("filter contain Z: \(num2Ary)")

        // map 将原来数组元素映射到新数组中；映射数组、转换元素
        let mapAry1 = numbers.map { num -> String in
            "\(num)Z"
        }
        fwDebugPrint("Map add Z: \(mapAry1)")

        let mapAry2 = (1 ... 5).map { $0 * 3 }
        fwDebugPrint("map multiplicat 3: \(mapAry2)")

        // compactMap 空值过滤，去掉数组中nil元素
        let latMapAry = ["1", "2", "3", nil].compactMap { $0 }
        fwDebugPrint("Filter nil: \(latMapAry)")

        // compactMap 强制解包
        let baseFlat: [String?] = ["123", "456", "789"]
        fwDebugPrint("map: \(baseFlat.map { $0 })")
        fwDebugPrint("flatMap: \(baseFlat.compactMap { $0 })")

        // 嵌套数组的压平
        let baseFlat2 = [[1], [2], [3, 4], [5, 6]]
        fwDebugPrint("\(baseFlat2.compactMap { $0 })")

        // reduce 把数组变成一个元素， 初始化值、闭包规则
        fwDebugPrint("1...5 = \((1 ... 5).reduce(0, +))")

        let reduceAry2 = numbers.reduce("strengthen") { a1, a2 -> String in
            "\(a1)" + "\(a2)"
        }
        fwDebugPrint("number + strengthen:  \(reduceAry2)")

        fwDebugPrint("numbers first 3:  \(numbers.prefix(upTo: 3))")
        fwDebugPrint("numbers from 3:  \(numbers.suffix(from: 3))")

        // 从头部开始的3个元素
        fwDebugPrint("delete first 3 nums:  \(numbers.dropFirst(3))")

        fwDebugPrint("delete last 3 nums:  \(numbers.dropLast(3))")
    }

    // MARK: - Dictionaries

    public func dictionaryAction() {
        fwPrintEnter(message: "Dictionary")

        // Create a dictionary
        var capitalCity = ["Nepal": "Kathmandu", "Italy": "Rome", "England": "London"]
        var studentID = [111: "Eric", 112: "Kyle", 113: "Butters"]
        let emptyDictionary = [Int: String]()
        fwDebugPrint("Dictionary, capitalCity: \(capitalCity)")
        fwDebugPrint("Dictionary, studentID: \(studentID)")
        fwDebugPrint("Dictionary, emptyDictionary: \(emptyDictionary)")

        // 是否包含key
        let hasKey = capitalCity.keys.contains("Italy")
        fwDebugPrint("Dictionary, capitalCity contains, Italy: \(hasKey)")

        let hasKey2 = capitalCity.contains(key: "Italy")
        fwDebugPrint("Dictionary, capitalCity contains, Italy: \(hasKey2)")

        // 字典取值
        fwDebugPrint("Dictionary read, Key:Italy, value: \(capitalCity["Italy"] ?? "")")

        // Add Elements
        capitalCity["Japan"] = "Tokyo"
        fwDebugPrint("Dictionary, Add \(capitalCity)")

        // Change Value of Dictionary
        studentID[112] = "Stan"
        fwDebugPrint("Dictionary, Change \(studentID)")

        // Access Elements
        fwDebugPrint("Dictionary, Access keys: \(Array(capitalCity.keys))")
        fwDebugPrint("Dictionary, Access values: \(Array(capitalCity.values))")

        // Remove an Element
        let removedValue = studentID.removeValue(forKey: 112)
        fwDebugPrint("Dictionary, Remove \(String(describing: removedValue))")

        /// Other Dictionary Methods
        // sorted()         sorts dictionary elements
        // shuffled()       changes the order of dictionary elements
        // contains()       checks if the specified element is present
        // randomElement()  returns a random element from the dictionary
        // firstIndex()     returns the index of the specified element

        // Iterate Over a Dictionary
        let ariPorts: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

        for (key, value) in ariPorts {
            fwDebugPrint("\(key): \(value)")
        }

        // Find Number of Dictionary Elements
        fwDebugPrint("Dictionary, Number \(studentID.count)")

        let dicString = "{\"cmd\":\"CustomCmdMsg\",\"data\":{\"cmdType\":\"4\",\"msg\":{\"fileReturnId\":\"F00AgKdVBvCR1TZyBTJrD1T\",\"imgUrl\":\"https://dc.aadv.net:10443/fsServerUrl/fs/download/F00AgKdVBvCR1TZyBTJrD1T\"},\"userId\":\"0121400015000020000\",\"userInfo\":{\"groupId\":\"11202112091420160000060113\",\"userName\":\"测试二号\",\"userAvatar\":\"F00AgKdVBvCR1ThXBTVfC1T\",\"entCustId\":\"0121400015020211117\",\"custId\":\"0121400015000020000\",\"resNo\":\"01214000150\",\"operNo\":\"0002\",\"levelName\":\"店员\",\"levelImg\":\"user_icon.png\"},\"sendTime\":\"2022-05-27 17:43:57\"}}"

        let dicObj = dicString.toDictionary()
        fwDebugPrint("string to dictionary: \(dicObj.toJsonString() ?? "")")
    }

    public func saveDataAction() {
        let age = 25
        age.store(key: "age")
        fwDebugPrint(Int(key: "age") ?? 0) // Optional(25)
        fwDebugPrint(Float(key: "age") ?? 0) // Optional(25.0)
        fwDebugPrint(String(key: "age") ?? 0) // Optional("25")
        fwDebugPrint(String(key: "age1") ?? "") // nil

        let dict: [String: Any] = [
            "name": "John",
            "surname": "Doe",
            "occupation": "Swift developer",
            "experienceYears": 5,
            "age": 32,
        ]
        dict.store(key: "employee")
        fwDebugPrint(Dictionary(key: "employee") ?? [])
    }

    // MARK: - sets

    public func setAction() {
        fwPrintEnter(message: "Set")

        // Create a Set
        var studentID: Set<Int> = [112, 114, 116, 118, 115]
        let emptySet = Set<Int>()
        fwDebugPrint("Set, emptySet: \(emptySet)")

        // Add Elements
        studentID.insert(113)
        fwDebugPrint("Set, insert: \(studentID)")

        // Remove an Element
        let removedValue = studentID.remove(115)
        var languages: Set = ["Swift", "Java", "Python"]
        languages.removeAll()
        fwDebugPrint("Set, remove: \(String(describing: removedValue)), languages:\(languages)")

        // Other Set Methods
        // sorted()          sorts set elements
        // forEach()         performs the specified actions on each element
        // contains()        searches the specified element in a set
        // randomElement()   returns a random element from the set
        // firstIndex()      returns the index of the given element

        // Iterate Over a Set
        let fruits: Set = ["Apple", "Peach", "Mango"]
        for fruit in fruits {
            fwDebugPrint("Set, fruit: \(fruit)")
        }

        // Find Number of Set Elements
        fwDebugPrint("Set, count: \(fruits.count)")

        // Union of Two Sets
        let setA: Set = [1, 3, 5]
        let setB: Set = [0, 1, 2, 3, 4]
        fwDebugPrint("Set, setA: \(setA)")
        fwDebugPrint("Set, setB: \(setB)")
        fwDebugPrint("Set, A union B: \(Array(setA.union(setB)).sorted())")

        // Intersection between Two Sets
        fwDebugPrint("Set, A intersection B: \(setA.intersection(setB))")

        // The difference between two sets A and B include elements of set A that are not present on set B.
        fwDebugPrint("Set, B subtracting A: \(setB.subtracting(setA))")

        // The symmetric difference between two sets A and B includes all elements of A and B without the common elements.
        fwDebugPrint("Set, A symmetric difference B: \(setA.symmetricDifference(setB))")

        // Check Subset of a Set
        let setC: Set = [1, 2, 3, 5, 4]
        let setD: Set = [1, 2]
        fwDebugPrint("Set, D subset C: ", setD.isSubset(of: setC))

        let setE: Set = [2, 1]
        if setD == setE {
            fwDebugPrint("Set D and Set E are equal")
        } else {
            fwDebugPrint("Set D and Set E are different")
        }
    }

    // MARK: - Tuple

    public func tupleAction() {
        fwPrintEnter(message: "Tuple")
        // Create A Tuple
        var product = ("MacBook", 1099.99)
        fwDebugPrint("Tuple, product: \(product)")

        // Access Tuple
        fwDebugPrint("Tuple, access, Name: \(product.0), Price:\(product.1)")

        // Modify Tuple
        product.1 = 1299.99
        fwDebugPrint("Tuple, modify, Name: \(product.0), Price:\(product.1)")

        // Named Tuples
        let company = (product: "Programiz App", version: 2.1)
        fwDebugPrint("Tuple, name, company: \(company.product), version:\(company.version)")
    }

    // MARK: - swift-algorithms

    // 用法参考：[apple/swift-algorithms](https://github.com/apple/swift-algorithms)
    public func swiftAlgorithms() {
        fwPrintEnter(message: "swift-algorithms")

        // let numbers = [1, 2, 3, 3, 2, 3, 3, 2, 2, 2, 1]
        // let unique = numbers.uniqued()
        // yxc_debugPrint("Array(unique): \(Array(unique))") // [1, 2, 3]
    }

    public func changeNunber() {
        let value1 = 4.0
        let value2 = 4.2
        let value3 = 4.5
        let value4 = 4.7

        fwDebugPrint("raw   value: \(value1) \(value2) \(value3) \(value4)")
        // floor向下取整
        fwDebugPrint("floor value: \(floor(value1)) \(floor(value2)) \(floor(value3)) \(floor(value4))")
        // ceil 向上取整
        fwDebugPrint("ceil  value: \(ceil(value1)) \(ceil(value2)) \(ceil(value3)) \(ceil(value4))")
        // round 四舍五入取整
        fwDebugPrint("round value: \(round(value1)) \(round(value2)) \(round(value3)) \(round(value4))")
    }

    // MARK: - 基础数据类型

    public func baskNumber() {
        let n1 = 12.4540
        let n2 = 12.004
        let n3 = 0.30
        let n4 = 0.305

        // Double类型清理0
        fwDebugPrint("cleanZero")
        fwDebugPrint("\(n1): \(n1.cleanZero)")
        fwDebugPrint("\(n2): \(n2.cleanZero)")
        fwDebugPrint("\(n3): \(n3.cleanZero)")
        fwDebugPrint("\(n4): \(n4.cleanZero)")

        // 字符串数字保留位数
        fwDebugPrint("saveNumberDecimal")
        fwDebugPrint("\(n1): \(String(n1).saveNumberDecimal())")
        fwDebugPrint("\(n2): \(String(n2).saveNumberDecimal())")
        fwDebugPrint("\(n3): \(String(n3).saveNumberDecimal())")
        fwDebugPrint("\(n4): \(String(n4).saveNumberDecimal())")

        // 字符串数字保留位数，清理0
        fwDebugPrint("formatNumberCutZero")
        fwDebugPrint("\(n1): \(String(n1).formatNumberCutZero())")
        fwDebugPrint("\(n2): \(String(n2).formatNumberCutZero())")
        fwDebugPrint("\(n3): \(String(n3).formatNumberCutZero())")
        fwDebugPrint("\(n4): \(String(n4).formatNumberCutZero())")
    }

    // MARK: - UI

    func setupUI() {
        title = "Function"
        fwShowToast("console logs")

        stringFunction()
        arrayAction()
        dictionaryAction()
        setAction()
        tupleAction()
        swiftAlgorithms()
        changeNunber()

        let monthDic = SCUtils.generatorMonths(baseYear: 2021, baseMonth: 9)
        fwDebugPrint("the monthDic:\(monthDic)")

        let maxDay = SCUtils.lastDay(yearAndMonth: "2021-02", separateFlag: "-", isCurentDay: true)
        fwDebugPrint("2021-02 max day:\(maxDay)")

        saveDataAction()

        // APP 系统信息
        fwDebugPrint("deviceInfo:  \(SCDeviceInfo.deviceInfo())")

        baskNumber()
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property
}
