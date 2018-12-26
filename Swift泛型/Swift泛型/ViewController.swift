//
//  ViewController.swift
//  Swift泛型
//
//  Created by bdb on 12/20/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var arr: Array<String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(UIDevice.current.batteryLevel)
        
        
        // 泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及h类型。它能让你避免代码的重复，用一种清晰和抽象的方式开表达代码的意图
        // 泛型是 Swift 最强大的特性之一，许多 Swift 标准库是通过泛型代码构建的。事实上，泛型的使用贯穿了整本语言手册，只是你可能没有发现而已。例如，Swift 的 Array 和 Dictionary 都是泛型集合。你可以创建一个 Int 数组，也可创建一个 String 数组，甚至可以是任意其他 Swift 类型的数组。同样的，你也可以创建存储任意指定类型的字典。
        
        

        // 泛型所解决的问题
        // 下面是一个标准的非泛型函数 swapTwoInts(_:_:)，用来交换两个 Int 值：
        
        func swapTwoInts(_ a: inout Int, _ b: inout Int) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
//        var someInt = 3
//        var anotherInt = 107
//        swapTwoInts(&someInt, &anotherInt)
//        print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
        // 打印 “someInt is now 107, and anotherInt is now 3”

        // 诚然，swapTwoInts(_:_:)函数挺有用，但是它只能交换Int值，如果你想要交换两个String值或者Double值，就不得不写更多的函数，例如swapTwoStrings(_:_:)和swapTwoDoubles(_:_:)，如下所示
        func swapTwoStrings(_ a: inout String, _ b: inout String) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
        
        func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
        /*
         你可能注意到 swapTwoInts(_:_:)、swapTwoStrings(_:_:) 和 swapTwoDoubles(_:_:) 的函数功能都是相同的，唯一不同之处就在于传入的变量类型不同，分别是 Int、String 和 Double。
         
         在实际应用中，通常需要一个更实用更灵活的函数来交换两个任意类型的值，幸运的是，泛型代码帮你解决了这种问题。（这些函数的泛型版本已经在下面定义好了。）
         注意 ：在上面三个函数中，a 和 b 类型必须相同。如果 a 和 b 类型不同，那它们俩就不能互换值。Swift 是类型安全的语言，所以它不允许一个 String 类型的变量和一个 Double 类型的变量互换值。试图这样做将导致编译错误。
         */
        
        // 泛型函数
        // 泛型函数可以适用于任何类型，下面的swapTwoValues(_:_:)函数是上面三个函数的泛型版本
        func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
        
        /*
         这个函数的泛型版本使用了占位类型名（在这里用字母 T 来表示）来代替实际类型名（例如 Int、String 或  Double）。占位类型名没有指明 T 必须是什么类型，但是它指明了 a 和 b 必须是同一类型 T，无论 T 代表什么类型。只有 swapTwoValues(_:_:) 函数在调用时，才会根据所传入的实际类型决定 T 所代表的类型。
         
         泛型函数和非泛型函数的另外一个不同之处，在于这个泛型函数名（swapTwoValues(_:_:)）后面跟着占位类型名（T），并用尖括号括起来（<T>）。这个尖括号告诉 Swift 那个 T 是 swapTwoValues(_:_:) 函数定义内的一个占位类型名，因此 Swift 不会去查找名为 T 的实际类型。
         
         swapTwoValues(_:_:) 函数现在可以像 swapTwoInts(_:_:) 那样调用，不同的是它能接受两个任意类型的值，条件是这两个值有着相同的类型。swapTwoValues(_:_:) 函数被调用时，T 所代表的类型都会由传入的值的类型推断出来。
         
         在下面的两个例子中，T 分别代表 Int 和 String：
         */
        var someInt = 3
        var anotherInt = 107
        swapTwoValues(&someInt, &anotherInt)
        
        var someSthing = "hellow"
        var anotherString = "word"
        swapTwoValues(&someSthing, &anotherString)
        
        // 上面定义的 swapTwoValues(_:_:) 函数是受 swap(_:_:) 函数启发而实现的。后者存在于 Swift 标准库，你可以在你的应用程序中使用它。如果你在代码中需要类似 swapTwoValues(_:_:) 函数的功能，你可以使用已存在的 swap(_:_:) 函数。
        
        
        
        var stackofStrings = Stack<String>()
        stackofStrings.push("uno")
        stackofStrings.push("dos")
        stackofStrings.push("tres")
        stackofStrings.push("cuatro")

        //移除并返回栈顶部的值 "cuatro"，即将其出栈：
        let fromTheTop = stackofStrings.pop()
        // fromTheTop 的值为 "cuatro"，现在栈中还有 3 个字符串

        
        // 扩展一个泛型类型
        // 当你扩展一个泛型类型的时候，你并不需要在扩展的定义中提供类型参数列表。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用
        
        if let topItem = stackofStrings.topItem {
            print("The top item on the stack is \(topItem).")
        }
        // 打印 “The top item on the stack is tres.”
        
        // 类型约束
        /*
         swapTwoValues(_:_:) 函数和 Stack 类型可以作用于任何类型。不过，有的时候如果能将使用在泛型函数和泛型类型中的类型添加一个特定的类型约束，将会是非常有用的。类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。
         
         例如，Swift 的 Dictionary 类型对字典的键的类型做了些限制。在字典的描述中，字典的键的类型必须是可哈希（hashable）的。也就是说，必须有一种方法能够唯一地表示它。Dictionary 的键之所以要是可哈希的，是为了便于检查字典是否已经包含某个特定键的值。若没有这个要求，Dictionary 将无法判断是否可以插入或者替换某个指定键的值，也不能查找到已经存储在字典中的指定键的值。
         
         为了实现这个要求，一个类型约束被强制加到 Dictionary 的键类型上，要求其键类型必须符合 Hashable 协议，这是 Swift 标准库中定义的一个特定协议。所有的 Swift 基本类型（例如 String、Int、Double 和 Bool）默认都是可哈希的。
         
         当你创建自定义泛型类型时，你可以定义你自己的类型约束，这些约束将提供更为强大的泛型编程能力。抽象概念，例如可哈希的，描述的是类型在概念上的特征，而不是它们的显式类型。
         */
        
        // 类型约束语法
        // 你可以在一个类型参数名后面放置一个类型或者协议名，并用冒号进行分割，来定义类型约束，它们将成为类型参数列表的一部分。对泛型函数添加类型约束的基本语法如下所示（作用于泛型类型时的语法与之相同）：
