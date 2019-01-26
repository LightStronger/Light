//
//  UIGestureRecognizerViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/26/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UIGestureRecognizerViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        /*
         七、UIGestureRecognizer
         当手指在界面上向上滑动时，弹出提示框，并显示出滑动起点的坐标。
         */
        
        // 添加一个上滑手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        // 手势响应
//        swipe.rx.event
//            .subscribe(onNext: { [weak self] recognizer in
//                // 这个点事滑动的起点
//                let point = recognizer.location(in: recognizer.view)
//                self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
//            })
//            .disposed(by: disposeBag)
        
        // 第二种响应回调的方法
        swipe.rx.event
            .bind { [weak self] recognizer in
                // 这个点事滑动的起点
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
                   }
        .disposed(by: disposeBag)
        
        
        
        // 附：实现点击页面任意位置，输入框便失去焦点
        
        // 添加一个手势
        let tapBackGround = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackGround)
        
        // 页面上任意处点击，输入框便失去焦点
        tapBackGround.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
        .disposed(by: disposeBag)
        
    }
    // 显示消息提示框
    func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
