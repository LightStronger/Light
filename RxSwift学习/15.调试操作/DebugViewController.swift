//
//  DebugViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/9/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let disposeBag = DisposeBag()

        // 十六、调试操作
        /*
         1、debug
         .我们可以将debug调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发测试
         */
        Observable.of("2","3")
        .startWith("1")
        .debug()
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        /*打印
         2019-01-09 14:07:46.382: DebugViewController.swift:26 (viewDidLoad()) -> subscribed
         2019-01-09 14:07:46.386: DebugViewController.swift:26 (viewDidLoad()) -> Event next(1)
         1
         2019-01-09 14:07:46.389: DebugViewController.swift:26 (viewDidLoad()) -> Event next(2)
         2
         2019-01-09 14:07:46.389: DebugViewController.swift:26 (viewDidLoad()) -> Event next(3)
         3
         2019-01-09 14:07:46.389: DebugViewController.swift:26 (viewDidLoad()) -> Event completed
         2019-01-09 14:07:46.390: DebugViewController.swift:26 (viewDidLoad()) -> isDisposed
         */
        
        /*
         debug()方法还可以传入参数，这样放项目中存在多个debug时可以很方便地区分出来
         */
        Observable.of("2","3")
        .startWith("1")
        .debug("调试1")
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        /* 打印
         2019-01-09 14:11:28.534: 调试1 -> subscribed
         2019-01-09 14:11:28.534: 调试1 -> Event next(1)
         1
         2019-01-09 14:11:28.535: 调试1 -> Event next(2)
         2
         2019-01-09 14:11:28.535: 调试1 -> Event next(3)
         3
         2019-01-09 14:11:28.535: 调试1 -> Event completed
         2019-01-09 14:11:28.535: 调试1 -> isDisposed
         */
        
        /*
         2、RxSwift.Resources.total
         .通过将RxSwift.Resources.total打印出来，我们可以查看当前RxSwift申请的所有资源数量。这个在检查内存泄漏的时候非常有用
         */
        
//        print(RxSwift.Resources.total)
//
//        let disposeBag = DisposeBag()
//
//        print(RxSwift.Resources.total)

        Observable.of("BBB", "CCC")
            .startWith("AAA")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
//        print(RxSwift.Resources.total)
        /*打印
         0
         2
         AAA
         BBB
         CCC
         3
         */
    }
}
