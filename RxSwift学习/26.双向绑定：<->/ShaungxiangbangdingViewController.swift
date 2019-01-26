//
//  ShaungxiangbangdingViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/25/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 1）首先定义一个 VM
struct UserViewModel {
    // 用户名
    let username = BehaviorRelay(value: "guest")
    
    // 用户信息
    lazy var userinfo = {
       return self.username.asObservable()
        .map { $0 == "hangge" ? "您是管理员" : "您是普通访客"}
        .share(replay: 1)
    }()
}

class ShaungxiangbangdingViewController: UIViewController,UITextFieldDelegate {

    let disposeBag = DisposeBag()
    var userVM = UserViewModel()
    let textField1 = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // 一、简单的双向绑定
        /*
         (1)页面上方是一个文本输入框，用于填写用户名。它与VM里的username属性做双向绑定
         (2)下方的文本标签会根据用户名显示对应的用户信息。(只有hangge显示管理员，其他都是访客)
         */
        
        /*
         （1）首先定义一个 VM
         */
        
        let textField = UITextField()
        textField.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        self.view.addSubview(textField)
        
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 150, width: 100, height: 40)
        label.backgroundColor = UIColor.cyan
        self.view.addSubview(label)
        
        //将用户名与textField做双向绑定
//        userVM.username.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
//        textField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
//
//        //将用户信息绑定到label上
//        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)

        
        /*
         二、自定义双向绑定操作符(operator)
         1、RxSwift自带的双向绑定操作符
         （1）如果经常进行双向绑定的话，最好还是自定义一个 operator 方便使用。
         （2）好在 RxSwift 项目文件夹中已经有个现成的（Operators.swift），我们将它复制到我们项目中即可使用。当然如我们想自己写一些其它的双向绑定 operator 也可以参考它。
         图片 “自定义双向绑定操作符（operator）”
         2，使用样例
         双向绑定操作符是：<->。我们修改上面样例，可以发现代码精简了许多。
         */
        
        // 将用户名与textfield做双向绑定
//        _ = self.textField1.rx.textInput <->  self.userVM.username
        _ = self.textField1.rx.textInput <-> self.userVM.username
        // 将用户信息绑定到label上
        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }
}
