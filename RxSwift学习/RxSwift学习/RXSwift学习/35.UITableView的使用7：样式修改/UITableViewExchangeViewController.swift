//
//  UITableViewExchangeViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/29/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UITableViewExchangeViewController: UIViewController {

    var tableView: UITableView!
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<MySection2>?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         十、相关样式的修改
         有时我们可能需要调整 tableView 单元格的高度、或者修改 section 头尾视图样式等等。虽然 RxSwift 没有封装相关的方法，但我们仍然可以通过相关的代理方法来设置。
         */
        
        /*
         1、修改单元格高度
         效果图：修改单元格高度.png
         */
        
        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 初始化数据
        let sections = Observable.just([
            MySection2(header: "基本控件", items: [
                "UILabel的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection2(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection2>(
        // 设置单元格
            configureCell: { ds,tv,ip,item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row):\(item)"
                return cell
        },
            // 设置分区尾部标题
            titleForFooterInSection: {ds,index in
                return "共有\(ds.sectionModels[index].items.count)个控件"
        }
        )
        self.dataSource = dataSource
        
        // 绑定单元格数据
        sections
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        // 设置代理
        tableView.rx.setDelegate(self)
        .disposed(by: disposeBag)
    }
}

// tableView代理实现
extension UITableViewExchangeViewController: UITableViewDelegate {
    
    // 返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        let titleLabel = UILabel()
        titleLabel.text = self.dataSource?[section].header
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    // 返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


// 自定义Section
struct MySection2 {
    var header: String
    var items: [Item]
}

extension MySection2: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection2, items: [Item]) {
        self = original
        self.items = items
    }
}
