//
//  ViewController.swift
//  RxSwift学习
//
//  Created by bdb on 12/27/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         // PublishSubject
         //创建一个PublishSubject
         let subject = PublishSubject<String>()
         //由于当前没有任何订阅者，所以这条信息不会输出到控制台
         subject.onNext("111")
         //第1次订阅subject
         subject.subscribe(onNext: { string in
         print("第1次订阅：", string)
         }, onCompleted:{
         print("第1次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         //当前有1个订阅，则该信息会输出到控制台
         subject.onNext("222")
         
         //第2次订阅subject
         subject.subscribe(onNext: { string in
         print("第2次订阅：", string)
         }, onCompleted:{
         print("第2次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         //当前有2个订阅，则该信息会输出到控制台
         subject.onNext("333")
         
         //让subject结束
         subject.onCompleted()
         
         //subject完成后会发出.next事件了。
         subject.onNext("444")
         
         //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
         subject.subscribe(onNext: { string in
         print("第3次订阅：", string)
         }, onCompleted:{
         print("第3次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         /* 打印
         第1次订阅： 222
         第1次订阅： 333
         第2次订阅： 333
         第1次订阅：onCompleted
         第2次订阅：onCompleted
         第3次订阅：onCompleted
         */
         */
        
        /*
         // 3，BehaviorSubject
         //创建一个BehaviorSubject
         let subject = BehaviorSubject(value: "111")
         
         //第1次订阅subject
         subject.subscribe { event in
         print("第1次订阅：", event)
         }.disposed(by: disposeBag)
         
         //发送next事件
         subject.onNext("222")
         
         //发送error事件
         subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
         
         //第2次订阅subject
         subject.subscribe { event in
         print("第2次订阅：", event)
         }.disposed(by: disposeBag)
         /* 打印
         第1次订阅： next(111)
         第1次订阅： next(222)
         第1次订阅： error(Error Domain=local Code=0 "(null)")
         第2次订阅： error(Error Domain=local Code=0 "(null)")
         */
         */
        
        //4，ReplaySubject
        //创建一个bufferSize为2的ReplaySubject
        //        let subject = ReplaySubject<String>.create(bufferSize: 2)
        //
        //        //连续发送3个next事件
        //        subject.onNext("111")
        //        subject.onNext("222")
        //        subject.onNext("333")
        //
        //        //第1次订阅subject
        //        subject.subscribe { event in
        //            print("第1次订阅：", event)
        //        }.disposed(by: disposeBag)
        //
        //        //再发送1个next事件
        //        subject.onNext("444")
        //
        //        //第2次订阅subject
        //        subject.subscribe { event in
        //            print("第2次订阅：", event)
        //        }.disposed(by: disposeBag)
        //
        //        //让subject结束
        //        subject.onCompleted()
        //
        //        //第3次订阅subject
        //        subject.subscribe { event in
        //            print("第3次订阅：", event)
        //        }.disposed(by: disposeBag)
        
        /*
         第1次订阅： next(222)
         第1次订阅： next(333)
         第1次订阅： next(444)
         第2次订阅： next(333)
         第2次订阅： next(444)
         第1次订阅： completed
         第2次订阅： completed
         第3次订阅： next(333)
         第3次订阅： next(444)
         第3次订阅： completed
         */
        
        
        // 6，BehaviorRelay
        //创建一个初始值为111的BehaviorRelay
        let subject = BehaviorRelay<String>(value: "111")
        
        //修改value值
        subject.accept("222")
        
        //第1次订阅
        subject.asObservable().subscribe {
            print("第1次订阅：", $0)
            }.disposed(by: disposeBag)
        
        //修改value值
        subject.accept("333")
        
        //第2次订阅
        subject.asObservable().subscribe {
            print("第2次订阅：", $0)
            }.disposed(by: disposeBag)
        
        //修改value值
        subject.accept("444")
        
        /*打印
         第1次订阅： next(222)
         第1次订阅： next(333)
         第2次订阅： next(333)
         第1次订阅： next(444)
         第2次订阅： next(444)
         */
        
    }
}

