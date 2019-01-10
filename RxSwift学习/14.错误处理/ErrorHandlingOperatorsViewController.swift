//
//  ErrorHandlingOperatorsViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/9/19.
//  Copyright © 2019 fulihao. All rights reserved.
//
enum MyError: Error {
    case A
    case B
}

import UIKit
import RxSwift
import RxCocoa

class ErrorHandlingOperatorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposeBag = DisposeBag()
        
        // 十五、错误处理操作(Error Handling Operators)
        // 错误处理操作符可以用来帮助我们队Observable发出的error事件做出回应，或者从错误中恢复
        
        /*
         1、catchErrorJustReturn
         .当遇到error事件的时候，就返回指定的值，然后结束
         */
        let sequenceThatFails = PublishSubject<String>()
        sequenceThatFails
        .catchErrorJustReturn("错误")
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("d")
        /*打印
         a
         b
         c
         错误
         */
        
        /*
         2、catchError
         .该方法可以捕获error，并对其进行处理
         .同时还能返回另一个Observable序列进行订阅(切换到新的序列)
         */
        let sequenceThatFails1 = PublishSubject<String>()
        let recoverySequence = Observable.of("1","2","3")
        sequenceThatFails1
            .catchError {
                print("Error:",$0)
                return recoverySequence
            }
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
        
        sequenceThatFails1.onNext("a")
        sequenceThatFails1.onNext("b")
        sequenceThatFails1.onNext("c")
        sequenceThatFails1.onError(MyError.A)
        sequenceThatFails1.onNext("d")
        /*打印
         a
         b
         c
         Error: A
         1
         2
         3
         */
        
        /*
         3、retry
         .使用该方法遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接
         .retry()方法可以传入数字表示重试次数。不传的话只会重试一次
         */
        var count = 1
        let sequenceThatErrors = Observable<String>.create { (observer)  in
            observer.onNext("a")
            observer.onNext("b")
            
            // 如果第一个订阅时发生错误
            if count == 1 {
                observer.onError(MyError
                .A)
                print("Error encountered")
                count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        sequenceThatErrors
        .retry(2) // 重试2次(参数为空则只重试1次)
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        /*打印
         a
         b
         Error encountered
         a
         b
         c
         d
         */
    }
}
