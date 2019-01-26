//
//  TabRxDataSourcesViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/26/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TabRxDataSourcesViewController: UIViewController {

    let disposeBag = DisposeBag()
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // 二、RxDataSources
        
        /*
         3、单分区的TableView
         */
        // 方式一：使用自带的Section
        // 注意：RxDataSources 是以 section 来做为数据结构的。所以不管我们的 tableView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组。

        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 初始化数据
        let items = Observable.just([
            SectionModel(model: "", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionModel<String,String>>(configureCell: {
            (dataSource,tv,indexPath,element ) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(indexPath.row): \(element)"
            return cell
        })
        
        // 绑定单元格数据
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        // 方式二：使用自定义的Section
        // 初始化数据
        let sections = Observable.just([
            MySection(header: "", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ])
            ])
        
        // 创建数据源
        let dataSource1 = RxTableViewSectionedAnimatedDataSource<MySection>(
        // 设置单元格
            configureCell: {ds,tv,ip,item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row): \(item)"
                return cell
        })
        
        // 绑定单元格数据
        sections
        .bind(to: tableView.rx.items(dataSource: dataSource1))
        .disposed(by: disposeBag)
        
        
        
        
        
        /*
         4、多分区的TableView
         方式一
         */
        // 初始化数据
        let items1 = Observable.just([
            SectionModel(model: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            SectionModel(model: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        // 创建数据源
        let dataSouce2 = RxTableViewSectionedReloadDataSource
        <SectionModel<String,String>>(configureCell: {
            (dataSource , tv , indexPath , element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(indexPath.row):\(element)"
            return cell
        })
        
        // 设置区分头标题
        dataSouce2.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }
        
        // 设置分区尾标题
        dataSouce2.titleForFooterInSection = {ds, index in
            return "footer"
        }
        
        // 绑定单元格数据
        items1
        .bind(to: tableView.rx.items(dataSource: dataSouce2))
        .disposed(by: disposeBag)
        
        // 方式二：使用自定义Section
        let dataSource3 = RxTableViewSectionedAnimatedDataSource<MySection>(
        
            // 设置单元格
            configureCell: { ds,tv,ip,item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row):\(item)"
                return cell
        },
            // 设置分区头标题
            titleForHeaderInSection: {ds,index in
                return ds.sectionModels[index].header
        }
        )
        
        // 绑定单元格数据
        sections
        .bind(to: tableView.rx.items(dataSource: dataSource3))
        .disposed(by: disposeBag)
        
        
    }
}

// 自定义Section
struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
