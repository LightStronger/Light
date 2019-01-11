//
//  UITextFieldUITextViewViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/11/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UITextFieldUITextViewViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        /*
         二、UITextfield与UItextView
         1、监听单个textfield内容的变化(textView同理)
         (1)下面样例中我们将textField里输入的内容实时地显示到控制台中
         
         */
        
        // 创建文本输入框
        let textField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        textField.borderStyle = .roundedRect
        self.view.addSubview(textField)

        // 当文本框内容改变时，将内容输出到控制台上
        textField.rx.text.orEmpty.asObservable()
        .subscribe(onNext: {
                print("您输入的是：\($0)")
            })
        .disposed(by: disposeBag)
        
        // (3) 当然我们直接使用change事件也是一样的
        // 当文本框内容改变时，将内容输出到控制台上
//        textField.rx.text.orEmpty.changed
//        .subscribe(onNext: {
//                print("您输入的是：\($0)")
//            })
//        .disposed(by: disposeBag)
        
        /*
         2、将内容绑定到其他控件上
         .我们将第一个textField里输入的内容实时地显示到第二个textField中
         .同时label中还会实时显示当前的字数
         .最下方的”提交“按钮会根据当前的字数决定是否可用(字数超过5个字才可用)
         */
        
        // 创建文本输入框
        let inputField = UITextField(frame: CGRect(x: 10, y: 50, width: 200, height: 30))
        inputField.borderStyle = .roundedRect
        self.view.addSubview(inputField)
        
        // 创建文本输出框
        let outputField = UITextField(frame: CGRect(x: 10, y: 90, width: 200, height: 30))
        outputField.borderStyle = .roundedRect
        self.view.addSubview(outputField)
        
        // 创建文本标签
        let label = UILabel(frame: CGRect(x: 20, y: 150, width: 40, height: 30))
        label.backgroundColor = UIColor.cyan
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        // 创建按钮
        let button:UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 190, width: 40, height: 30)
        button.setTitle("提交", for: .normal)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        
        
        
        
        
        
    }
}
