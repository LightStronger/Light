//
//  OrderObservableViewController.swift
//  RxSwift学习
//
//  Created by bdb on 12/28/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderObservableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 三、Pbservable介绍
        /*
         Obserable<T>这个类就是Rx框架的基础，我们可以称它为可观察序列。它的作用就是可以异步地产生一系列的Event(事件)，即一个Observable<T>对象会随着时间推移不定期发出event(element:T)这样一个东西。
         而且这些Event还可以携带数据，它的泛型<T>就是用来指定这个Event携带的数据的类型
         有了可观察序列，我们还需要有一个Obserable(订阅者)来订阅它，这样这个订阅者才能收到Observable<T>不时发出Event
         */
        
        // Event
        // 查看 RxSwift 源码可以发现，事件 Event 的定义如下：
//        public enum Event<Element> {
//            /// Next element is produced.
//            case next(Element)
//            /// Sequence terminated with an error.
//            case error(Swift.Error)
//            /// Sequence completed successfully.
//            case completed
//        }
        
        // Event就是一个枚举，也就是说一个Observable是可以发出3中不同乐行的Event事件
        /*
         .next:  next事件就是那个可以携带数据<T>的事件，可以说它就是一个”最正常“的事件
         .error: error事件表示一个错误，它可以携带具体的错误内容，一旦Observable发出了error event，则这个Observable就等于终止了，以后它再也不会发出event事件了
         .completed: completed事件表示Obserable发出的事件正常地结束了，跟error一样，一旦Obserable发出了completed event，则这个Obserable就等于终止了，以后它再也不会发出event时间了
         */
        
        // 3.Obserable与Sequence比较
        /*
         (1)为更好地理解，我们可以把每一个Observable的实例想象成与一个Swift中的Sequence
            .即一个Observable（ObservableType）相当于一个序列Sequence(SequenceType)
            .ObservableType.subscribe(_:)方法其实相当于Sequence.generate()
         (2)但它们之间还是有许多区别的
            .Swift中的SequenceType时同步的循环，而Observable是异步的
            .Observable对象会在有任何Event时候，自动将Eevent作为一个参数通过ObservableType.subscribe(_:)发出，并不需要使用next方法
         */
        
        // 四 创建Observable序列
        // 我们可以通过如下几种方法来创建一个 Observable 序列
        
        //1.just()方法
        /*
         (1)该方法通过传入一个默认值来初始化
         (2)下面样例我们显式地标注出了 observable 的类型为 Observable<Int>，即指定了这个 Observable 所发出的事件携带的数据类型必须是 Int 类型的。
         */
        let observable = Observable<Int>.just(5)
        
        // 2.of()方法
        /*
         (1)该方法可以接受可变数量的参数（必需要是同类型的）
         (2)下面样例中我没有显式地生命出Observable的泛型类型，swift也会自动推断类型
         */
        let observable1 = Observable.of("A","B","C")
        
        // 3.from()方法
        /*
         (1)该方法需要一个数组参数
         (2)下面样例中数据里的元素就会被当做Observable所发出event携带的数据内容，最终效果同上面of()样例是一样的
         */
        let observable2 = Observable.from(["A","B","C"])
        
        // 4.empty()方法
        // 该方法创建了一个空m内容的Observable序列
        let observable3 = Observable<Int>.empty()
        
        // 5.never()方法
        // 该方法创建一个永远不会发生Event（也不会终止）的Observable序列
        let observable4 = Observable<Int>.never()
        
        // 6.error()方法
        // 该方法创建一个不做任何操作，而是直接发送一个z错误的Observable序列
        enum MyError: Error {
            case A
            case B
        }
        let observable5 = Observable<Int>.error(MyError.A)
        
        // 7.range()方法
        /*
         (1)该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列
         (2)下面样例中，两种方法创建的Observable序列都是一样的
         */
        
        // 使用range()
        let observable6 = Observable.range(start: 1, count: 5)
        // 使用of()
        let observalbel7 = Observable.of(1,2,3,4,5)
        
        // 8.repeatElement()方法
        // 该方法创建一个可以无限发出给定元素Event的Observable序列（永不终止）
        let observable8 = Observable.repeatElement(1)
        
        // 9.generate()方法
        /*
         (1)该方法创建一个只有当提供的所有的判断条件都为true的时候，才会给出动作的Observable序列
         (2)下面样例中，两种方法创建Observable序列都是一样的
         */
        
        // 使用generate()方法
        let observable9 = Observable.generate(initialState: 0, condition: { ($0 <= 0)
        }, iterate: { $0 + 2 })
        
        // 使用of()方法
        let observable09 = Observable.of(0,2,4,6,8,10)
        
        // 10.create()方法
        /*
         (1)该方法接受一个block形式的参数，任务是对每一个过来的订阅进行处理
         (2)下面是一个简单的样例，为方便演示，这里增加了订阅相关代码(关于订阅我之后会详细介绍的)
         */
        
        // 这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        // 当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        let observable10 = Observable<String>.create { observer in
            // 对订阅者发出了.next事件，且携带了一个数据”hangge.com“
            observer.onNext("hangge.com")
            // 对订阅者发出了.completed事件
            observer.onCompleted()
            // 因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要return一个Disposable
            return Disposables.create()
        }
        // 订阅测试
        observable10.subscribe {
            print($0)
        }
        
        // 打印 next(hange.com) completed
        
        // 11.deferred()方法
        /*
         (1)该个方法相当于是创建一个Observable工厂，通过传入一个block来执行延迟Observable序列创建的行为，而这个block里就是真正的实例化序列对象的地方
         (2)下面是一隔简单的演示样例
         */
        
        // 11 deferred()方法
        /*
         (1)该个方法相当于是创建l一个Observable工厂，通过传入一个block来执行延迟Observable序列创建的行为，而这个block里就是真正的实例化序列对象的地方
         (2)下面是一个简单的演示样例
         */
        // 用于标记是奇数、还是偶数
        var isOdd = true
        
        // 使用deferred()方法延迟Observable序列化，通过传入的block来实现Observable序列的初始化并且返回
        let factory: Observable<Int> = Observable.deferred {
            
            // 让每次执行这个block时候都会让奇、偶数进行交替
            isOdd = !isOdd
            
            // 根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
            if isOdd {
                return Observable.of(1,3,5,7)
            } else {
                return Observable.of(2,4,6,8)
            }
        }
        
        // 第一次订阅测试
        factory.subscribe { event in
            print("\(isOdd)",event)
        }
        
        // 第二次订阅测试
        factory.subscribe { event in
            print("\(isOdd)",event)
        }
        
        // 打印 false next(2) false next(4) false next(6) false next(8) false completed
        // 打印 false next(1) false next(3) false next(5) false next(7) false completed
        
        // 12.interval()方法
        /*
         (1)这个方法创建的Observable序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去
         (2)下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。

         */
        
        
        
        
        
        
        
        
        
        
        
        


    }
}
