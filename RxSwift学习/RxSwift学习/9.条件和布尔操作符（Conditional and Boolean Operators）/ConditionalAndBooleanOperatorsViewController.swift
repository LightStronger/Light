//
//  ConditionalAndBooleanOperatorsViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/5/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConditionalAndBooleanOperatorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposeBag = DisposeBag()
        
        /*
         1、amb
         (1) 基本介绍
         .当传入多个Observables到amb操作符时，它将取第一个取出元素或产生事件的Observable，然后只发出它的元素。并忽略掉其他的Observables
         (2) 使用样例
         */
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        subject1
        .amb(subject2)
        .amb(subject3)
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        
        /* 打印
         1
         2
         3
         */
        
        /*
         2、takeWhile
         (1) 基本介绍
         .该方法依次判断Observable序列的每一个值是否满足给定的条件。当第一个不满足条件额值出现时，它便自动完成
         (2) 使用样例
         */
        Observable.of(2,3,4,5,6)
            .takeWhile { $0 < 4 }
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        /* 打印
         2
         3
         */
        
        /*
         3、takeUntil
         (1) 基本介绍
         .除了订阅源Observable外，通过takeUntil方法我们还可以监视另外一个Observable，即notifier。
         .如果notfier发出值或complete通知，那么源Observable便自动完成，停止发送事件
         */
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        source
        .takeUntil(notifier)
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        // 停止接收消息
        notifier.onNext("z")
        
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
        
        /* 打印
         a
         b
         c
         d
         */
        
        /*
         4、skipWhile
         (1) 基本介绍
         .该方法用于跳过前面所有满足条件的事件
         .一旦遇到不满足条件的事件，之后就不会再跳过了
         */
        Observable.of(2,3,4,5,6)
            .skipWhile{ $0 < 4}
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        /*打印
         4
         5
         6
         */
        
        /*
         5、skipUntil
         (1) 基本介绍
         .同上面takeUntil一样，skipUntil除了订阅源Observable外，通过skipUntil方法我们还可以监视另外一个Observable，即notifier
         .与takeUntil相反的是。源Observable序列事件默许会一直跳过，知道notifier发出值或complete通知
         */
        let source1 = PublishSubject<Int>()
        let notifier1 = PublishSubject<Int>()
        
        source
        .skipUntil(notifier1)
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        source1.onNext(1)
        source1.onNext(2)
        source1.onNext(3)
        source1.onNext(4)
        source1.onNext(5)
        
        // 开始接收消息
        notifier1.onNext(0)
        
        source1.onNext(6)
        source1.onNext(7)
        source1.onNext(8)
        
        // 仍然接收消息
        notifier1.onNext(0)
        
        source1.onNext(9)
        
        /*打印
         6
         7
         8
         9
         */
        
        
        
        

    }
}