//        func someFunction<T: SomeClass, U: SomeProtocol> (someT: T, someU: U) {
//            // 这里是泛型函数的函数体部分
//        }
        // 上面这个函数有两个类型参数。第一个类型参数 T，有一个要求 T 必须是 SomeClass 子类的类型约束；第二个类型参数 U，有一个要求 U 必须符合 SomeProtocol 协议的类型约束。
        
        // 类型约束实践
        // 这里有个名为 findIndex(ofString:in:) 的非泛型函数，该函数的功能是在一个 String 数组中查找给定  String 值的索引。若查找到匹配的字符串，findIndex(ofString:in:) 函数返回该字符串在数组中的索引值，否则返回 nil：
        
        func findIndex(ofString valuetoFind: String, in array: [String]) -> Int? {
            for (index, value) in array.enumerated() {
                if value == valuetoFind {
                    return index
                }
            }
            return nil
        }
        // findIndex(ofString:in:) 函数可以用于查找字符串数组中的某个字符串：
        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
//        if let foundIndex = findIndex(ofString: "llama", in: strings) {
//            print("The index of llama is \(foundIndex)")
//        }
        // 打印 “The index of llama is 2”

        /*
         不过，所有的这些并不会让我们无从下手。Swift 标准库中定义了一个 Equatable 协议，该协议要求任何遵循该协议的类型必须实现等式符（==）及不等符(!=)，从而能对该类型的任意两个值进行比较。所有的 Swift 标准类型自动支持 Equatable 协议。
         
         任何 Equatable 类型都可以安全地使用在 findIndex(of:in:) 函数中，因为其保证支持等式操作符。为了说明这个事实，当你定义一个函数时，你可以定义一个 Equatable 类型约束作为类型参数定义的一部分：
         */
        func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
            for (index, value) in array.enumerated() {
                if value == valueToFind {
                    return index
                }
            }
            return nil
        }
        let doubleIndex = findIndex(of: 9.3, in: [3.14159,0.1,0.25])
        // doubleIndex 类型 Int？，其值为nil，因为9.3不在数组中
        let stringIndex = findIndex(ofString: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
        // stringIndex类型 Int？，其值为2
        
        // 关联类型
        // 定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一本分将会非常有用。关联类型为协议中的某个类型提供了一个占位(或者说别名)，其代表的实际类型在协议被采纳时才会被指定。你可以通过哦associatedtype关键字来指定关联类型
        
        // 泛型where语句
        /*
         为关联类型定义约束也是非常有用的。你可以在参数列表中通过 where 子句为关联类型定义约束。你能通过  where 子句要求一个关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同。你可以通过将 where 关键字紧跟在类型参数列表后面来定义 where 子句，where 子句后跟一个或者多个针对关联类型的约束，以及一个或多个类型参数和关联类型间的相等关系。你可以在函数体或者类型的大括号之前添加 where 子句。
         
         下面的例子定义了一个名为 allItemsMatch 的泛型函数，用来检查两个 Container 实例是否包含相同顺序的相同元素。如果所有的元素能够匹配，那么返回 true，否则返回 false。
         
         被检查的两个 Container 可以不是相同类型的容器（虽然它们可以相同），但它们必须拥有相同类型的元素。这个要求通过一个类型约束以及一个 where 子句来表示：
         */
        func allItemsMatch<C1: Container, C2: Container> (_ someContainer: C1, _ anotherContainer: C2) -> Bool
            where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
                
                // 检查两个容器含有相同数量的元素
                if someContainer.count != anotherContainer.count {
                    return false
                }
                
                // 检查每一对元素是否相等
                for i in 0..<someContainer.count {
                    if someContainer[i] != anotherContainer[i] {
                        return false
                    }
                }
                
                // 所有元素都匹配，返回 true
                return true
        }

        var stackOfStrings = Stack1<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        
        var arrayOfStrings = Stack1<String>()
        arrayOfStrings.push("uno")
        arrayOfStrings.push("dos")
        arrayOfStrings.push("tres")
        
        if allItemsMatch(stackOfStrings, arrayOfStrings) {
            print("All items match")
        } else {
            print("Not all item natch")
        }
        // 打印 “All items match.”

        
        // 具有泛型where字句的扩展
        if stackofStrings.isTop("tres") {
            print("Top element is tres.")
        } else {
            print("Top element is something else")
        }
        // 打印 "Top element is tres."
        
        // 如果尝试在其他元素不符合Equatable协议的栈上调用isTop(_:)方法，则会收到编译时错误
        var notEquatableStack = Stack<NotEquatable>()
        let notEquatableVlaue = NotEquatable()
        notEquatableStack.push(notEquatableVlaue)
