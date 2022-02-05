## SwiftCase

**SwiftCase** is a pure Swift development example that includes basic component usage, design patterns, algorithms, and some small examples.

![screenshot](images/scdemo.gif)



### [中文](./README_ZH.md)



### [ Website information - Learn And Practice](https://fd-learning.com/learner/page/index.html)




### Features

---

- **UIKit**

  - Function - the usage of strings, arrays, dictionaries, sets and tuples
  - UIVIew  - Use snapkit for interface layout and AutoLayout page layout
  - Flexbox case - Use flexbox to load interface layout and plist files
  - UIButton - Common attributes of button; Fillet button, text button, graphic button
  - UILable - Common attributes of label; Multiline text, rich text, and mixed text and text arrangement
  - UICollectionView - Collection property, page header, footer and other settings
  - UITextField - Textfield property, definition of left and right views, keyboard lifting, closing and other functions
  - UITextView - Textview property and placeholder definition
  - Widget By Rx - Use of common components of RX
  - RxSwift and RxCocoa - Syntax and characteristics of RX
  - MapView-GaoDe Map - Use example of Gaode map
  - Event - Click event, long press event, slide, drag, and zoom in and out demonstration of pictures
  - UI Event - Demonstrate the data transfer between swift and OC through closures and agents
  - Thread, OperationQueue, GCD - Three ways to use threads
  - Animation - To be realized
  - Parse JSON by simdjson(Cocoapods ZippyJSON) - Use of the fastest library for parsing JSON
  - Communication：HTTP、gPRC、WebSocket、Bluetooth、Wifi - Data communication mode. At present, HTTP and GPRC network requests are realized, and the use of websocket is demonstrated through chat room

  

