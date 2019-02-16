//
//  ControlPropertyViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/10/19.
//  Copyright © 2019 fulihao. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class ControlPropertyViewController: UIViewController {
    var textField: UITextField!
    var label: UILabel!
    var button:UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // 五、ControlProperty
        /*
         1、基本介绍
         (1)ComtrolProperty是专门用来描述UI控件属性，拥有该类型的属性都是被观察者(Observable)
         (2)ControlProperty具有以下特征：
         .不会产生error事件
         .一定在MainScheduler订阅(主线程订阅)
         .一定在MainScheduler监听(主线程监听)
         .共享状态变化
         */
        
        /*
         2、使用样例
         （1）其实在 RxCocoa 下许多 UI 控件属性都是被观察者（可观察序列）。比如我们查看源码（UITextField+Rx.swift），可以发现 UITextField 的 rx.text 属性类型便是 ControlProperty<String?>：
         extension Reactive where Base: UITextField {
         public var text: ControlProperty<String?> {
         return value
         }
         public var value: ControlProperty<String?> {
         return base.rx.controlPropertyWithDefaultEvents(
         getter: { textField in
         textField.text
         },
         setter: { textField, value in
         if textField.text != value {
         textField.text = value
         }
         })
         }
         //......
         }
         */
        
        textField = UITextField()
        textField.frame = CGRect(x: 50, y: 100, width: 100, height: 40)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 6
        textField.backgroundColor = UIColor.lightGray
        self.view.addSubview(textField)
        
        label = UILabel()
        label.frame = CGRect(x: 50, y: 150, width: 100, height: 40)
        label.backgroundColor = UIColor.lightGray
        self.view.addSubview(label)
        
        textField.rx.text
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        /*
         六、ControlEvent
         1、基本介绍
         (1)ControlEvent是专门用于描述UI所产生的事件，拥有该类型的属性都是被观察者(Observable)
         (2)Controller和ControlProperty一样，都具有以下特征
         .不会产生error事件
         .一定在MainScheduler订阅(主线程订阅)
         .一定在MainScheduler监听(主线程监听)
         .共享状态变化
         
         2、使用样例
         (1)同样地，在RxCocoa下许多UI控件的事件方法都是被观察者(可观察序列)。比如我们查看源码(UIButton+Rx.swift),可以发现UIButton的rx.tap方法类型便是ControlEvent<Void>
         extension Reactive where Base: UIButton {
                 public var tap: ControlEvent<Void> {
                         return controlEvent(.touchUpInside)
                 }
         }
         (2)那么我们如果想实现一个button被点击时，在控制台输出一段文字。即前者作为被观察者，后者作为观察者，可以这么写
         */
        button = UIButton()
        button.frame = CGRect(x: 200, y: 100, width: 100, height: 40)
        button.setTitle("请点击", for: .normal)
        button.backgroundColor = UIColor.cyan
        self.view.addSubview(button)
        
        // 订阅按钮点击事件
        button.rx.tap
           .subscribe(onNext: {
               print("欢迎访问hangge.com")
            }).disposed(by: disposeBag)
    }
    
    /*
     附：给 UIViewController 添加 RxSwift 扩展
     1、UIViewController+Rx.swift
     这里我们对UIViewController进行扩展
     .将viewDidLoad、viewDidAppear、viewDidLayoutSubviews等各种ViewController生命周期的方法转成COntrolEvent方便在RxSwift项目中使用
     .增加isVisible序列属性，方便对视图的显示状态进行订阅
     .增加isDismissing序列属性，方便对视图的释放进行订阅
     public extension Reactive where Base: UIViewController {
                     public var viewDidLoad: ControlEvent<Void> {
                                     let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
                                     return ControlEvent(events: source)
                     }
                         
                     public var viewWillAppear: ControlEvent<Bool> {
                                     let source = self.methodInvoked(#selector(Base.viewWillAppear))
                                                     .map { $0.first as? Bool ?? false }
                                     return ControlEvent(events: source)
                     }
                     public var viewDidAppear: ControlEvent<Bool> {
                                     let source = self.methodInvoked(#selector(Base.viewDidAppear))
                                                     .map { $0.first as? Bool ?? false }
                                     return ControlEvent(events: source)
                     }
                         
                     public var viewWillDisappear: ControlEvent<Bool> {
                                     let source = self.methodInvoked(#selector(Base.viewWillDisappear))
                                                     .map { $0.first as? Bool ?? false }
                                     return ControlEvent(events: source)
                     }
                     public var viewDidDisappear: ControlEvent<Bool> {
                                     let source = self.methodInvoked(#selector(Base.viewDidDisappear))
                                                     .map { $0.first as? Bool ?? false }
                                     return ControlEvent(events: source)
                     }
                         
                     public var viewWillLayoutSubviews: ControlEvent<Void> {
                                     let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews))
                                                     .map { _ in }
                                     return ControlEvent(events: source)
                     }
                     public var viewDidLayoutSubviews: ControlEvent<Void> {
                                     let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews))
                                                     .map { _ in }
                                     return ControlEvent(events: source)
                     }
                         
                     public var willMoveToParentViewController: ControlEvent<UIViewController?> {
                                     let source = self.methodInvoked(#selector(Base.willMove))
                                                     .map { $0.first as? UIViewController }
                                     return ControlEvent(events: source)
                     }
                     public var didMoveToParentViewController: ControlEvent<UIViewController?> {
                                     let source = self.methodInvoked(#selector(Base.didMove))
                                                     .map { $0.first as? UIViewController }
                                     return ControlEvent(events: source)
                     }
                         
                     public var didReceiveMemoryWarning: ControlEvent<Void> {
                                     let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning))
                                                     .map { _ in }
                                     return ControlEvent(events: source)
                     }
                         
                     //表示视图是否显示的可观察序列，当VC显示状态改变时会触发
                     public var isVisible: Observable<Bool> {
                                     let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
                                     let viewWillDisappearObservable = self.base.rx.viewWillDisappear
                                                     .map { _ in false }
                                     return Observable<Bool>.merge(viewDidAppearObservable,
                                                                                                                                                             viewWillDisappearObservable)
                     }
                         
                     //表示页面被释放的可观察序列，当VC被dismiss时会触发
                     public var isDismissing: ControlEvent<Bool> {
                                     let source = self.sentMessage(#selector(Base.dismiss))
                                                     .map { $0.first as? Bool ?? false }
                                     return ControlEvent(events: source)
                     }
     }
     */

    /*
     2、使用样例
     (1)通过扩展，我们可以直接对VC的各种方法进行订阅
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 页面显示状态完毕
        self.rx.isVisible
            .subscribe(onNext: { visible in
               print("当前页面显示状态：\(visible)")
            }).disposed(by: disposeBag)

        // 页面加载完毕
        self.rx.viewDidLoad
            .subscribe(onNext: {
                print("viewDidLoad")
            }).disposed(by: disposeBag)
        
        // 页面将要显示
        self.rx.viewWillAppear
            .subscribe(onNext: { animated in
                print("viewWillAppear")
            }).disposed(by: disposeBag)
        
        // 页面显示完毕
        self.rx.viewDidAppear
            .subscribe(onNext: { aniamted in
                print("viewDidAppear")
            }).disposed(by: disposeBag)
        /*
         viewDidLoad
         viewWillAppear
         当前页面显示状态：true
         viewDidAppear
         */
    }
}

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
public extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning))
            .map { _ in }
        return ControlEvent(events: source)
    }
    
    //表示视图是否显示的可观察序列，当VC显示状态改变时会触发
    public var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear
            .map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable,
                                      viewWillDisappearObservable)
    }
    
    //表示页面被释放的可观察序列，当VC被dismiss时会触发
    public var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
