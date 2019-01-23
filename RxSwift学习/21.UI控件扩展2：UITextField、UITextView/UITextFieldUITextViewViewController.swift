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
    var textView: UITextView!
    
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
        let inputField = UITextField(frame: CGRect(x: 10, y: 130, width: 200, height: 30))
        inputField.borderStyle = .roundedRect
        self.view.addSubview(inputField)
        
        // 创建文本输出框
        let outputField = UITextField(frame: CGRect(x: 10, y: 170, width: 200, height: 30))
        outputField.borderStyle = .roundedRect
        self.view.addSubview(outputField)
        
        // 创建文本标签
        let label = UILabel(frame: CGRect(x: 20, y: 210, width: 300, height: 30))
        label.backgroundColor = UIColor.cyan
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        // 创建按钮
        let button:UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 260, width: 40, height: 30)
        button.setTitle("提交", for: .normal)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        // 当文本框内容改变
        let input = inputField.rx.text.orEmpty.asDriver() // 将普通序列转换为Driver
        // 内容绑定到另一个输入框中
        input.drive(outputField.rx.text)
        .disposed(by: disposeBag)
        
        // 内容绑定到文本标签中
        input.map {"当前字数：\($0.count)"}
        .drive(label.rx.text)
        .disposed(by: disposeBag)
        
        // 根据内容字数决定按钮是否可用
        input.map { $0.count > 5}
        .drive(button.rx.isEnabled)
        .disposed(by: disposeBag)
        
        /*
         3、同时监听多个textField内容的变化(textView同理)
         (1)效果图
         .界面上有两个输入框分别用于填写电话的区号和号码
         .无论哪一个输入框内容发生变化，都会将它们拼成完整的号码并显示在label中
         */
        
    Observable.combineLatest(inputField.rx.text.orEmpty,outputField.rx.text.orEmpty) { textValue1 , textValue2 -> String in
            return "您输入的号码是：\(textValue1) - \(textValue2)"
        }
        .map{ $0 }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        /*
         4、事件监听
         (1)通过rx.controlEvent可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种UI控件d都有touch事件外，输入框还有如下几个独有的事件：
         .editingDidBegin:开始编辑(开始输入内容)
         .editingChanged:输入内容发生改变
         .editingDidEnd:结束编辑
         .editingDidEndOnExit:按下return键结束编辑
         .allEditingEvents:包含前面的所有编辑相关事件
         (2) 下面代码监听输入框开始编辑事件(获取到焦点)并做相应的相应
         */
        
        textField.rx.controlEvent([.editingDidBegin]) // 状态可以组合
            .asObservable()
            .subscribe(onNext: { _ in
                print("开始编辑b内容")
            }).disposed(by: disposeBag)
        
        /*
         (3)下面代码我们在界面上添加两个输入框用于输入用户名和密码
         .如果当前焦点在用户名输入框时，按下return键时焦点自动转移到密码输入框上
         .如果当前焦点在密码输入框时，按下return键时自动移除焦点
         */
        
        // 在用户名输入框中按下 return 键
    textField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: { (_) in
            outputField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        // 在密码输入框中按下return键
    outputField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: { (_) in
            inputField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        
        /*
         附：UITextView独有的方法
         (1) UITextView 还封装了如下几个委托回调方法：
         .didBeginEding:开始编辑
         .didEndEditing:结束编辑
         .didChange:编辑内容发生改变
         .didChangeSelection:选中部分发生变化
         */
        
        // 开始编辑响应
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
                })
            .disposed(by: disposeBag)

        // 结束编辑响应
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
        .disposed(by: disposeBag)
        
        // 内容发生变化响应
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            })
        .disposed(by: disposeBag)
        
        // 选中部分变化响应
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            })
        .disposed(by: disposeBag)
    }
}
