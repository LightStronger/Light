//
//  ObservableViewController.swift
//  RXSwift
//
//  Created by bdb on 12/27/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class ObservableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 五、订阅 Observable
        // 有了Observable 我们还要使用subscribe()方法来订阅它，接收它发出的Event
        // 第一种用法
        // (1)我们使用subscribe()订阅了一个Observable对象，该方法的block的回调参数就是被发出的event事件，我们将其直接打印出来
        let observable = Observable.of("A", "B", "C")
        
        observable.subscribe { event in
            print(event)
        }
        // 打印 next(A) next(B) next(C) completed
        
        /*
         初始化 Observable 序列时设置的默认值都按顺序通过 .next 事件发送出来。
         当 Observable 序列的初始数据都发送完毕，它还会自动发一个 .completed 事件出来。
         */
        
        // (2)如果想要获取到这个事件里的数据，可以通过event.element得到
        let obs = Observable.of("A","B","C")
        obs.subscribe { event in
            print(event.element!)
        }
        // 打印 Optional("A") Optional("B") Optional("C") nil
        
        // 第二种做法
        // (1) RxSwift还提供了另一个subscribe方法，它可以把event进行分类
        // 通过不同的block回调处理不同o类型的event。（其中onDisposed表示订阅行为被dispose后的回调，这个后面会说）
        // 同时会把event携带的数据直接解包作为参数，方便我们使用
        let obse = Observable.of("A","B","C")
        observable.subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })

        // 打印 A B C completed disposed
        
        // (2)subscribe()方法的onNext、onError、OnCompleted和onDisposed这四个回调block、参数都是有默认值的，即它们都是可选的，所以我们也可以只处理onNext而不管其他的情况
        let obser = Observable.of("A","B","C")
        obser.subscribe(onNext: { element in
            print(element)
        })        // 打印 A B C
        
        // 六 监听事件的生命周期
        //1. doOn介绍
        /*
         (1)我们可以使用doOn方法来监听事件的生命周期，它会在每一次事件发送前被调用
         (2)w同时它和subscribe一样，可以通过不同的block回调处理不同类型的event。比如：
         do(onNext)方法就是在subscribe(onNext)前调用
         而do(onCompleted":)方法则会在subscribe(onCompleted:)前面调用
         */
        
        // 2.使用样例
        let observ = Observable.of("A","B","C")
        observ
          .do(onNext: { element in
              print("Intercepted Next：", element)
          }, onError: { error in
              print("Intercepted Error：", error)
          }, onCompleted: {
              print("Intercepted Completed")
          }, onDispose: {
             print("Intercepted Disposed")
          })
          .subscribe(onNext: { element in
             print(element)
          }, onError: { error in
             print(error)
          }, onCompleted: {
             print("completed")
          }, onDisposed: {
             print("disposed")
          })
        // 七 Observable 的销毁(Dispose)
        // 1.Observable 从创建到终结流程
        /*
         (1)一个Observable序列被创建出来后它不会马上就开始被激活从而发出Event，而是要等到它被某个人订阅了才会激活它
         (2)而Observable序列激活之后要一直等到它发出了.error或者.completed的event后，它才会被终结
         */
        
        //2.dispose()方法
        /*
         (1)使用该方法我们可以手动取消一个订阅行为
         (2)如果我们觉得这个订阅结束了不再需要了，就可以调用dispose()方法把这个订阅给销毁掉，防止内存泄漏
         (3)当一个订阅行为被dispose了，那么之后observable如果再发出event，这个已经dispose的订阅就收不到消息了。下面是简单的使用样例
         */
        let observa = Observable.of("A","B","C")
        // 使用subscription常量存储这个订阅方法
        let subscription = observa.subscribe { event in
            print(event)
        }
        // 调用这个订阅的dispose()方法
        subscription.dispose()
        
        // 3.DisposeBag
        /*
         (1)除了dispose()方法之外，我们更经常用到的是一个叫DisposeBag的对象来管理多个订阅行为的销毁
             .我们可以把一个DisposeBag对象看成一个垃圾袋，把用过的订阅行为f都放进去
             .而这个DisposeBag就会在自己快要dealloc的时候，对它里面的所有订阅行为都调用dispose()方法
         */
        
        let disposeBag = DisposeBag()
        // 第一个Observable，及其订阅
        let observable1 = Observable.of("A","B","C")
        observable1.subscribe { event in
            print(event)
            }.disposed(by:disposeBag)
        
        // 第二个Observable，及其订阅
        let observable2 = Observable.of(1,2,3)
        observable2.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
        
        
        
        
        
        
    }
}
