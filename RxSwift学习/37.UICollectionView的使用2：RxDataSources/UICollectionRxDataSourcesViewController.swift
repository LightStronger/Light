//
//  UICollectionRxDataSourcesViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UICollectionRxDataSourcesViewController: UIViewController {

    var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         二、RxDataSources
         主视图控制器里的功能实现有如下两种写法：
         注意：RxDataSources 是以 section 来做为数据结构的。所以不管我们的 collectionView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组。
         */
        
        /*
         方式一：使用自带的Section
         */
        
        // 自定义布局方式以及单元格大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        // 创建集合视图
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        
        // 创建一个重用的单元格
        self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.addSubview(self.collectionView!)
        
        // 初始化数据
        let items = Observable.just([
            SectionModel(model: "", items: [
                "Swift",
                "PHP",
                "Python",
                "Java",
                "javascript",
                "C#"
                ])
            ])
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
        configureCell: { (dataSource, collectionView,indexPath,element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        // 绑定单元格数据
        items
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        /*
         方式二：使用自定义的Section
         */
        // 初始化数据
        let sections = Observable.just([
            MySection3(header: "", items: [
                "Swift",
                "PHP",
                "Python",
                "Java",
                "javascript",
                "C#"
                ])
            ])
        
        // 创建数据源
        let dataSource1 = RxCollectionViewSectionedReloadDataSource<MySection3>(
        configureCell: { (dataSource,collectionView,indexPath,element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        }
        )
        
        // 绑定单元格数据
        sections
        .bind(to: collectionView.rx.items(dataSource: dataSource1))
        .disposed(by: disposeBag)
        
        
        /*
         3、多分区的CollectionView
         除了上面的自定义单元格类（MyCollectionViewCell）外，还需要自定义一个分区头类（MySectionHeader），供后面使用。
         */
        
        // 方式一：使用自带的Section
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        // 创建一个重用的分区头
        self.collectionView.register(MySectionHeader.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: "Section")
        
        // 初始化数据
        let items1 = Observable.just([
            SectionModel(model: "脚本语言", items: [
                "Python",
                "javascript",
                "PHP"
                ]),
            SectionModel(model: "高级语言", items: [
                "Swift",
                "C++",
                "Java",
                "C#"
                ])
            ])
        
        // 创建数据源
        let dataSource2 = RxCollectionViewSectionedReloadDataSource<SectionModel<String,String>>(
        configureCell: { (dataSource, collectionView, indexPath, element) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as! MyCollectionViewCell
                cell.label.text = "\(element)"
                return cell},
        configureSupplementaryView: {
            (ds ,cv, kind, ip) in
            let section = cv.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "Section", for: ip) as! MySectionHeader
            section.label.text = "\(ds[ip.section].model)"
            return section
        })
        
        // 绑定单元格数据
        items1
        .bind(to: collectionView.rx.items(dataSource: dataSource2))
        .disposed(by: disposeBag)
        
        // 方式二：使用自定义的Section
        
        // 初始化数据
        let sections1 = Observable.just([
            MySection3(header: "脚本语言", items: [
                "Python",
                "javascript",
                "PHP",
                ]),
            MySection3(header: "高级语言", items: [
                "Swift",
                "C++",
                "Java",
                "C#"
                ])
            ])
        
         // 创建数据源
        let dataSource3 = RxCollectionViewSectionedReloadDataSource<MySection3>(
          
            configureCell: { (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as! MyCollectionViewCell
                cell.label.text = "\(element)"
                return cell},
            configureSupplementaryView:{
                (ds,cv,kind,ip) in
                let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip) as! MySectionHeader
                section.label.text = "\(ds[ip.section].header)"
                return section
        })
        
        // 绑定单元格数据
        sections
        .bind(to: collectionView.rx.items(dataSource: dataSource3))
        .disposed(by: disposeBag)
    }
}

// 自定义Section
struct MySection3 {
    var header: String
    var items: [Item]
}
extension MySection3 : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection3, items: [Item]) {
        self = original
        self.items = items
    }
}
