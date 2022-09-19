//
//===--- AlgorithmViewController.swift - Defines the AlgorithmViewController class ----------===//
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

import RxSwift
import UIKit

class AlgorithmViewController: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Algorithm"
    }

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "Swift-algorithms", controllerName: "", action: #selector(swiftAlgorithms)),
            SCItemModel(title: "Collections: Array、Dictionary、Sets", controllerName: "", action: #selector(collectionsAction)),
            SCItemModel(title: "Array2D: two-dimensional array", controllerName: "", action: #selector(array2DAction)),
            SCItemModel(title: "Linked List", controllerName: "", action: #selector(linkedListAction)),
            SCItemModel(title: "Stack", controllerName: "", action: #selector(stackAction)),
            SCItemModel(title: "Queue", controllerName: "", action: #selector(queueAction)),
            SCItemModel(title: "Recursion", controllerName: "", action: #selector(recursionAction)),
            SCItemModel(title: "Bubble Sort", controllerName: "", action: #selector(bubbleSortAction)),
            SCItemModel(title: "Insertion Sort", controllerName: "", action: #selector(insertionSortAction)),
            SCItemModel(title: "Selection Sort", controllerName: "", action: #selector(selectionSortAction)),
            SCItemModel(title: "*Quick Sort", controllerName: "", action: #selector(quickSortAction)),
            SCItemModel(title: "Merge Sort", controllerName: "", action: #selector(mergeSortAction)),
            SCItemModel(title: "Bucket Sort", controllerName: "", action: #selector(bucketSortAction)),
            SCItemModel(title: "Counting Sort", controllerName: "", action: #selector(countingSortAction)),
            SCItemModel(title: "Radix Sort", controllerName: "", action: #selector(radixSortAction)),
            SCItemModel(title: "Binary Search", controllerName: "", action: #selector(binarySearchAction)),
            SCItemModel(title: "Skip List", controllerName: "", action: #selector(skipListAction)),
            SCItemModel(title: "Hash Table", controllerName: "", action: #selector(hashTableAction)),
            SCItemModel(title: "LRU(Least Recently Used) Cache", controllerName: "", action: #selector(lRUCacheAction)),
            SCItemModel(title: "Binary Tree", controllerName: "", action: #selector(binaryTreeAction)),
            SCItemModel(title: "Binary Search Tree (BST)", controllerName: "", action: #selector(binarySearchTreeAction)),
            SCItemModel(title: "AVL tree (named after inventors Adelson-Velsky and Landis)", controllerName: "", action: #selector(avlTreeAction)),
            SCItemModel(title: "Red-Black Tree", controllerName: "", action: #selector(redBlackTreeAction)),
            SCItemModel(title: "Heap", controllerName: "", action: #selector(heapAction)),
            SCItemModel(title: "Heap Sort", controllerName: "", action: #selector(heapSortAction)),
            SCItemModel(title: "Graph", controllerName: "", action: #selector(graphAction)),
            SCItemModel(title: "Depth-First Search", controllerName: "", action: #selector(depthFirstSearchAction)),
            SCItemModel(title: "Breadth-First Search", controllerName: "", action: #selector(breadthFirstSearchAction)),
            SCItemModel(title: "Brute Force string search", controllerName: "", action: #selector(bruteForceAction)),
            SCItemModel(title: "Rabin-Karp string search", controllerName: "", action: #selector(rabinKarpAction)),
            SCItemModel(title: "Boyer-Moore string search", controllerName: "", action: #selector(boyerMooreAction)),
            SCItemModel(title: "Knuth-Morris-Pratt string search", controllerName: "", action: #selector(knuthMorrisPrattAction)),
            SCItemModel(title: "Trie", controllerName: "", action: #selector(trieAction)),
            SCItemModel(title: "Aho-Corasick", controllerName: "", action: #selector(ahoCorasickAction)),
            SCItemModel(title: "Huffman Coding", controllerName: "", action: #selector(huffmanCodingAction)),
            SCItemModel(title: "Dijkstra's shortest path", controllerName: "", action: #selector(dijkstraShortestPathAction)),
            SCItemModel(title: "Bit Set", controllerName: "", action: #selector(bitSetAction)),
            SCItemModel(title: "Bloom Filter", controllerName: "", action: #selector(bloomFilterAction)),
            SCItemModel(title: "B-Tree", controllerName: "", action: #selector(bTreeAction)),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // apple/swift-algorithms
    @objc private func swiftAlgorithms() {
        let fc = SCFunctionViewController()
        fc.swiftAlgorithms()
        showLogs()
    }

    @objc private func collectionsAction() {
        let fc = SCFunctionViewController()
        fc.arrayAction()
        fc.dictionaryAction()
        fc.setAction()
        showLogs()
    }

    @objc private func array2DAction() {
        fwPrintEnter(message: "Array2D")
        var matrix = Array2D<Int>(columns: 3, rows: 5, initialValue: 0)
        fwDebugPrint(matrix)

        // setting numbers using subscript [x, y]
        matrix[0, 0] = 1
        matrix[1, 0] = 2

        matrix[0, 1] = 3
        matrix[1, 1] = 4

        matrix[0, 2] = 5
        matrix[1, 2] = 6

        matrix[0, 3] = 7
        matrix[1, 3] = 8
        matrix[2, 3] = 9
        fwDebugPrint(matrix)

        // print out the 2D array with a reference around the grid
        for i in 0 ..< matrix.rows {
            print("[", terminator: "")
            for j in 0 ..< matrix.columns {
                if j == matrix.columns - 1 {
                    print("\(matrix[j, i])", terminator: "")
                } else {
                    print("\(matrix[j, i]) ", terminator: "")
                }
            }
            print("]")
        }

        showLogs()
    }

    @objc private func linkedListAction() {
        fwPrintEnter(message: "Linked List")
        let list = LinkedList<String>()
        list.append("Hello")
        list.append("World")
        fwDebugPrint("list: \(list)")

        if list.count >= 1 {
            fwDebugPrint("list[0]: \(list[0])")
            fwDebugPrint("list[1]: \(list[1])")
            // list[2]   // crash!
        }

        let list2 = LinkedList<String>()
        list2.append("Goodbye")
        list2.append("World")
        list.append(list2)

        list2.removeAll()
        list.removeLast()
        list.remove(at: 2)
        fwDebugPrint("list remove:\(list), list2:\(list2)")

        list.insert("Swift", at: 1)
        fwDebugPrint("list insert:\(list)")

        list.reverse()
        fwDebugPrint("list reverse:\(list)")

        let m = list.map { s in s.count }
        fwDebugPrint("list map count, m:\(m)")

        let f = list.filter { s in s.count > 5 }
        fwDebugPrint("list filter count>5, f:\(f)")

        // Conformance to the Collection protocol
        let collection: LinkedList<Int> = [1, 2, 3, 4, 5]
        let index2 = collection.index(collection.startIndex, offsetBy: 2)
        let value = collection[index2]
        fwDebugPrint("list collection 2, value:\(value)")

        let result = collection.reduce(0) { $0 + $1 }
        fwDebugPrint("list collection reduce, result:\(result)")

        showLogs()
    }

    @objc private func stackAction() {
        fwPrintEnter(message: "Stack")

        var stackeOfName = Stack<String>()
        let nameAry = ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"]
        for name in nameAry {
            stackeOfName.push(name)
        }

        stackeOfName.push("Mike")
        fwDebugPrint("stack push Mike : \(stackeOfName)")
        let firstName: String = stackeOfName.pop() ?? "No Data"
        fwDebugPrint("stack pop : \(stackeOfName), isEmpty: \(stackeOfName.isEmpty), firstName:\(String(describing: firstName))")

        showLogs()
    }

    @objc private func queueAction() {
        fwPrintEnter(message: "Stack")

        let array = ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"]
        var queue = Queue<String>()
        for item in array {
            queue.enqueue(item)
        }

        queue.enqueue("Mike")
        fwDebugPrint("Queue, queue: \(queue)")

        let v1 = queue.dequeue()
        fwDebugPrint("Queue, queue: \(queue), v1:\(String(describing: v1)), isEmpty: \(queue.isEmpty)")

        showLogs()
    }

    @objc private func recursionAction() {
        fwPrintEnter(message: "Recursion")
        let sr = SCRecursion<Int>()
        fwDebugPrint("1 to 10: add:\(sr.add(10))")
        fwDebugPrint("1 to 100: addGuard:\(sr.addGuard(100))")

        showLogs()
    }

    @objc private func bubbleSortAction() {
        fwPrintEnter(message: "Bubble Sort")

        let array = [5, 4, 6, 3, 2, 1]
        fwDebugPrint("Sort before: \(array)")
        fwDebugPrint("Sort after: \(bubbleSort(array))")
        fwDebugPrint("Sort after < : \(bubbleSort(array, <))")
        fwDebugPrint("Sort after > : \(bubbleSort(array, >))")

        showLogs()
    }

    @objc private func insertionSortAction() {
        fwPrintEnter(message: "Insertion Sort")
        let array = [4, 5, 6, 1, 3, 2]
        fwDebugPrint("Sort, insertionSort: \(insertionSort(array))")
        fwDebugPrint("Sort, insertionSort ascending: \(insertionSort(array, <))")
        fwDebugPrint("Sort, insertionSort descending: \(insertionSort(array, >))")

        showLogs()
    }

    @objc private func selectionSortAction() {
        fwPrintEnter(message: "Selection Sort")
        let array = buildArray(number: 10, low: 1, high: 100)
        fwDebugPrint("Sort, selectionSort: \(selectionSort(array))")
        fwDebugPrint("Sort, selectionSort ascending: \(selectionSort(array, <))")
        fwDebugPrint("Sort, selectionSort descending: \(selectionSort(array, >))")

        showLogs()
    }

    @objc private func quickSortAction() {
        fwPrintEnter(message: "Quick Sort")
        var array = buildArray(number: 100, low: 1, high: 1000)
        fwDebugPrint("Sort, array: \(array)")
        fwDebugPrint("Sort, quickSort: \(quickSort(array))")

        quickSortDutchFlag(&array, low: 0, high: array.count - 1)
        fwDebugPrint("Sort, quickSortDutchFlag: \(array)")

        showLogs()
    }

    @objc private func mergeSortAction() {
        fwPrintEnter(message: "Merge Sort")
        let array = buildArray(number: 10, low: 1, high: 100)
        fwDebugPrint("Sort, array: \(array)")
        fwDebugPrint("Sort, mergeSort: \(mergeSort(array))")

        showLogs()
    }

    @objc private func bucketSortAction() {
        fwPrintEnter(message: "Bucket Sort")

        let largeArray = buildArray(number: 400, low: 1, high: 10000)
        let results = performBucketSort(largeArray, totalBuckets: 8)
        fwDebugPrint("Sort, count:\(largeArray.count), isSorted: \(isSorted(results))")
        fwDebugPrint("Sort, results: \(results)")

        showLogs()
    }

    fileprivate func performBucketSort(_ elements: [Int], totalBuckets: Int) -> [Int] {
        let value = (elements.max()?.toInt())! + 1
        let capacityRequired = Int(ceil(Double(value) / Double(totalBuckets)))

        var buckets = [Bucket<Int>]()
        for _ in 0 ..< totalBuckets {
            buckets.append(Bucket<Int>(capacity: capacityRequired))
        }

        return bucketSort(elements, distributor: RangeDistributor(), sorter: InsertionSorter(), buckets: buckets)
    }

    @objc private func countingSortAction() {
        fwPrintEnter(message: "Counting Sort")
        let array = buildArray(number: 6, low: 1, high: 10)
        fwDebugPrint("Sort, array: \(array)")
        fwDebugPrint("Sort, countingSort: \(countingSort(array))")

        showLogs()
    }

    @objc private func radixSortAction() {
        fwPrintEnter(message: "Radix Sort")
        var array = buildArray(number: 1000, low: 1, high: 1000)
        radixSort(&array)
        fwDebugPrint("Sort, array count: \(array.count), isSorted:\(isSorted(array))")
        fwDebugPrint("Sort, radixSort: \(array)")

        showLogs()
    }

    @objc private func binarySearchAction() {
        fwPrintEnter(message: "Binary Search")
        let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

        // Binary search requires that the array is sorted from low to high
        let sorted = numbers.sorted()
        fwDebugPrint("binarySearch, sorted: \(sorted)")

        let f2 = binarySearch(sorted, key: 2, range: 0 ..< sorted.count)
        let f67 = binarySearch(sorted, key: 67, range: 0 ..< sorted.count)
        let f42 = binarySearch(sorted, key: 42, range: 0 ..< sorted.count)

        let ff2 = binarySearch(sorted, key: 2)
        let ff67 = binarySearch(sorted, key: 67)
        let ff42 = binarySearch(sorted, key: 42)

        fwDebugPrint("binarySearch f2: \(String(describing: f2)), compare: \(f2 == ff2)")
        fwDebugPrint("binarySearch f67: \(String(describing: f67)), compare: \(f67 == ff67)")
        fwDebugPrint("binarySearch f42: \(String(describing: f42)), compare: \(f42 == ff42)")

        showLogs()
    }

    @objc private func skipListAction() {
        fwPrintEnter(message: "Skip List")

        let dataArray = buildArray(number: 1000, low: 1, high: 1000, isUnique: true)
        let randomIndex = Int(arc4random_uniform(UInt32(dataArray.count - 1)))
        let fValue = dataArray[randomIndex]
        let skipList = SkipList<Int, String>()

        for item in dataArray {
            skipList.insert(key: item, data: String(item))
        }

        if let value = skipList.get(key: fValue) {
            showLogs("found value:\(value) in \(dataArray.count) numbers")
        } else {
            showLogs("No found value: \(fValue) in \(dataArray.count) numbers")
        }
    }

    @objc private func hashTableAction() {
        fwPrintEnter(message: "Hash Table")

        // playing with has values
        fwDebugPrint("firstName hashValue: \("firstName".hashValue), \("firstName".hashValue % 5)")

        var hashTable = HashTable<String, String>(capacity: 5)
        hashTable["firstName"] = "Seteve"
        hashTable["lastName"] = "Jobs"
        hashTable["hobbies"] = "Programming Sift"
        fwDebugPrint("hashTable: \(hashTable)")
        showLogs(hashTable.description)

        let firstName = hashTable["firstName"]
        fwDebugPrint("Fist name: \(String(describing: firstName))")
        fwDebugPrint("DebugDescription: \(hashTable.debugDescription)")
    }

    @objc private func lRUCacheAction() {
        fwPrintEnter(message: "LRU Cache")

        let cache = LRUCache<String>(2)
        cache.set("a", val: 1)
        cache.set("b", val: 2)
        var iResult = cache.get("a") // returns 1
        fwDebugPrint("a->1, iResult: \(String(describing: iResult))")
        cache.set("c", val: 3) // evicts key "b"
        iResult = cache.get("b") // returns nil (not found)
        fwDebugPrint("b-> nil, iResult: \(String(describing: iResult))")
        cache.set("d", val: 4) // evicts key "a"
        iResult = cache.get("a") // returns nil (not found)
        fwDebugPrint("a->nil, iResult: \(String(describing: iResult))")
        iResult = cache.get("c") // returns 3
        fwDebugPrint("c->3, iResult: \(String(describing: iResult))")
        iResult = cache.get("d") // returns 4
        fwDebugPrint("d->4, iResult: \(String(describing: iResult))")
        showLogs()
    }

    @objc private func binaryTreeAction() {
        fwPrintEnter(message: "Binary Tree")
        fwDebugPrint("show: (5 * (a - 10)) + (-4 * (3 / b))")

        // left nodes
        let node5 = BinaryTree.node(.empty, "5", .empty)
        let nodeA = BinaryTree.node(.empty, "a", .empty)
        let node10 = BinaryTree.node(.empty, "10", .empty)
        let node4 = BinaryTree.node(.empty, "4", .empty)
        let node3 = BinaryTree.node(.empty, "3", .empty)
        let nodeB = BinaryTree.node(.empty, "b", .empty)

        // intermediate node on the left
        let aMinus10 = BinaryTree.node(nodeA, "-", node10)
        let timesLeft = BinaryTree.node(node5, "*", aMinus10)

        // intermediate node no the right
        let minus4 = BinaryTree.node(.empty, "-", node4)
        let divide3andB = BinaryTree.node(node3, "/", nodeB)
        let timesRight = BinaryTree.node(minus4, "*", divide3andB)

        // root node
        let tree = BinaryTree.node(timesLeft, "+", timesRight)
        fwDebugPrint("Tree: \(tree)")
        fwDebugPrint("Count: \(tree.count)")

        fwPrintEnter(message: "In-order")
        tree.traverseInOrder { s in fwDebugPrint(s) }

        fwPrintEnter(message: "Pre-order")
        tree.traversePreOrder { s in fwDebugPrint(s) }

        fwPrintEnter(message: "Post-order")
        tree.traversePostOrder { s in fwDebugPrint(s) }

        showLogs()
    }

    @objc private func binarySearchTreeAction() {
        fwPrintEnter(message: "Binary Search Tree")
        let tree = BinarySearchTree<Int>(array: [33, 16, 50, 13, 18, 34, 58, 15, 17, 25, 51, 66, 19, 27, 55])
        tree.insert(value: 1)
        // yxc_debugPrint("tree: \(tree)")
        // draw binary tree
        fwDebugPrint(tree.printBinaryTree)

        let node1 = tree.search(value: 1)
        node1?.remove()
        let node18 = tree.search(value: 18)
        node18?.remove()
        fwDebugPrint("tree: \(tree)")

        tree.traverseInOrder { value in
            fwDebugPrint(value)
        }

        let treeAry = tree.toArray()
        fwDebugPrint("ToArray: \(treeAry)")
        fwDebugPrint("minimum: \(tree.minimum())")
        fwDebugPrint("maximum: \(tree.maximum())")
        fwDebugPrint("height: \(tree.height())")
        fwDebugPrint("predecessor: \(String(describing: tree.predecessor()))")
        fwDebugPrint("successor: \(String(describing: tree.successor()))")

        if let node9 = tree.search(value: 9) {
            fwDebugPrint("node9 depth: \(node9.depth())")
            fwDebugPrint("node9 height: \(node9.height())")

            var bRestlt = tree.isBST(minValue: Int.min, maxValue: Int.max) // true
            fwDebugPrint("isBST: \(bRestlt)")
            node9.insert(value: 100)
            let node100 = tree.search(value: 100) // nil
            bRestlt = tree.isBST(minValue: Int.min, maxValue: Int.max) // false

            fwDebugPrint("isBST 100: \(bRestlt), node100: \(String(describing: node100))")
        }

        // Heap Tree
        let family = ["Me", "Paul", "Rosa", "Vincent", "Jody", "John", "Kate"]
        family.printHeapTree()
        // family.printHeapTree(reversed: true)

        showLogs()
    }

    @objc private func avlTreeAction() {
        fwPrintEnter(message: "AVL Tree")
        let tree = AVLTree<Character, String>()
        tree.insert(key: "F", payload: "F")
        tree.insert(key: "D", payload: "D")
        tree.insert(key: "G", payload: "G")
        tree.insert(key: "B", payload: "B")
        tree.insert(key: "E", payload: "E")
        tree.insert(key: "A", payload: "A")
        tree.insert(key: "C", payload: "C")
        fwDebugPrint(tree)
        fwDebugPrint(tree.debugDescription)

        let nodeE = tree.search(input: "E")
        fwDebugPrint("nodeE: \(String(describing: nodeE))")

        tree.delete(key: "A")
        tree.delete(key: "C")
        tree.delete(key: "B")
        tree.delete(key: "E")
        tree.delete(key: "G")
        fwDebugPrint(tree)

        showLogs()
    }

    @objc private func redBlackTreeAction() {
        fwPrintEnter(message: "Red-Black Tree")
        let rbTree = RedBlackTree<Int>()
        var values = [Int]()
        let maxNumber = 1000

        for i in 0 ..< maxNumber {
            let value = Int(arc4random_uniform(UInt32(maxNumber)))
            values.append(value)
            rbTree.insert(key: value)

            if (i % (maxNumber / 5)) == 0 {
                fwDebugPrint("index: \(i) verify: \(rbTree.verify())")
            }
        }
        fwDebugPrint("verify: \(rbTree.verify())")

        for i in 0 ..< maxNumber {
            let rand = arc4random_uniform(UInt32(values.count))
            let value = values.remove(at: Int(rand))
            rbTree.delete(key: value)

            if i % (maxNumber / 5) == 0 {
                fwDebugPrint("index: \(i) verify: \(rbTree.verify())")
            }
        }
        fwDebugPrint("verify: \(rbTree.verify())")

        showLogs()
    }

    @objc private func heapAction() {
        fwPrintEnter(message: "Heap")
        let dataArray = [27, 17, 3, 16, 13, 10, 1, 5, 7, 12, 4, 8, 9, 0]
        let maxHeap = Heap(array: dataArray, sort: >)
        maxHeap.nodes.printHeapTree()
        fwDebugPrint("maxHeap: \(maxHeap)")
        fwDebugPrint("verifyMaxHeap: \(verifyMaxHeap(maxHeap)), verifyMinHeap: \(verifyMinHeap(maxHeap))")

        let minHeap = Heap(array: dataArray, sort: <)
        minHeap.nodes.printHeapTree()
        fwDebugPrint("minHeap: \(minHeap)")
        showLogs()
    }

    @objc private func heapSortAction() {
        fwPrintEnter(message: "Heap Sort")
        let dataArray = [5, 13, 2, 25, 7, 17, 20, 8, 4]
        var maxHeap = Heap(array: dataArray, sort: >)
        maxHeap.nodes.printHeapTree()
        fwDebugPrint("maxHeap sort: \(maxHeap.sort())")

        let heapSort = heapsort(dataArray, <)
        heapSort.printHeapTree()
        fwDebugPrint("heapSort: \(heapSort)")

        showLogs()
    }

    @objc private func graphAction() {
        fwPrintEnter(message: "Graph")
        let matrixGraph = AdjacencyMatrixGraph<String>()
        let a = matrixGraph.createVertex("a")
        let b = matrixGraph.createVertex("b")
        let c = matrixGraph.createVertex("c")
        matrixGraph.addDirectedEdge(a, to: b, withWeight: 1.0)
        matrixGraph.addDirectedEdge(b, to: c, withWeight: 2.0)
        fwDebugPrint("Maxtrix Graph:")
        fwDebugPrint(matrixGraph.description)

        let listGrpah = AdjacencyListGraph<String>()
        let al = listGrpah.createVertex("a")
        let bl = listGrpah.createVertex("b")
        let cl = listGrpah.createVertex("c")
        listGrpah.addDirectedEdge(al, to: bl, withWeight: 1.0)
        listGrpah.addDirectedEdge(bl, to: cl, withWeight: 2.0)
        listGrpah.addDirectedEdge(al, to: cl, withWeight: -5.5)
        fwDebugPrint("List Graph:")
        fwDebugPrint(listGrpah.description)

        showLogs()
    }

    @objc private func depthFirstSearchAction() {
        fwPrintEnter(message: "Depth-Fist Search")

        let graph = GSGraph()
        let nodeA = graph.addNode("a")
        let nodeB = graph.addNode("b")
        let nodeC = graph.addNode("c")
        let nodeD = graph.addNode("d")
        let nodeE = graph.addNode("e")
        let nodeF = graph.addNode("f")
        let nodeG = graph.addNode("g")
        let nodeH = graph.addNode("h")

        graph.addEdge(nodeA, neighbor: nodeB)
        graph.addEdge(nodeA, neighbor: nodeC)
        graph.addEdge(nodeB, neighbor: nodeD)
        graph.addEdge(nodeB, neighbor: nodeE)
        graph.addEdge(nodeC, neighbor: nodeF)
        graph.addEdge(nodeC, neighbor: nodeG)
        graph.addEdge(nodeE, neighbor: nodeH)
        graph.addEdge(nodeE, neighbor: nodeF)
        graph.addEdge(nodeF, neighbor: nodeG)

        let nodeExplored = depthFirstSearch(graph, source: nodeA)
        // ["a", "b", "d", "e", "h", "f", "g", "c"]
        fwDebugPrint("depthFirstSearch:")
        fwDebugPrint(nodeExplored)

        showLogs()
    }

    @objc private func breadthFirstSearchAction() {
        fwPrintEnter(message: "Breadth-First Search")

        let graph = GSGraph()
        let nodeA = graph.addNode("a")
        let nodeB = graph.addNode("b")
        let nodeC = graph.addNode("c")
        let nodeD = graph.addNode("d")
        let nodeE = graph.addNode("e")
        let nodeF = graph.addNode("f")
        let nodeG = graph.addNode("g")
        let nodeH = graph.addNode("h")

        graph.addEdge(nodeA, neighbor: nodeB)
        graph.addEdge(nodeA, neighbor: nodeC)
        graph.addEdge(nodeB, neighbor: nodeD)
        graph.addEdge(nodeB, neighbor: nodeE)
        graph.addEdge(nodeC, neighbor: nodeF)
        graph.addEdge(nodeC, neighbor: nodeG)
        graph.addEdge(nodeE, neighbor: nodeH)
        graph.addEdge(nodeE, neighbor: nodeF)
        graph.addEdge(nodeF, neighbor: nodeG)

        let nodeExplored = breadthFirstSearch(graph, source: nodeA)
        // ["a", "b", "c", "d", "e", "f", "g", "h"]
        fwDebugPrint("breadthFirstSearch:")
        print(nodeExplored)

        showLogs()
    }

    @objc private func bruteForceAction() {
        fwPrintEnter(message: "Brute Force String Search")
        let s = "Hello World!"
        if let wIndex = s.indexOf("World") {
            fwDebugPrint("World index: \(String(describing: wIndex)), \(s[..<wIndex])")
        } else {
            fwDebugPrint("No found")
        }

        showLogs()
    }

    @objc private func rabinKarpAction() {
        fwPrintEnter(message: "Rabin-Karp String Search")
        let text = "The big dog jumped over the fox"
        let umpIndex = searchStringByRK(text: text, pattern: "ump")
        // 13
        fwDebugPrint("find ump in '\(text)' index: \(umpIndex)")

        showLogs()
    }

    @objc private func boyerMooreAction() {
        fwPrintEnter(message: "Boyer-Moore String Search")
        let text = "Hello, World"
        if let fIndex = text.index(of: "World") {
            fwDebugPrint("find World : \(String(describing: fIndex)), in '\(text)' subString \(text[..<fIndex])")
        } else {
            fwDebugPrint("no find 'Word'")
        }
        showLogs()
    }

    @objc private func knuthMorrisPrattAction() {
        fwPrintEnter(message: "Knuth-Morris-Pratt String Search")
        let text = "ACCCGGTTTTAAAGAACCACCATAAGATATAGACAGATATAGGACAGATATAGAGACAAAACCCCATACCCCAATATTTTTTTGGGGAGAAAAACACCACAGATAGATACACAGACTACACGAGATACGACATACAGCAGCATAACGACAACAGCAGATAGACGATCATAACAGCAATCAGACCGAGCGCAGCAGCTTTTAAGCACCAGCCCCACAAAAAACGACAATFATCATCATATACAGACGACGACACGACATATCACACGACAGCATA"
        let indexs = text.indexesOf(ptnr: "CATA")

        // [20, 64, 130, 140, 166, 234, 255, 270]
        fwDebugPrint("indexs: \(String(describing: indexs))")

        showLogs()
    }

    @objc private func trieAction() {
        fwPrintEnter(message: "Trie")
        buidTrieTree()

        if let tmpTrie = trie {
            tmpTrie.insert(word: "foobar")
            tmpTrie.remove(word: "foobar")

            let words = tmpTrie.words
            fwDebugPrint("words: \(words.count)")
            let purr = tmpTrie.findWordsWithPrefix(prefix: "purr")
            print("Prefix purr:")
            print(purr.joined(separator: "\n"))
        }

        showLogs()
    }

    @objc private func ahoCorasickAction() {
        fwPrintEnter(message: "Aho-Corasick")

        // tokenize
        let speech = "The Answer to the Great Question... Of Life, " +
            "the Universe and Everything... Is... Forty-two,' said " +
            "Deep Thought, with infinite majesty and calm."
        let tokenTrie = ACTrie.builder()
            .removeOverlaps()
            .onlyDelimited()
            .caseInsensitive()
            .add(keyword: "great question")
            .add(keyword: "forty-two")
            .add(keyword: "deep thought")
            .build()
        let tokens = tokenTrie.tokenize(text: speech)

        var tokenHtml = ""
        tokenHtml.append("<html><body><p>")
        for token in tokens {
            if token.isMatch {
                tokenHtml.append("<b style='color:red'>")
            }
            tokenHtml.append(token.fragment)
            if token.isMatch {
                tokenHtml.append("</b>")
            }
        }
        tokenHtml.append("</p></body></html>")
        fwDebugPrint("Tokens:")
        print(tokenHtml)

        // parse
        let pTrie = ACTrie.builder()
            .add(keyword: "hers")
            .add(keyword: "his")
            .add(keyword: "she")
            .add(keyword: "he")
            .build()
        let emits = pTrie.parse(text: "ushers")
        // she @ 3, he @ 3, hers @ 5
        fwDebugPrint("Parse: \(emits)")

        // containsMatch
        let cTrie = ACTrie.builder().removeOverlaps()
            .add(keyword: "ab")
            .add(keyword: "cba")
            .add(keyword: "ababc")
            .build()

        fwDebugPrint(cTrie.containsMatch(text: "ababcbab"))

        showLogs()
    }

    @objc private func huffmanCodingAction() {
        fwPrintEnter(message: "Huffman Coding")
        let s1 = "zh:霍夫曼编; en：so much word wow many compression; number:1234567890"
        if let orginalData = s1.data(using: .utf8) {
            fwDebugPrint("s1:\(s1) count: \(orginalData.count)")

            let huffman1 = Huffman()
            let compressedData = huffman1.compressData(data: orginalData as NSData)
            fwDebugPrint("compressedData length: \(compressedData.length)")

            let freequencyTable = huffman1.frequencyTable()
            let huffman2 = Huffman()
            let decompressedData = huffman2.decompressData(data: compressedData, frequencyTable: freequencyTable)
            fwDebugPrint("decompressedData length: \(decompressedData.length)")
            let s2 = String(data: decompressedData as Data, encoding: .utf8)!
            fwDebugPrint("s1 and s2: \(s1 == s2)")
        } else {
            showLogs("Failed string to data.")
        }

        showLogs()
    }

    @objc private func dijkstraShortestPathAction() {
        fwPrintEnter(message: "Dijkstra's shortest path algorithm")

        // Initialize random graph
        let djData = DijkstraData()
        djData.createNotConnectedVertices()
        djData.setupConnections()

        // initialize Dijkstra algorithm with graph vertices
        let dijkstra = Dijkstra(vertices: djData.vertices)

        // decide which vertex will be the starting one
        let startVertex = djData.randomVertex()

        let startTime = Date()
        // ask algorithm to find shortest paths from start vertex to all others
        dijkstra.findShortestPaths(from: startVertex)

        print("calculation time is = \(Date().timeIntervalSince(startTime)) sec")

        // printing results
        let destinationVertex = djData.randomVertex(except: startVertex)
        print(destinationVertex.pathLengthFromStart)
        var pathVerticesFromStartString: [String] = []

        for vertex in destinationVertex.pathVerticesFromStart {
            pathVerticesFromStartString.append(vertex.identifier)
        }
        print(pathVerticesFromStartString.joined(separator: "->"))

        showLogs()
    }

    @objc private func bitSetAction() {
        fwPrintEnter(message: "Bit Set")

        var b4 = BitSet(size: 4)
        print("BitSet 4: \(b4)")
        b4.setAll()
        print("BitSet 4 setAll(): \(b4)")
        // 4
        print("BitSet 4, cardinality :\(b4.cardinality)")
        b4[1] = false
        b4[2] = false
        b4[3] = false
        print("BitSet 4: \(b4)")
        print("BitSet 1/4: \(b4[0])")

        showLogs()
    }

    @objc private func bloomFilterAction() {
        fwPrintEnter(message: "Bloom Filter")
        let bloom = BloomFilter<String>(size: 17, hashFunctions: [djb2, sdbm])
        fwDebugPrint("BloomFilter: \(bloom)")

        bloom.insert("Hello world!")
        fwDebugPrint("insert Hello world!: \(bloom)")
        // true
        fwDebugPrint("query Hello world!, result: \(bloom.query("Hello world!"))")
        // false
        fwDebugPrint("query Hello WORLD, result: \(bloom.query("Hello WORLD"))")

        // false
        bloom.insert("Bloom Filterz")
        fwDebugPrint("query Hello WORLD, result: \(bloom.query("Hello WORLD"))")
        fwDebugPrint("insert Bloom Filterz: \(bloom)")

        showLogs()
    }

    @objc private func bTreeAction() {
        fwPrintEnter(message: "B-Tree")
        let bTree = BTree<Int, Int>(order: 1)!
        bTree.insert(1, for: 1)
        bTree.insert(2, for: 2)
        bTree.insert(3, for: 3)
        bTree.insert(4, for: 4)
        bTree.insert(5, for: 5)
        fwDebugPrint("value for 3: \(String(describing: bTree.value(for: 3))), bTree[3]: \(String(describing: bTree[3]))")

        bTree.traverseKeysInOrder { key in
            print(key)
        }

        fwDebugPrint("numberOfKeys: \(bTree.numberOfKeys)")
        fwDebugPrint("inorderArrayFromKeys: \(bTree.inorderArrayFromKeys)")

        showLogs()
    }

    // MARK: - Private

    private func buildArray(number: Int, low: Int, high: Int, isUnique: Bool = false) -> [Int] {
        var array = [Int]()
        for _ in 0 ..< number {
            array.append(Randoms.randomInt(low, high))
        }

        if isUnique {
            var setArray = Set(array)
            while setArray.count < number {
                let tValue = Randoms.randomInt(low, high)
                if !setArray.contains(tValue) {
                    setArray.insert(tValue)
                }
            }

            array = Array(setArray)
        }

        return array
    }

    private func isSorted(_ array: [Int]) -> Bool {
        var index = 0
        var sorted = true
        while index < (array.count - 1), sorted {
            if array[index] > array[index + 1] {
                sorted = false
            }
            index += 1
        }

        return sorted
    }

    private func verifyMaxHeap(_ h: Heap<Int>) -> Bool {
        for i in 0 ..< h.count {
            let left = h.leftChildIndex(ofIndex: i)
            let right = h.rightChildIndex(ofIndex: i)
            let parent = h.parentIndex(ofIndex: i)
            if left < h.count, h.nodes[i] < h.nodes[left] { return false }
            if right < h.count, h.nodes[i] < h.nodes[right] { return false }
            if i > 0, h.nodes[parent] < h.nodes[i] { return false }
        }
        return true
    }

    private func verifyMinHeap(_ h: Heap<Int>) -> Bool {
        for i in 0 ..< h.count {
            let left = h.leftChildIndex(ofIndex: i)
            let right = h.rightChildIndex(ofIndex: i)
            let parent = h.parentIndex(ofIndex: i)
            if left < h.count, h.nodes[i] > h.nodes[left] { return false }
            if right < h.count, h.nodes[i] > h.nodes[right] { return false }
            if i > 0, h.nodes[parent] > h.nodes[i] { return false }
        }
        return true
    }

    private func buidTrieTree() {
        if let tmpTrie = trie, tmpTrie.count > 0 {
            return
        }

        let archiveName = "trie-archive"
        // 归档有数据，解析后返回
        if let unArchiveTrie = SCUtils.loadData(archiveName) as? Trie {
            trie = unArchiveTrie
            return
        }

        let resourcePath = Bundle.main.resourcePath! as NSString
        let filePath = resourcePath.appendingPathComponent("trie_data.txt")

        var data: String?
        do {
            data = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            fwDebugPrint("\(error.description)")
        }

        var wordArray: [String]?
        if let tmpData = data {
            wordArray = tmpData.components(separatedBy: "\n")
            fwDebugPrint("wordArray count: \(String(describing: wordArray?.count))")
        }

        if let tmpArray = wordArray {
            trie = Trie()
            for word in tmpArray {
                trie!.insert(word: word)
            }

            if trie!.count > 0 {
                SCUtils.saveData(trie!, key: archiveName)
            }
        }
    }

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property

    var trie: Trie?
}
