//
//  AnyObserverViewController.swift
//  RxSwift学习
//
//  Created by bdb on 12/28/18.
//  Copyright © 2018 fulihao. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit
import Foundation

class AnyObserverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 一.观察者(Observer)介绍
        // 观察者（Observer）的作用就是监听事件，人情案后对这个事件作出响应，或者说任何响应事件的行为都是观察者。比如：
        /*
         当我们点击按钮，弹出一个提示框，那么这个“弹出一个提示框“就是观察者Observer<Void>
         当我们请求一个远程的json数据后，将其打印出来。那么这个”打印json数据“就是观察者Observer<JSON>
         */
        
        
        // 二 直接在subscribe、bind方法中创建观察者
        /*
         1.在subscribe方法中创建
         (1)创建观察者最直接的方法就是在Observable的subscribe方法后面描述当事件发生时，需要如何做出响应
         (2)比如下面的样例，观察者就是由后面的onNext、OnError、onCompleted这些闭包构建出来的
         */
        let observable = Observable.of("A", "B", "C")
        observable.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        })
        // 打印 A B C completed
        
        // 2.bind方法中创建
        // (1)下面代码我们创建一个定时生成索引数的Observable序列，并将索引数不断显示在label标签上
        let disposeBag = DisposeBag()
        let observable1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable1
            .map { "当前索引数：\($0)" }
            .bind { (text) in
                // 收到发出的索引数后显示到label上
                print(text)
        }
            .disposed(by: disposeBag)
        
        // 三 使用AnyObserver创建观察者
        // AnyObserver 可以用来描叙任意一种观察者。
        
        /*
         1.配合subscribe方法使用
         比如上面第一个样例我们可以改成如下代码
         */
        // 观察者
        let observer:AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        let observable2 = Observable.of("A","B","C")
        observable2.subscribe(observer)
        
        // 配合bindTo方法使用
        // 也可配合Observable的数据绑定方法(bindTo)使用。比如上面的第二个样例我可以改成如下代码
        // 观察者
        let disposeBag1 = DisposeBag()
        let observer1: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let text):
                print(text)
            default:
                break
            }
        }
        // Observable序列(每隔1秒钟发出一个索引数)
        let observable3 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable3
        .map { "当前索引数： \($0)"}
        .bind(to: observer1)
        .disposed(by: disposeBag1)
        
        // 四 使用Binder创建观察者
        /*
         1.基本介绍
         (1)相较于AnyObserver的大而全，Binder更专注于特定的场景。Binder主要有以下两个特征：
         不会处理错误事件
         确保绑定s都是在给定Scheduler上执行(默认MainScheduler)
         (2)一旦产生错误事件，在调试环境下将执行fataError，在发布环境下将打印错误信息
         
         2、使用样例
         (1)在上面序列数显示样例中，label标签的文字显示就是一个典型的UI观察者。它在响应事件时，只会处理next事件，而且更新UI的操作需要在主线程上执行，那么这种情况下更好的方案就是使用Binder
         (2)上面的样例我们改用Binder会简单许多
         */
        let label = UILabel()
        
        let disposeBag2 = DisposeBag()
        // 观察者
        let observer2: Binder<String> = Binder(label) { (view,text)  in
            // 收到发出的索引数后显示
            view.text = text
        }
        
        // Observable序列（每隔1秒发出一个索引数）
        let observable4 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable4
            .map { "当前索引数：\($0)"}
            .bind(to: observer2)
            .disposed(by: disposeBag2)
        // 附：Binder在RxCocoa中应用 下面的extension
        // （1）其实RxCocoa在对许多UI控件进行扩展时，就利用Binder将控件属性变成观察者，比如UIControl+Rx.swiftnabled属性便是一个observer
        
        // (2)因此我们可以将序列直接绑定到它上面，比如下面样例，button会在可用、不可用这两种状态间交替变换（每隔一秒）
        // Observable序列(每隔1秒发出一个索引数)
        let button = UIButton()
        
        let observable5 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable5
            .map { $0 % 2 == 0}
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag2)
        
    }
}
//  附：Binder在RxCocoa中应用
extension Reactive where Base: UIControl {
    /// Bindable sink for `enabled` property.
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}