- **Algorithms**

  - Swift-algorithms
  - Collections: Array、Dictionary、Sets
  - Array2D: two-dimensional array
  - Linked List - Bidirectional linked list data structure
  - Stack - Data structure of stack
  - Queue - Queue data structure
  - Recursion  - Use of recursive search
  - Bubble Sort   - Bubble sort algorithm 
  - Insertion Sort - Insertion sort is a simple sorting algorithm that builds the final sorted array (or list) one item at a time.  
  - Selection Sort  -  The selection sort algorithm divides the array into two parts: the beginning of the array is sorted, while the rest of the array consists of the numbers that still remain to be sorted.
  - *Quick Sort  - Quicksort is an in-place sorting algorithm. 
  - Merge Sort  - The merge-sort algorithm uses the **divide and conquer** approach which is to divide a big problem into smaller problems and solve them.
  - Bucket Sort  - Bucket sort, or bin sort, is a sorting algorithm that works by distributing the elements of an array into a number of buckets.
  - Counting Sort   - Counting sort is an algorithm for sorting a collection of objects according to keys that are small integers.
  - Radix Sort   - Radix sort is a sorting algorithm that takes as input an array of integers and uses a sorting subroutine( that is often another efficient sorting algorith) to sort the integers by their radix, or rather their digit. Counting Sort, and Bucket Sort are often times used as the subroutine for Radix Sort.
  - Binary Search   - A binary tree that orders its nodes in a way that allows for fast queries.
  - Skip List  - Skip List is a probabilistic data-structure with same logarithmic time bound and efficiency as AVL/ or Red-Black tree and provides a clever compromise to efficiently support search and update operations.
  - Hash Table   - A hash table allows you to store and retrieve objects by a "key".
  - LRU(Least Recently Used) Cache   - Least Recently Used (LRU) is a popular algorithm in cache design.
  - Binary Tree   - A binary tree is a [tree](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Tree) where each node has 0, 1, or 2 children. 
  - Binary Search Tree (BST)   - A binary search tree is a special kind of [binary tree](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Binary Tree) (a tree in which each node has at most two children) that performs insertions and deletions such that the tree is always sorted.
  - AVL tree (named after inventors Adelson-Velsky and Landis)
  - Red-Black Tree   - A red-black tree (RBT) is a balanced version of a Binary Search Tree guaranteeing that the basic operations (search, predecessor, successor, minimum, maximum, insert and delete) have a logarithmic worst case performance.
  - Heap  - A heap is a binary tree inside an array, so it does not use parent/child pointers. A heap is sorted based on the "heap property" that determines the order of the nodes in the tree.
  - Heap Sort  - Sorts an array from low to high using a heap.
  - Graph  - a graph is defined as a set of vertices paired with a set of edges. The vertices are represented by circles, and the edges are the lines between them. Edges connect a vertex to other vertices.
  - Depth-First Search   - Depth-first search (DFS) is an algorithm for traversing or searching tree or graph data structures. It starts at a source node and explores as far as possible along each branch before backtracking.
  - Breadth-First Search   - Breadth-first search (BFS) is an algorithm for traversing or searching [tree](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Tree) or [graph](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph) data structures. It starts at a source node and explores the immediate neighbor nodes first, before moving to the next level neighbors.
  - Brute Force string search   - The brute-force approach works OK, but it's not very efficient (or pretty).
  - Rabin-Karp string search   - The Rabin-Karp string search algorithm is used to search text for a pattern.
  - Boyer-Moore string search   - The skip-ahead algorithm is called Boyer-Moore and it has been around for a long time. It is considered the benchmark for all string search algorithms.
  - Knuth-Morris-Pratt string search - The [Knuth-Morris-Pratt algorithm](https://en.wikipedia.org/wiki/Knuth–Morris–Pratt_algorithm) is considered one of the best algorithms for solving the pattern matching problem. 
  - Trie  - A `Trie`, (also known as a prefix tree, or radix tree in some other implementations) is a special type of tree used to store associative data structures.
  - Aho-Corasick - The AHO-CORASICK algorithm is a string search algorithm invented by Alfred V. AHO and Margaret J.Corasick,  for matching substrings in the Finite Group "Dictionary" in the input string. 
  - Huffman Coding  - Hoffman coding uses the beam-leader code table to encode the source symbol (such as one letter in the file), where the bearing length coded table is obtained by a method of evaluating the probability of an evaluation source symbol, shorter use of high probability is shorter.The encoding, the probability is low, which uses a longer code, which makes the average length of the string after the encoding, and the desired value is lowered, thereby achieving lossless compressed data.
  - Dijkstra's shortest path - The original version of Daxterra applies only to find the shortest path between the two vertices, and later, the more common variants are fixed as a source of source and then find the vertex to all other nodes in the figure.The shortest path produces a shortest path tree.
  - Bit Set  - A fixed-size sequence of *n* bits. Also known as bit array or bit vector.
  - Bloom Filter   - A Bloom Filter is a space-efficient data structure that tells you whether or not an element is present in a set.
  - B-Tree - A B-Tree is a self-balancing search tree, in which nodes can have more than two children.

  

- **Design Patterns**

  - Creational
    - Singleton          
    - Factory            
    - AbstractFactory                 
    - Builder                 
    - Prototype 
  - Structural          
    - Proxy           
    - Bridge           
    - Decorator           
    - Adapte           
    - Flyweight           
    - Composite
  - Behavioral       
    - Observer       
    - Template Method        
    - Strategy           
    - ChainResponsibility       
    - Iterator           
    - State           
    - Visitor           
    - Memento           
    - Mediator           
    - Interpreter

  

- **Case**

  - Brows Images - Browse image examples
  - Call OC function - OC and swift use each other
  - List -List use
  - Up down swipe - View up and down switching
  - Show RxSwift + MVVM - MVVM architecture example using RX



### Requirements
iOS 13.0+ 



### Installation
Download SwiftCase and you need to execute ```Pod Install``` to use it



### Author
ForrestWang mail: forrestwang@aliyun.com



### License
SwiftCase is released under the MIT license. See LICENSE for details.
