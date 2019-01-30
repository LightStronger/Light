//
//  UICollectionRefreshViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UICollectionRefreshViewController: UIViewController {

    // 刷新按钮
    var refreshButton: UIBarButtonItem!
    // 停止刷新按钮
    var cancleButton: UIBarButtonItem!
    // 集合视图
    var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         同之前介绍过的表格一样，在很多情况下，集合视图（collectionView）里的数据不是一开始就准备好的、或者固定不变的。可能我们需要先向服务器请求数据，再将获取到的内容显示在集合视图中。
         要重新加载集合视图数据，过去的做法就是调用 collectionView 的 reloadData() 方法。本文介绍在使用 RxSwift 的情况下，应该如何刷新数据。
         */
        
        /*
         1、效果图
         (1)界面初始化完毕后，collecctionView默认会加载一些随机数据
         (2)点击右上角的刷新按钮，collectionView会重新加载并显示一批新数据
         (3)为方便演示，每次获取数据不是真的去发起网络请求，而是在本地生成后延迟2秒返回，模拟这种异步请求的情况
         */
        
        // 定义布局方式以及单元格大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        // 创建集合视图
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        
        // 创建一个重用的单元格
        self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView!)
        
        // 随机的表格数据
        let randowResult = refreshButton.rx.tap.asObservable()
        .startWith(()) // 加这个为了让一开始就能自动请求一次数据
        .flatMapLatest(getRandomResult)
        .share(replay: 1)
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,Int>>(
        configureCell: { (dataSource,collectionView,indexPath,element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        }
        )
        
        // 绑定单元格数据
        randowResult
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        /*
         3、防止集合视图多次刷新的说明
         (1)flatMapLastest的作用是：挡在短时间内(上一个请求还没回来)连续点击多次“刷新按钮”，虽然让回发起多次请求，但collectionView只会接收并显示最后一次请求，避免集合视图出现连续刷新的现象
         */
        // 随机的表格数据
        let randomResult0 = refreshButton.rx.tap.asObservable()
        .startWith(())
        .flatMapLatest(getRandomResult)// 连续请求时只取最后一次请求
        .share(replay: 1)
        
        /*
         (2)也可以改用 flatMapFirst 来防止表格多次刷新，它与 flatMapLatest 刚好相反，如果连续发起多次请求，表格只会接收并显示第一次请求
         */
        let randomResult1 = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapFirst(getRandomResult)  //连续请求时只取第一次数据
            .share(replay: 1)
        /*
         (3)我们还可以在源头进行限制下。即通过 throttle 设置个阀值（比如 1 秒），如果在 1 秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。
         */
        //随机的表格数据
        let randomResult2 = refreshButton.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest(getRandomResult)
            .share(replay: 1)
        
        /*
         附：停止数据请求
          在实际项目中我们可能会需要对一个未完成的网络请求进行中断操作。比如切换页面或者分类时，如果上一次的请求还未完成就要将其取消掉。下面通过样例演示如何实现该功能。
         这里我们在前面样例的基础上增加了个“停止”按钮。当发起请求且数据还未返回时（2 秒内），按下该按钮后便会停止对结果的接收处理，即 collectionView 不加载显示这次的请求数据
         */
        
        let cancelRandowResult = refreshButton.rx.tap.asObservable()
            .startWith(())
            .flatMapLatest{
                self.getRandomResult().takeUntil(self.cancleButton.rx.tap)
             }
            .share(replay: 1)
        
        
        
    }
    
    // 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String,Int>]> {
        print("正在请求数据.....")
        let items = (0..<5).map{_ in
            Int(arc4random_uniform(100000))
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
