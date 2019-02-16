//
//  UIActivityIndicatorViewAndUIApplicationViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/25/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIActivityIndicatorViewAndUIApplicationViewController: UIViewController {

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.cyan
        // 五、UIActivityIndicatorView与UIApplication
        /*
         1、UIActivityIndicatorView(活动指示器)
         UIActivityIndicatorView又叫状态指示器，它会通过一个旋转的“菊花”来表示当前的活动状态
         （1）效果图
         .通过开关我们可以控制活动指示器是否显示旋转。
         
         */
        
        let mySwitch = UISwitch()
        mySwitch.frame = CGRect(x: 100, y: 100, width: 60, height: 40)
        self.view.addSubview(mySwitch)
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 100, y: 180, width: 30, height: 30)
        self.view.addSubview(activityIndicator)
        
//        mySwitch.rx.value
//        .bind(to: activityIndicator.rx.isAnimating)
//        .disposed(by: disposeBag)
        
        /*
         2、UIApplication
         RxSwift对UIApplication增加了一个名为isNetworkActivityIndicatorVisible绑定属性，我们通过它可以设置是否显示联网指示器（网络请求指示器）
         当开关打开时，顶部状态栏上会有个菊花状的联网指示器。
         当开关关闭时，联网指示器消失。
         */
        mySwitch.rx.value
        .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
        .disposed(by: disposeBag)
        

    }
}
