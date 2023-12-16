## SwiftCase
 
**SwiftCase** 是一个Swift的开发示例，便于一些用法的参考，提高开发速度；该项目主要包括：基本组件、设计模式、算法及一些案例。

![screenshot](images/scdemo.gif)

### [English](./README_en.md)

### [网站资料 - 力学笃行](https://fd-learning.com/learner/page/index.html)

### 特性

---

- **UIKit**

  - Function - strings, arrays, dictionaries, sets, and tuples使用
  - UIVIew  - 使用SnapKit 进行界面布局及autolayout方式页面布局
  - Flexbox case - 使用FlexBox进行界面布局、plist文件的加载
  - UIButton - Button的常用属性；圆角按钮，文字按钮、图文按钮
  - UILable - Lable的常用属性；多行文本、富文本、及图文混排
  - UICollectionView - Collection属性，页头、页脚等设置

  - UITextField - TextField 属性、左右View的定义、键盘抬起、关闭等功能
  - UITextView - TextView属性及Placeholder定义
  - Widget By Rx - Rx的常用组件的使用
  - RxSwift and RxCocoa - Rx的语法及特性
  - PickerView - PickerView 使用
  - JXSegmentedView - 分段选择
  - MapView-GaoDe Map - 高德地图使用示例
  - Event - 点击事件、长按事件、滑动、拖动、及图片的放大缩小演示
  - UI Event - 演示Swift与OC通过闭包、代理的方式进行数据传递
  - Thread, OperationQueue, GCD - 演示线程的三种使用方法
  - Animation - 待实现
  - Parse JSON by simdjson(Cocoapods ZippyJSON) - 解析JSON最快的库的使用
  - Communication：HTTP、gPRC、WebSocket、Bluetooth、Wifi - 数据通信方式，当前实现了HTTP及gPRC网络请求、通过聊天室演示WebSocket的使用

