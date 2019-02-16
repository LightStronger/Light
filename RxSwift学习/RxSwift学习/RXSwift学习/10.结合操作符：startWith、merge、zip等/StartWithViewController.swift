//
//  StartWithViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/5/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StartWithViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposeBag = DisposeBag()
        
        // 十一、结合操作（Combining Observables）
        // 结合操作(或者称合并操作)指的是将多个Observable序列进行组合，拼装成一个新的Observable序列
        /*
         1、startWith
         (1) 基本介绍
         .该方法会在Observable序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息
         */
        Observable.of("2","3")
        .startWith("1")
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        
        /*打印
         1
         2
         3
         */
        
        // (3) 当然插入多个数据也是可以的
        Observable.of("2","3")
            .startWith("a")
            .startWith("b")
            .startWith("c")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        /* 打印
         c
         b
         a
         2
         3
         */
        
        /*2、merge
         (1)基本介绍
         .该方法可以将多个(两个或两个以上的)Observable序列合并成一个Observable序列
         */
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
        
        /*打印
         20
         40
         60
         1
         80
         100
         1
         */
        
        /*
         3、zip
         .该方法可以将多个(两个或两个以上的)Observable序列压缩成一个Observable序列
         .而且它会等到每个Observable事件一一对应地凑齐之后再合并
         */
        let subject3 = PublishSubject<Int>()
        let subject4 = PublishSubject<String>()

        Observable.zip(subject3,subject4) {
            "\($0)\($1)"
        }
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        
        subject3.onNext(1)
        subject4.onNext("A")
        subject3.onNext(2)
        subject4.onNext("B")
        subject4.onNext("C")
        subject4.onNext("D")
        subject3.onNext(3)
        subject3.onNext(4)
        subject3.onNext(5)

        /*打印
         1A
         2B
         3C
         4D
         */
        
        // 附：zip常常用在整合网络请求上
        // 比如我们想同时发送两个请求，只有当两个请求都成功后，再将两者的结果整合起来继续往下处理，这个功能就可以通过zip来实现
        //第一个请求
//        let userRequest: Observable<User> = API.getUser("me")
//
//        //第二个请求
//        let friendsRequest: Observable<Friends> = API.getFriends("me")
//        // 将两个请求合并处理
//        Observable.zip(userRequest,friendsRequest) {
//            user,friends in
//            // 将两个信号合并一个信号，并压缩成一个元组返回(两个信号均成功)
//        }
//        .observeOn(MainScheduler.instance) //加这个是应为请求在后台线程，下面的绑定在前台线程。
//        .subscribe(onNext: { (user, friends) in
//                //将数据绑定到界面上
//                //.......
//         })
//         .disposed(by: disposeBag)
        
        /*
         4.combineLatest
         .该方法同样是将多个（两个或两个以上的）Observable序列元素进行合并
         .但与zip不同的是，每当任意一个Observable有新的事件发出时，它会将每个Observable序列的最新的一个事件元素进行合并
         */
        let subject5 = PublishSubject<Int>()
        let subject6 = PublishSubject<String>()
        
        Observable.combineLatest(subject5, subject6) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject5.onNext(1)
        subject6.onNext("A")
        subject5.onNext(2)
        subject6.onNext("B")
        subject6.onNext("C")
        subject6.onNext("D")
        subject5.onNext(3)
        subject5.onNext(4)
        subject5.onNext(5)
        /*打印
         1A
         2A
         2B
         2C
         2D
         3D
         4D
         5D
         */
        
        /*
         5、withLatestFrom
         .该方法将两个Observable序列合并为一个。每当self队列发射一个元素时，便从第二个序列中取出最新的一个值
         */
        
        let subject7 = PublishSubject<String>()
        let subject8 = PublishSubject<String>()
        
        subject7.withLatestFrom(subject8)
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
        
        subject7.onNext("A")
        subject8.onNext("1")
        subject7.onNext("B")
        subject7.onNext("C")
        subject8.onNext("2")
        subject7.onNext("D")
        /*打印
         1
         1
         2
         */
        
        /*
         6、switchLatest
         .switchLatest有点像其他语言的switch方法，可以对事件流进行交换
         .比如本来监听的subject1，我可以通过更改variable里面的value更换事件源，变成监听subject2
         */
        let subject9 = BehaviorSubject(value: "A")
        let subject10 = BehaviorSubject(value: "1")
        let behaviorReplay = BehaviorRelay(value: subject9)
        behaviorReplay.asObservable()
        .switchLatest()
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        subject9.onNext("B")
        subject9.onNext("C")
        
        // 改变事件源
        behaviorReplay.accept(subject10)
        subject9.onNext("D")
        subject10.onNext("2")
        
        // 改变事件源
        behaviorReplay.accept(subject9)
        subject10.onNext("3")
        subject9.onNext("E")
        /*打印
         A
         B
         C
         1
         2
         D
         E
         */
    }
}