//        notEquatableStack.isTop(notEquatableValue)  // 报错

        // 你可以使用泛型where字句去扩展一个协议，基于以前的示例扩展了COntainer协议，添加一个startsWith(_:)方法
        
        // 这个 startsWith(_:) 方法首先确保容器至少有一个元素，然后检查容器中的第一个元素是否与给定的元素相等。任何符合 Container 协议的类型都可以使用这个新的 startsWith(_:) 方法，包括上面使用的栈和数组，只要容器的元素是符合 Equatable 协议的。
        

//        if [9, 9, 9].startsWith(42) {
//            print("Starts with 42.")
//        } else {
//            print("Starts with something else.")
//        }
        // 打印 "Starts with something else."

        // 上述示例中的泛型 where 子句要求 Item 符合协议，但也可以编写一个泛型 where 子句去要求 Item 为特定类型。例如：
//        print([1260.0,1200.0,98.6,37.0].average())
        

        // 泛型下标
        // 下标能够使泛型，他们能够包含泛型where字句，你可以把占位符类型的名称写在subscript后面的尖括号里，在下标代码体开始的标志的花括号之前写下泛型where字句
        
        

        
        

        
        
        
        
        
        


<<<<<<< HEAD
>>>>>>> 6397e6c... RXSwift
=======
>>>>>>> 6397e6c... RXSwift
    }
    

}
//下面展示了如何编写一个非泛型版本的栈，以Int型的栈为例
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 下面是相同代码的泛型版本
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 下面的例子扩展了泛型类型 Stack，为其添加了一个名为 topItem 的只读计算型属性，它将会返回当前栈顶端的元素而不会将其从栈中移除：
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
    
}