- **Algorithms**

  - Swift-algorithms - apple/swift-algorithms的使用
  - Collections: Array、Dictionary、Sets - Swift提供的数组、字典、集合的使用
  - Array2D: two-dimensional array - 具有固定数目的行和列的二维数组。
  - Linked List - 双向链表数据结构
  - Stack - 栈的数据结构
  - Queue - 队列数据结构
  - Recursion  - 递归求的使用
  - Bubble Sort   - 冒泡排序算法
  - Insertion Sort    - 插入法排序算法
  - Selection Sort   - 选择法法排序算法
  - *Quick Sort    - 快速排序算法
  - Merge Sort  - 归并排序算法
  - Bucket Sort  - 桶排序算法
  - Counting Sort   - 计数排序算法
  - Radix Sort   - 索引法排序算法
  - Binary Search   - 二叉树搜索
  - Skip List  - Skip List是一种概率数据结构，与AVL/或红黑树具有相同的对数时间限制和效率，提供了一种巧妙的折衷，有效地支持搜索和更新操作，与其他地图数据结构相比，实现起来相对简单。
  - Hash Table   - 哈希表允许你通过一个“键”来存储和检索对象。
  - LRU(Least Recently Used) Cache  - 缓存用于在内存中保存对象。缓存大小是有限的;如果系统没有足够的内存，必须清除缓存，否则程序将崩溃。最近最少使用算法(Least Recently Used, LRU)是缓存设计中常用的算法。
  - Binary Tree - 二叉树是每个节点都有0、1或2个子结点的树。
  - Binary Search Tree (BST)   - 二叉搜索树是一种特殊的二叉树(树中每个节点最多有两个子节点)，它执行插入和删除操作，使树始终是有序的。
  - AVL tree (named after inventors Adelson-Velsky and Landis) - AVL树是二叉搜索树的一种自平衡形式，其中子树的高度最多相差1。
  - Red-Black Tree   - 红黑树(RBT)是二叉搜索树的一个平衡版本，它保证了基本的操作(搜索、前身、后继、最小、最大值、插入和删除)在最坏情况下具有对数性能。
  - Heap  - 堆是数组内的二进制树，因此它不使用父/子指针。基于“堆属性”对堆进行排序，该“堆属性”确定树中节点的顺序。
  - Heap Sort   - 使用堆将数组从低到高排序。
  - Graph  - 图被定义为顶点与边的集合。顶点用圆表示，边是它们之间的线。边连接一个顶点和其他顶点。
  - Depth-First Search   - 深度优先搜索(DFS)是一种遍历或搜索树或图数据结构的算法。它从一个源节点开始，在回溯之前尽可能沿着每个分支进行探索。
  - Breadth-First Search   - 宽度优先搜索(BFS)是一种遍历或搜索树或图数据结构的算法。它从一个源节点开始，首先探索邻近节点，然后再移动到下一层邻居。
  - Brute Force string search   - 蛮力方法是可行的，但它不是很有效(或漂亮)。
  - Rabin-Karp string search   - Rabin-Karp字符串搜索算法用于搜索文本中的模式。
  - Boyer-Moore string search   - 超前跳跃算法被称为博伊尔-摩尔算法，已经存在很长时间了。它被认为是所有字符串搜索算法的基准。
  - Knuth-Morris-Pratt string search - Knuth-Morris-Pratt算法被认为是解决模式匹配问题的最佳算法之一。
  - Trie - Trie(在其他一些实现中也称为前缀树或基数树)是一种用于存储关联数据结构的特殊类型的树。
  - Aho-Corasick - **Aho–Corasick算法**是由[Alfred V. Aho](https://zh.wikipedia.org/wiki/阿尔佛雷德·艾侯)和Margaret J.Corasick 发明的字符串搜索算法，用于在输入的一串字符串中匹配有限组“字典”中的子串。
  - Huffman Coding  - 霍夫曼编码使用变长编码表对源符号（如文件中的一个字母）进行编码，其中变长编码表是通过一种评估来源符号出现概率的方法得到的，出现概率高的字母使用较短的编码，反之出现概率低的则使用较长的编码，这便使编码之后的字符串的平均长度、期望值降低，从而达到无损压缩数据的目的。
  - Dijkstra's shortest path - 戴克斯特拉的原始版本仅适用于找到两个顶点之间的最短路径，后来更常见的变体固定了一个顶点作为源结点然后找到该顶点到图中所有其它结点的最短路径，产生一个最短路径树。
  - Bit Set  - 一个固定大小的n位序列。也称为位数组或位向量。
  - Bloom Filter   - Bloom Filter是一种空间高效的数据结构，它告诉您一个元素是否存在于一个集合中。
  - B-Tree - B-Tree是一种自平衡的搜索树，其中的节点可以有两个以上的子节点。

  

- **Design Patterns**

  - 创建型 
    - Singleton   - 单例模式       
    - Factory - 工厂模式            
    - AbstractFactory   - 抽象工厂              
    - Builder - 建造者模式                
    - Prototype - 原型模式
  - 结构型          
    - Proxy - 代理模式          
    - Bridge   - 桥接模式        
    - Decorator - 装饰者模式          
    - Adapte - 适配器模式          
    - Flyweight - 享元模式           
    - Composite - 组合模式
  - 行为型       
    - Observer  -   观察者模式   
    - Template Method - 模板方法模式      
    - Strategy  - 策略模式         
    - ChainResponsibility  - 职责链模式     
    - Iterator - 迭代器模式       
    - State   - 状态模式        
    - Visitor  - 访问者模式         
    - Memento - 备忘录模式          
    - Mediator  - 中介模式         
    - Interpreter - 解释器模式

  

- **Case**

  - Brows Images - 浏览图片示例
  - Call OC function - OC与Swift相互使用
  - List - 列表使用
  - Up down swipe - 视图的上下切换
  - Show RxSwift + MVVM - 使用RX的MVVM架构示例, [MVVM 和 RxSwift实践](http://fd-learning.com/learner/page/course.html?couseid=2001202106130816140000006012#)
  - Chat - 聊天界面
  - Calendar - 日历组件


### 运行环境

iOS 13.0+ 

### 使用

将 SwiftCase 下载下来，需要执行  ```pod install```

### 联系

ForrestWang mail: forrestwang@aliyun.com

### 许可

SwiftCase是在MIT许可下发布的。详细信息请参见LICENSE。

