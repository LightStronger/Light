//
//  BufferViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/1/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class BufferViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        

        // 八、 变换操作(Transforming Observables)
        // 变换操作指的是对原始的Observable序列进行一些转换，类似于Swift中CollectionType的各种转换
        
        /*
         1.buffer
         (1) 基本介绍
         .buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程
         .该方法简单来说就是缓存Observable中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送过来
         (2) 使用样例
         */
        let subject = PublishSubject<String>()
        
        // 每缓存3个元素则组合起来一起发出
        // 如果1秒钟m内不够3个也会发出(有几个发几个，一个都没有发空数组[])
        subject
            .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        /*
         运行结果如下：
         ["a", "b", "c"]
         ["1", "2", "3"]
         */
        
        /*
         2.window
         (1) 基本介绍
         .window操作符和buffer十分相似。不过buffer是周期性的将缓存的元素集合发送出来，而window周期性的将元素集合以Objectvable的形态发送出来
         .同时buffer要等到元素搜集完毕后，才会发出元素序列，而window可以实时发出元素序列
         (2)使用样例
         */
//        let subject1 = PublishSubject<String>()
//        subject1
//        .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
//        .subscribe(onNext: { [weak self] in
//            print("subscribe: \($0)")
//            $0.asObservable()
//                .subscribe(onNext: { print($0)})
//                .disposed(by: self!.disposeBag)
//        })
//        .disposed(by: disposeBag)
//
//        subject1.onNext("a")
//        subject1.onNext("b")
//        subject1.onNext("c")
//
//        subject1.onNext("1")
//        subject1.onNext("2")
//        subject1.onNext("3")

        /*
         subscribe:RxSwift.AddRef<Swift.Strinh>
         a
         b
         c
         subscribe:RxSwift.AddRef<Swift.Strinh>
         1
         2
         3
         subscribe:RxSwift.AddRef<Swift.Strinh>
         subscribe:RxSwift.AddRef<Swift.Strinh>
         subscribe:RxSwift.AddRef<Swift.Strinh>
         subscribe:RxSwift.AddRef<Swift.Strinh>
         subscribe:RxSwift.AddRef<Swift.Strinh>
         */

        /*
         3.map
         (1)基本介绍
         .该操作符通过传入一个函数闭包把原来的Observable序列转变为一个新的Observable序列
         https://www.hangge.com/blog/cache/detail_1932.html
         (2)使用样例
         */
        Observable.of(1, 2, 3)
            .map { $0 * 10}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        /* 打印
         10
         20
         30
         */

        /*
         4.flatMap
         (1) 基本介绍
         .map在做旋转的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列
         .而flatMap操作符会对源Observable的每一个元素应用一个转换方法，将他们转换成Observables。然后将这些Observables的元素合并之后再发送出来，即又将“拍扁(降维)“成一个Observable序列
         .这个操作符是非常有用的。比如当Observable的元素本生拥有其他的Observable时，我们可以将所有子Observables元素发送出来
         */
        let subject2 = BehaviorSubject(value: "A")
        let subject3 = BehaviorSubject(value: "1")

        let behaviorReplay = BehaviorRelay(value: subject2)
        behaviorReplay.asObservable()
            .flatMap{ $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject2.onNext("B")
        behaviorReplay.accept(subject3)
        subject3.onNext("2")
        subject2.onNext("C")

        /*
         A
         B
         1
         2
         C
         */

        /*
         5.flatMapLatest
         (1) 基本介绍
         .flatMapLast与flatMap的唯一区别是：flatMapLastest只会接收最新的value事件
         (2)这里我们将上例中的flatMap改为flatMapLatest
         */
        let subject4 = BehaviorSubject(value: "A")
        let subject5 = BehaviorSubject(value: "1")

        let behaviorReplay1 = BehaviorRelay(value: subject4)
        behaviorReplay1.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject4.onNext("B")
        behaviorReplay1.accept(subject5)
        subject5.onNext("2")
        subject4.onNext("C")
        /*
         A
         B
         1
         2
         */

        /*
         6.flatMapFirst
         (1) 基本介绍
         .flatMapFirst与flatMapLatest正好相反：flatMapFirst只会接收最初的value事件
         该操作符可以防止重复请求：
         比如点击一个按钮发送一个请求，当该请求完成前，该按钮点击都不应该继续发送请求。便可该使用 flatMapFirst 操作符。
         （2）这里我们将上例中的 flatMapLatest 改为 flatMapFirst。
         */
        let subject6 = BehaviorSubject(value: "A")
        let subject7 = BehaviorSubject(value: "1")
        let behaviorReplay2 = BehaviorRelay(value: subject6)
        behaviorReplay2.asObservable()
            .flatMapFirst { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        subject6.onNext("B")
        behaviorReplay2.accept(subject7)
        subject7.onNext("2")
        subject6.onNext("C")
        /*
         A
         B
         C
         */

        /*
         7.concatMap
         (1) 基本介绍
         .concatMap与flatMap的唯一区别是：当前一个Observable元素发送完毕后，后一个Observable才可以开始发出元素。或者说等待前一个Observable产生完成事件后，才对后一个Observable进行订阅
         (2) 这里我们将样例3中的flatMap改为concatMap
         */
        let subject8 = BehaviorSubject(value: "A")
        let subject9 = BehaviorSubject(value: "1")
        let behaviorReplay3 = BehaviorRelay(value: subject8)

        behaviorReplay3.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)

        subject8.onNext("B")
        behaviorReplay3.accept(subject9)
        subject9.onNext("2")
        subject8.onNext("C")
        subject8.onCompleted() // 只有前一个序列结束后，才能接收下一个序列
        /*
         A
         B
         C
         2
         */

        /*
         8.scan
         (1) 基本介绍
         .scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
         (2) 使用样例
         */
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
             }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        /*
         1
         3
         6
         10
         15
         */

        /*
         9.groupBy
         (1) 基本介绍
         .groupBy操作符将源Observable分解为多个Observable，然后将这些子Observable发送出来
         .也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以Observable的形态发送出来
         (2) 使用样例
         */

        //将奇数偶数分成两组
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
                })
            .subscribe { (event) in
                switch event {
                    case .next(let group):
                        group.asObservable().subscribe({ (event) in
                             print("key：\(group.key)    event：\(event)")
                            })
                            .disposed(by: self.disposeBag)
                default:
                            print("")
                    }
                }
            .disposed(by: disposeBag)        /*
         key: 偶数       event: next(0)
         key: 奇数       event: next(1)
         key: 偶数       event: next(2)
         key: 奇数       event: next(3)
         key: 偶数       event: next(4)
         key: 奇数       event: next(5)
         key: 偶数       event: completed
         key: 奇数       event: completed
         */
        
    }
}