// 关联类型实践
// 下面例子定义了一个Container协议，该协议定义了一个关联类型ItemType
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}
/*
 Container 协议定义了三个任何采纳了该协议的类型（即容器）必须提供的功能：
 必须可以通过 append(_:) 方法添加一个新元素到容器里。
 必须可以通过 count 属性获取容器中元素的数量，并返回一个 Int 值。
 必须可以通过索引值类型为 Int 的下标检索到容器中的每一个元素。
 
 这个协议没有指定容器中元素该如何存储，以及元素必须是何种类型。这个协议只指定了三个任何遵从  Container 协议的类型必须提供的功能。遵从协议的类型在满足这三个条件的情况下也可以提供其他额外的功能。
 
 任何遵从 Container 协议的类型必须能够指定其存储的元素的类型，必须保证只有正确类型的元素可以加进容器中，必须明确通过其下标返回的元素的类型。
 
 为了定义这三个条件，Container 协议需要在不知道容器中元素的具体类型的情况下引用这种类型。Container 协议需要指定任何通过 append(_:) 方法添加到容器中的元素和容器中的元素是相同类型，并且通过容器下标返回的元素的类型也是这种类型。
 
 为了达到这个目的，Container 协议声明了一个关联类型 ItemType，写作 associatedtype ItemType。这个协议无法定义 ItemType 是什么类型的别名，这个信息将留给遵从协议的类型来提供。尽管如此，ItemType 别名提供了一种方式来引用 Container 中元素的类型，并将之用于 append(_:) 方法和下标，从而保证任何  Container 的行为都能够正如预期地被执行。
 */
// 下面是先前的非泛型的 IntStack 类型，这一版本采纳并符合了 Container 协议：

struct IntStack1: Container {
    // IntStack的原始实现部分
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // Container协议的实现部分
    typealias ItemType = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// 可以让泛型Stack<Element>:结构体遵从COntainer协议
struct Stack1<Element>: Container {
    // Stacj<Element>的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() ->Element {
        return items.removeLast()
    }
    // Container协议的实现部分
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
// 这一次，占位类型参数 Element 被用作 append(_:) 方法的 item 参数和下标的返回类型。Swift 可以据此推断出 Element 的类型即是 ItemType 的类型。

// 通过扩展一个存在的类型来指定关联类型
/*
 通过扩展添加协议一致性中描述了如何利用扩展让一个已存在的类型符合一个协议，这包括使用了关联类型的协议。
 
 Swift 的 Array 类型已经提供 append(_:) 方法，一个 count 属性，以及一个接受 Int 类型索引值的下标用以检索其元素。这三个功能都符合 Container 协议的要求，也就意味着你只需简单地声明 Array 采纳该协议就可以扩展 Array，使其遵从 Container 协议。你可以通过一个空扩展来实现这点，正如通过扩展采纳协议中的描述：
 */
//extension Array: Container {}


// 约束关联类型
// 可以给协议里的关联类型添加类型注释，让遵守协议的类型必须遵循这个约束条件。例如，下面的代码定义了一个Item必须遵循Equatable的Container类型
protocol Container1 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
// 为了遵守了 Container 协议，Item 类型也必须遵守 Equatable 协议。


// 具有泛型where字句的扩展
// 你也可以使用泛型where字句作为扩展的一部分.基于以前的例子，下面的示例扩展了泛型Stack结构体，添加了一个isTop(_:)方法
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

struct NotEquatable { }


// 你可以使用泛型 where 子句去扩展一个协议。基于以前的示例，下面的示例扩展了 Container 协议，添加一个  startsWith(_:) 方法。
extension Container1 where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
// 上述示例中的泛型 where 子句要求 Item 符合协议，但也可以编写一个泛型 where 子句去要求 Item 为特定类型。例如：

extension Container1 where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}

// 具有泛型where字句的关联类型
// 你可以在关联类型后面加上具有泛型where的字句。例如，建立一个包含迭代器（iterator）的容器，就像是标准库找那个使用的Swquencez协议那样，你应该这么写
protocol Container2 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

protocol ComparableContainer: Container2 where Item: Comparable { }

// 泛型下标
// 下标能够使泛型，他们能够包含泛型where字句，你可以把占位符类型的名称写在subscript后面的尖括号里，在下标代码体开始的标志的花括号之前写下泛型where字句
extension Container2 {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
/*
 这个 Container 协议的扩展添加了一个下标方法，接收一个索引的集合，返回每一个索引所在的值的数组。这个泛型下标的约束如下：
 
 这个 Container 协议的扩展添加了一个下标：下标是一个序列的索引，返回的则是索引所在的项目的值所构成的数组。这个泛型下标的约束如下：
 
 在尖括号中的泛型参数 Indices，必须是符合标准库中的 Sequence 协议的类型。
 下标使用的单一的参数，indices，必须是 Indices 的实例。
 泛型 where 子句要求 Sequence（Indices）的迭代器，其所有的元素都是 Int 类型。这样就能确保在序列（Sequence）中的索引和容器(Container)里面的索引类型是一致的。
 综合一下，这些约束意味着，传入到 indices 下标，是一个整型的序列. (译者：原来的 Container 协议，subscript 必须是 Int 型的，扩展中新的 subscript，允许下标是一个的序列，而非单一的值。)
 */
