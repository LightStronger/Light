//
//  UITableViewDifferentViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/29/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UITableViewDifferentViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    // tab
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         在之前的文章中，同一个tableView里的单元格类型都是一样的，但有时我们需要在一个tableview里显示多种类型的数据，这就要求tableView可以根据当前行的数据自动使用不同类型的cell。
         */
        
        /*
         九、同一个tableView中使用不同类型的cell
         (1)tableView绑定的数据源中一共有2个section，每个section里分别有3条数据需要显示
         (2)每个cell会根据数据类型的不同，自动选择相应的显示方式：“文字+图片”或“文字+开关按钮”
         效果图：不同的cell显示.png
         */
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView!.register(DifferentSwitchTableViewCell.self, forCellReuseIdentifier: "SwiftCell")
        self.tableView!.register(DifferentImageViewTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        self.view.addSubview(self.tableView)
        
        // 初始化数据
        let sections = Observable.just([
            MySection1(header: "我是第一个分区的", items: [
                .TitleImageSectionItem(title: "图片数据1", image:UIImage(named: "php")!),
                .TitleSwitchSectionItem(title: "开关数据1", enabled: true)
                ]),
            MySection1(header: "我是第二个分区的", items: [
                .TitleSwitchSectionItem(title: "开关数据2", enabled: false),
                .TitleImageSectionItem(title: "图片数据", image: UIImage(named: "swift")!)
                ])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection1>(
        // 设置单元格
            configureCell: { dataSource , tableView , indexPath, item in
                switch dataSource[indexPath] {
                case let .TitleImageSectionItem(title,image):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UIImageView).image = image
                    return cell
                case let .TitleSwitchSectionItem(title,enabled):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftCell", for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UISwitch).isOn = enabled
                    return cell
                }
        },
            // 设置分区头标题
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
    )
        
        // 绑定单元格数据
        sections
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
}

// 单元格类型
enum SectionItem {
    case TitleImageSectionItem(title: String, image: UIImage)
    case TitleSwitchSectionItem(title: String, enabled: Bool)
}
// 自定义Section
struct MySection1 {
    var header: String
    var items: [SectionItem]
}

extension MySection1 : SectionModelType {
    typealias Item = SectionItem
    init(original: MySection1, items: [Item]) {
        self = original
        self.items = items
    }
}
