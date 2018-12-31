//
//  SelfObservableViewController.swift
//  RxSwift学习
//
//  Created by bdb on 12/31/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SelfObservableViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 五 自定义可绑定属性
        // 有时候我们想让UI控件创建出来后默认就有一些观察者，而不毕每次都为它们单独去创建观察者。比如我们想要t让所有的UILabel都有隔fontSize可绑定属性，它会根据事件值自动改变标签的字体大小
        
        // 方式一：通过对UI类进行扩展
        // (1)这里我们通过对UILabel进行扩展，增加了一个fontSize可绑定属性
        let label = UILabel()
        // Observable序列(每隔0.5秒钟发出一个索引数)
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable
            .map { CGFloat($0)}
            .bind(to:label.fontSize) // 根据索引数不断变放字体
            .disposed(by: disposeBag)
        
        // 方式二：通过对Reactive类进行扩展
        // Observable序列(每隔0.5秒发出一个索引数)
        let observable1 = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable1
            .map { CGFloat($0)}
            .bind(to: label.rx.fontSize) //根据索引数不断变放大字体
            .disposed(by: disposeBag)
        
        // 六。RxSwift自带的可绑定属性（UI观察者）
        // (1)其实RxSwift已经为我们提供许多常用的可绑定属性，比如UILabel就有text和attributedText这两个可绑定属性
        // Observable序列(每隔0.5秒发出一个索引数)
        let observable2 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable2
            .map { "当前索引数：\($0)"}
            .bind(to: label.rx.text) //收到发出的索引数后显示到label上
            .disposed(by: disposeBag)
        

    }
}
// (1)这里我们通过对UILabel进行扩展，增加了一个fontSize可绑定属性
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

// 方式二：通过对Reactive类进行扩展
extension Reactive where Base:UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

// 六
// (1)其实RxSwift已经为我们提供许多常用的可绑定属性，比如UILabel就有text和attributedText这两个可绑定属性
extension Reactive where Base:UILabel {
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }

    public var attributeText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
}
