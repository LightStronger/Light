//
//  WeakSelfViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/31/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WeakSelfViewController: UIViewController {

    var textField: UITextField!
    var label: UILabel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         Swift使用自动引用计数（ARC）来管理应用程序的内存使用，但 ARC 并不是绝对安全的。我之前也写过一篇关于 Swift 内存泄漏原因以及解决办法的文章（点击查看）
         这次我专门讲讲在使用 RxSwift 时，容易出现内存泄漏的地方以及解决方法。
         */
        
        /*
         1，[weak self] 与 [unowned self] 介绍
         我们只需将闭包捕获列表定义为弱引用（weak）、或者无主引用（unowned）即可解决问题，这二者的使用场景分别如下：
         .如果捕获（比如 self）可以被设置为 nil，也就是说它可能在闭包前被销毁，那么就要将捕获定义为 weak。
         .如果它们一直是相互引用，即同时销毁的，那么就可以将捕获定义为 unowned。
         */
        
        // [weak self]样例
        textField.rx.text.orEmpty.asDriver().drive(onNext: {
            [weak self] text in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                print("当前输入内容：\(String(describing: text))")
                self?.label.text = text
            }
            
        }).disposed(by: disposeBag)
        
        // [unowned self]样例
        //  (1）如果我们不用 [weak self] 而改用 [unowned self]，返回主页面　4　秒钟后由于详情页早已被销毁，这时访问 label 将会导致异常抛出。
        // （2）当然如果我们把延时去掉的话，使用 [unowned self] 是完全没有问题的。
        textField.rx.text.orEmpty.asDriver().drive(onNext: {
            [unowned self] text in
            print("当前输入内容：\(String(describing: text))")
            self.label.text = text
        }).disposed(by: disposeBag)
        
    }
    
    deinit {
        print(#file, #function)
    }
}
