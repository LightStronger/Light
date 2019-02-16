//
//  SubjectsViewController.swift
//  RxSwift学习
//
//  Created by bdb on 12/31/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
// https://www.hangge.com/blog/cache/detail_1929.html
class SubjectsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         从前面的几篇文章可以发现，当我们创建一个 Observable 的时候就要预先将要发出的数据都准备好，等到有人订阅它时再将数据通过 Event 发出去。
         但有时我们希望 Observable 在运行时能动态地“获得”或者说“产生”出一个新的数据，再通过 Event 发送出去。比如：订阅一个输入框的输入内容，当用户每输入一个字后，这个输入框关联的 Observable 就会发出一个带有输入内容的 Event，通知给所有订阅者。
         这个就可以使用下面将要介绍的 Subjects 来实现。
         */
        // 1.Subjects基本介绍
        /*
         (1) Subjects既是订阅者，也是Observable：
         .说它是订阅者模式因为它能够动态地接收新的值
         .说它又是一个Observable，是因为当Subjects有了新的值之后，就会通过Event将新值发出给他的所有订阅者
         (2) 一共有四种Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Varible.他们之间既有各自的特点，也有相同之处：
         .首先他们都是Observable，他们的订阅者都能收到他们发出的新的Event
         .知道Subject发出.complete或者.error的Event后，该Subject便终结了，同时它也就不会再发出.next事件。
         .对于那些在Subject终结后再订阅他的订阅者，也能收到subject发出的一条.complete或.error的event，告诉这个新的订阅者它已经终结了
         .他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到Subject以前发出过的旧Event，如果能的话又能收到多少个
         (3) Subject常用的几个方法
         .onNext(:)是on(.next(:))的简便写法，该方法相当于subject接收到一个.next
         .onError(:):是on(.error(:))的简便写法。该方法相当于subject接收到一个.error事件
         .onCompleted():是on(.completed)的简便写法。该方法相当于subject接收到一个.completed事件
         */
        
        // 2.PublishSubject
        /*
         (1)基本介绍
         .PublishSubject是最普通的Subject，它不需要初始值就能创建
         .PublishSubject的订阅者从他们开始订阅的时间点起，可以收到订阅后Subject发出的新Event，而不会收到他们在订阅前已发出的Event
         (2) 时序图
         https://www.hangge.com/blog/cache/detail_1929.html
         .最上面一条是 PublishSubject。
         .下面两条分别表示两个新的订阅，它们订阅的时间点不同，可以发现 PublishSubject 的订阅者只能收到他们订阅后的 Event。

         */
        
        // (3) 使用样例
        let disposeBag = DisposeBag()
        // 创建一个PublishSubject
        let subject = PublishSubject<String>()
        // 由于当前没有任何订阅者，所以这条信息不会输出到控制台
        subject.onNext("1111")
        
        // 第一次订阅subject
        subject.subscribe(onNext: { (string) in
            print("第1次订阅：",string)
        }, onCompleted: {
            print("第1次订阅：onCompleted")
        }).disposed(by: disposeBag)

        // 当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        // 第2次订阅subject
        subject.subscribe(onNext: { (string) in
            print("第2次订阅：",string)
        }, onCompleted: {
            print("第2次订阅：completed")
        }).disposed(by: disposeBag)
        
        // 当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
        // 让subject结束
        subject.onCompleted()
        
        // subject完成之后会发出.next事件了
        subject.onNext("444")
        
        // subject完成后它的所有订阅(包括结束后的订阅)，都能收到subject的.completed事件
        subject.subscribe(onNext: { (string) in
            print("第3次订阅：",string)
        }, onCompleted: {
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        /* 打印
         第1次订阅：222
         第1次订阅：333
         第2次订阅：333
         第1次订阅：onCompleted
         第2次订阅：onCompleted
         第3次订阅：onCompleted
         */

        // 3.BehaviorSubject
        /*
         (1) 基本介绍
         .BehaviorSubject需要通过一个默认初始值来创建
         .当一个订阅者订阅它的时候，这个订阅者会立即收到BehaviorSubject上一个发出event。之后就跟正常的情况一样，它会接收到BehaviorSubject之后发出新的event
         (2) 时序图 https://www.hangge.com/blog/cache/detail_1929.html
         .最上面一条是 BehaviorSubject。
         .下面两条分别表示两个新的订阅，它们订阅的时间点不同，可以发现 BehaviorSubject 的订阅者一开始就能收到 BehaviorSubjects 之前发出的一个 Event。
         (3)使用样例
         */
        // 创建一个BehaviorSubject
        let subject1 = BehaviorSubject(value: "111")
        
        // 第1次订阅subject
        subject1.subscribe(onNext: { (event) in
            print("第1次订阅：",event)
        }).disposed(by: disposeBag)
        
        // 发送next事件
        subject1.onNext("222")
        
        // 发送error事件
        subject1.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        // 第2次订阅subject
        subject1.subscribe { (event) in
            print("第2次订阅：",event)
        }.disposed(by: disposeBag)
        
        /* 打印
         第1次订阅：next(111)
         第1次订阅：next(222)
         第1次订阅：error(Error Domain=local Code=0 "null")
         第2次订阅：error(Error Domain=local Code=0 "null")
         */
        
        /*
         4.RepalySubject
         (1)基本介绍
         .ReplaySubject在创建时候需要设置一个bufferSize，表示它对于它发送过的event的缓存个数
         .比如一个ReplaySubject的buffer订阅了这个ReplaySubject，那么它会将后两个(最近的两个)event给缓存起来。此时如果有一个subscriber订阅了这个ReplaySubject，那么这个subscriber就会立即收到前面缓存的两个.next的event
         .如果一个subscriber订阅已经结束的ReplaySubjectject，除了会收到缓存的.next的event外，还会收到那个终结的.error或者.completed的event
         (2) 时序图
         https://www.hangge.com/blog/cache/detail_1929.html
         .最上面一条是 ReplaySubject（bufferSize 设为为 2）。
         .下面两条分别表示两个新的订阅，它们订阅的时间点不同。可以发现 ReplaySubject 的订阅者一开始就能收到 ReplaySubject 之前发出的两个 Event（如果有的话）。
         (3) 使用样例
         */
        
        // 创建一个bufferSize为2的ReplaySubject
        let subject3 = ReplaySubject<String>.create(bufferSize: 2)
        
        // 连续发送3个next事件
        subject3.onNext("111")
        subject3.onNext("222")
        subject3.onNext("333")
        
        // 第1次订阅subject
        subject3.subscribe { (event) in
            print("第1次订阅：",event)
        }.disposed(by: disposeBag)
        
        // 再发送1个next事件
        subject3.onNext("444")
        
        // 第2次订阅subject
        subject3.subscribe { (event) in
            print("第2次订阅：",event)
        }.disposed(by: disposeBag)
        
        // 让subject结束
        subject3.onCompleted()
        
        // 第3次订阅subject
        subject3.subscribe { (event) in
            print("第3次订阅：",event)
        }.disposed(by: disposeBag)
        
        /* 打印
         第1次订阅：next(222)
         第1次订阅：next(333)
         第1次订阅：next(444)
         第2次订阅：next(333)
         第2次订阅：next(444)
         第1次订阅：completed
         第2次订阅：completed
         第3次订阅：next(333)
         第3次订阅：next(444)
         第3次订阅：completed
         */
        
        /*
         5.Variable
         （注意：由于 Variable 在之后版本中将被废弃，建议使用 Varible 的地方都改用下面介绍的 BehaviorRelay 作为替代。）
         .Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
                 //创建一个初始值为111的Variable
                         let variable = Variable("111")
                           
                         //修改value值
                         variable.value = "222"
                           
                         //第1次订阅
                         variable.asObservable().subscribe {
                                 print("第1次订阅：", $0)
                         }.disposed(by: disposeBag)
                           
                         //修改value值
                         variable.value = "333"
                           
                         //第2次订阅
                         variable.asObservable().subscribe {
                                 print("第2次订阅：", $0)
                         }.disposed(by: disposeBag)
                           
                         //修改value值
                         variable.value = "444"
        
         */
        
        /*
         6.BehaviorReplay
         (1)基本介绍
         .BehaviorRelay 是作为 Variable 的替代者出现的。它的本质其实也是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
         .BehaviorRelay 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
         .与 BehaviorSubject 不同的是，不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它（BehaviorRelay 会在销毁时也不会自动发送 .complete 的 event）。
         .BehaviorRelay 有一个 value 属性，我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改。
         （2）上面的 Variable 样例我们可以改用成 BehaviorRelay，代码如下：
         */
        
        // 创建一个初始值为111的BehaviorReplay
        let subject5 = BehaviorRelay<String>(value: "111")
        
        // 修改value
        subject5.accept("222")
        
        // 第1次订阅
        subject5.asObservable().subscribe {
            print("第1次订阅：",$0)
        }.disposed(by: disposeBag)
        
        // 修改value值
        subject5.accept("333")
        
        // 第2次订阅
        subject5.asObservable().subscribe {
            print("第2次订阅：",$0)
        }.disposed(by: disposeBag)
        
        // d修改value值
        subject5.accept("444")
        
        /*
         打印
         第1次订阅：next(222)
         第1次订阅：next(333)
         第2次订阅：next(333)
         第1次订阅：next(444)
         第2次订阅：next(444)
         */
        
        // (3) 如果想将新值合并到原值上，可以通过accept()方法与value属性配合来实现。(这个常用在表格上拉加载功能上，BehaviorReplay用来保存所有加载到的数据)
        
        // 创建一个初始值为包含一个元素的数组的BehaviorReplay
        let subject6 = BehaviorRelay<[String]>(value: ["1"])
        
        // 修改value值
        subject6.accept(subject6.value + ["2","3"])
        
        // 第一次订阅
        subject6.asObservable().subscribe {
            print("第1次订阅：",$0)
        }.disposed(by: disposeBag)
        
        // 修改value值
        subject6.accept(subject6.value + ["4", "5"])
        
        // 第2次订阅
        subject6.asObservable().subscribe {
            print("第2次订阅：",$0)
        }.disposed(by: disposeBag)
        
        /*
         打印
         第1次订阅：next(["1","2","3"])
         第1次订阅：next(["1","2","3","4","5"])
         第2次订阅：next(["1","2","3","4","5"])
         第1次订阅：next(["1","2","3","4","5","6","7"])
         第1次订阅：next(["1","2","3","4","5","6","7"])
         */
        
    }
}
