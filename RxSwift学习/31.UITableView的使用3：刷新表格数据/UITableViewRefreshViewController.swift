//
//  UITableViewRefreshViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/28/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UITableViewRefreshViewController: UIViewController {

    let disposeBag = DisposeBag()
    // 刷新按钮
    var refreshButton: UIBarButtonItem!
    // 停止刷新按钮
    var cancleButton: UIBarButtonItem!
    // 表格
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         三、数据刷新
         1、效果图
         (1)界面初始化完毕后，tableView默认会加载一些随机数据
         (2)点击右上角的刷新按钮，tableView会重新加载并显示一批新数据
         (3)为方便演示，每次获取数据不是真的去发起网络请求，而是在本地生成后延迟2秒返回，模拟这种异步请求的情况
         */
        
        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 随机的表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
        .startWith(()) // 加这个为了让一开始就能自动请求一次数据
        .flatMapLatest(getRandomResult) // 连续请求时只取最后一次数据
        .share(replay:1)
        
        /* 增加停止刷新按钮之后
         let randomResult1 = refreshButton.rx.tap.asObservable()
         .startWith(()) // 加这个为了让一开始就能自动请求一次数据
         .flatMapLatest {
         self.getRandomResult().takeUntil(self.cancleButton.rx.tap)
         }
         .share(replay:1)
         */
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionModel<String,Int>>(configureCell: {
            (dataSource,tv,indexPath,element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "条目\(indexPath.row):\(element)"
            return cell
        })
        
        // 绑定单元格数据
        randomResult
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        
        /*
         3、防止表格多次刷新的说明
         (1)flatMapLastest的作用是当在短时间内(上一个请求还没回来)连续点击多次“刷新”按钮，虽然仍会发起多次请求。但表格只会接收并显示最后一次请求，避免表格出现连续刷新的现象
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)  //连续请求时只取最后一次数据
         .share(replay: 1)
         
         (2) 也可以改用flatMapFirst来防止表格多次刷新，它与flatMapLatest刚好相反，如果连续发起多次请求，表格只会接收并显示第一次请求
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
                 .startWith(()) //加这个为了让一开始就能自动请求一次数据
                 .flatMapFirst(getRandomResult)  //连续请求时只取第一次数据
                 .share(replay: 1)
         
         (3) 我们还可以在源头进行限制下，即通过thruttle设置这个阀值(比如1秒)，如果在1秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求了
         let randomResult = refreshButton.rx.tap.asObservable()
                 .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
                 .startWith(()) //加这个为了让一开始就能自动请求一次数据
                 .flatMapLatest(getRandomResult)
                 .share(replay: 1)
         */
        
        /*
         附：停止数据请求
         在实际项目中我们可能会需要对一个未完成的网络请求进行中断操作。比如切换页面或者分类，如果上一次的请求还未完成就要将其取消掉。
         */
    }
    
    //获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
        }
}
