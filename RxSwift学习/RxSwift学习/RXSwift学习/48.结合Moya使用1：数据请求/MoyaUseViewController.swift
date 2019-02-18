//
//  MoyaUseViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/16/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoyaUseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         Moya是一个基于Alamofire的更高网络请求封装抽象层。它可以对我们项目中的素有请求进行集中管理，方便开发与维护。同时Moya自身也提供了对RxSwift的扩展，通过与RxSwift的结合，能让Moya变得更加强大。下面我就通过样例演示如何使用“RxSwift + Moya”这个组合进行开发
         */
        
        // 我们在视图控制器中通过上面的定义的 provider 即可发起请求，获取数据。具体代码如下：
        // 获取数据 方式一
        DouBanProvider.rx.request(.channels)
            .subscribe { (event) in
                switch event {
                case let .success(response):
                    // 数据处理
                        let str = String(data: response.data, encoding: String.Encoding.utf8)
                    print("返回的数据是：",str ?? "")
                case let .error(error):
                    print("数据请求失败！错误原因：",error)
                }
        }.disposed(by: disposeBag)
        
        // 获取数据 方式二
        DouBanProvider.rx.request(.channels)
            .subscribe(onSuccess: { (response) in
                // 数据处理
                let str = String(data: response.data, encoding: String.Encoding.utf8)
                print("返回的数据是：",str ?? "")
            }, onError: { error in
                print("数据请求失败！错误原因",error)
            }).disposed(by: disposeBag)
    }
}
