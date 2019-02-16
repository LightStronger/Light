//
//  ToArrayViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/7/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToArrayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let disposeBag = DisposeBag()
        // 十二、算数、以及聚合操作(Mathematical and Aggregate Opreators)
        /*
         1、toArray
         .该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束
         */
        Observable.of(1,2,3)
        .toArray()
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        /* 打印
         [1,2,3]
         */
        
        /*
         2、reduce
         .reduce接收一个初始值，和一个操作符号
         .reduce将给定的初始值，与序列的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去
         */
        Observable.of(1,2,3,4,5)
        .reduce(0, accumulator: +)
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        /*打印
         15
         */
        
        /*
         3、concat
         .concat会把多个Observable序列合并(串联)为一个Observable序列
         .并且只有当前面一个Observable序列发出了conpleted事件，才会开始发送下一个Observable序列事件
         */
        let subject = BehaviorSubject(value: 1)
        let subject1 = BehaviorSubject(value: 2)
        
        
        
        let behaviorReplay = BehaviorRelay(value: subject)
        behaviorReplay.asObservable()
        .concat()
        .subscribe(onNext: {print ($0)})
        .disposed(by: disposeBag)
        
        subject1.onNext(2)
        subject.onNext(1)
        subject.onNext(1)

        subject.onCompleted()
        behaviorReplay.accept(subject1)
        
        subject1.onNext(2)
        /*打印
         1
         1
         1
         2
         2
         */
        
        
        
        
    }
}
