//
//  ConnectViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/7/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConnectViewController: UIViewController {
    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // 十三、链接操作(Connectable Observable Operators)
        /*
         1、可连接的序列（Connectable Observable）
         (1)可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送时间消息，只有当调用connect()之后才会开始发送消息
         (2)可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息
         */
        /*
         普通序列
         */
        // 每隔一秒钟发出1个事件
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        // 第一个订阅者(立刻开始订阅)
//        _ = interval
//            .subscribe(onNext: { print("订阅1：\($0)")})
//        // 第二个订阅者(延迟5秒开始订阅)
//        delay(5) {
//            _ = interval
//                .subscribe(onNext: { print("订阅2：\($0)")})
//        }
        /*打印
         订阅1：0
         订阅1：1
         订阅1：2
         订阅1：3
         订阅1：4
         订阅1：5
         订阅2：0
         订阅1：6
         订阅2：1
         订阅1：7
         订阅2：2
         订阅1：8
         订阅2：3
         订阅1：9
         订阅2：4
         订阅1：10
         订阅2：5
         */
        
        /*
         2、publish
         .publish方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用connect之后才会开会
         */
        // 每隔1秒钟发送1个事件
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
//
//        // 第一个订阅者(立刻开始订阅)
//        _ = interval
//            .subscribe(onNext: { print("订阅： \($0)")})
//
//        // 相当于把事件消息推迟了两秒
//        delay(2) {
//            _ = interval.connect()
//        }
//
//        // 相当于订阅者(延迟5秒开始订阅)
//        delay(5) {
//            _ = interval
//                .subscribe(onNext: { print("订阅2: \($0)")})
//        }
        
        /*打印
         订阅： 0
         订阅： 1
         订阅： 2
         订阅2: 2
         订阅： 3
         订阅2: 3
         订阅： 4
         订阅2: 4
         订阅： 5
         订阅2: 5
         订阅： 6
         订阅2: 6
         订阅： 7
         订阅2: 7
         订阅： 8
         订阅2: 8
         */
        
        /*
         3、replay
         .replay同上面的publish方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用connect之后才会开始
         .replay与publish不同在于：新的订阅者还能接收到订阅之前的事件消息(数量由设置的bufferSize决定)
         */
        
        // 每隔1秒钟发送1个事件
//        let interval1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(5)
//
//        // 第一个订阅者(立刻开始订阅)
//        _ = interval1
//            .subscribe(onNext: { print("订阅1：\($0)") })
//
//        // 相当于把事件消息推迟了两秒
//        delay(2) {
//            _ = interval1.connect()
//        }
//        //第二个订阅者（延迟5秒开始订阅）
//        delay(5) {
//            _ = interval1
//              .subscribe(onNext: { print("订阅2: \($0)") })
//        }
        /*打印
         订阅1：0
         订阅1：1
         订阅2: 0
         订阅2: 1
         订阅1：2
         订阅2: 2
         订阅1：3
         订阅2: 3
         订阅1：4
         订阅2: 4
         订阅1：5
         订阅2: 5
         订阅1：6
         订阅2: 6
         订阅1：7
         订阅2: 7
         订阅1：8
         订阅2: 8
         */
        
        /*
         4、multicast
         .multicast方法同样是将一个正常的序列转换成一个可连接的序列
         .同时multicast方法还可以传入一个Subject，每当序列发送事件时都会触发这个Subject的发送
         */
        // 创建一个Subject(后面multicast()方法传入)
//        let subject = PublishSubject<Int>()
//
//        // 这个Subject的订阅
//        _ = subject
//            .subscribe(onNext: { print("Subject: \($0)")})
//
//        // 每隔1秒钟发送1个事件
//        let interval2 = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(subject)
//
//        // 第一个订阅者(立刻开始订阅)
//        _ = interval2.subscribe(onNext: {print("订阅1：\(($0))")})
//
//        // 相当于把事件消息推迟了两秒
//        delay(2) {
//            _ = interval2.connect()
//        }
//        // 第二个订阅者(延迟5秒开始订阅)
//        delay(5) {
//            _ = interval2.subscribe(onNext: {print("订阅2：\($0)")})
//        }
        /*打印
         Subject: 0
         订阅1：0
         Subject: 1
         订阅1：1
         Subject: 2
         订阅1：2
         订阅2：2
         Subject: 3
         订阅1：3
         订阅2：3
         Subject: 4
         订阅1：4
         订阅2：4
         Subject: 5
         订阅1：5
         订阅2：5
         Subject: 6
         订阅1：6
         订阅2：6
         */
        
        /*
         5、refCount
         .refCount操作符可以将可被连接的Observable转换为普通的Observable
         .即该操作符可以自动连接和断开可连接的Observable。当第一个观察者对可连接的Observable订阅时，那么底层的Observable将被自动连接。当最后一个观察者离开时，那么底层的Observable将被自动断开连接
         */
        
        // 每隔1秒钟发送1个事件
//        let interval3 = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish().refCount()
//
//        // 第一个订阅者(立刻开始订阅)
//        _ = interval3.subscribe(onNext: {print("订阅1：\($0)")})
//
//        // 第二个订阅者(延迟5秒开始订阅)
//        delay(5) {
//            _ = interval3.subscribe(onNext: {print("订阅2：\($0)")})
//        }
        /*打印
         订阅1：0
         订阅1：1
         订阅1：2
         订阅1：3
         订阅1：4
         订阅1：5
         订阅2：5
         订阅1：6
         订阅2：6
         订阅1：7
         订阅2：7
         订阅1：8
         订阅2：8
         订阅1：9
         订阅2：9
         订阅1：10
         订阅2：10
         */
        
        /*
         6、share(relay:)
         .该操作符使得观察者共享源Observable，并且缓存最新的n个元素，将这些元素直接发送给新的观察者
         .简单来说shareReplay就是replay和refCount的组合
         */
        
        // 每隔1秒钟发送1个事件
        let interval4 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .share(replay: 5)
        
        // 第一个订阅者(立刻开始订阅)
        _ = interval4.subscribe(onNext: {print("订阅1：\($0)")})
        
        // 第二个订阅者(延迟5秒开始订阅)
        delay(5) {
            _ = interval4.subscribe(onNext: {print("订阅2：\($0)")})
        }
        /*打印
         订阅1：0
         订阅1：1
         订阅1：2
         订阅1：3
         订阅1：4
         订阅2：0
         订阅2：1
         订阅2：2
         订阅2：3
         订阅2：4
         订阅1：5
         订阅2：5
         订阅1：6
         订阅2：6
         订阅1：7
         订阅2：7
         订阅1：8
         订阅2：8
         订阅1：9
         订阅2：9
         */
        
    }
}
