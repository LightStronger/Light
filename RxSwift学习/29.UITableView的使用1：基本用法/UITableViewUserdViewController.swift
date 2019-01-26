//
//  UITableViewUserdViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/26/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UITableViewUserdViewController: UIViewController {

    let disposeBad = DisposeBag()
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(self.tableView!)
        
        // 初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
            ])
        
        // 设置单元格数据(其实就是对cellForRowAt的封装)
        items.bind(to: tableView.rx.items) {(tableView,row,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = "\(row): \(element)"
            return cell
        }
        .disposed(by: disposeBad)
        
        /*
         2、单元格选中时间响应
         .当我们点击某个单元格时将其索引位置，以及对应的标题打印出来
         .如果业务代码直接放在响应方法内部，可以这么写：
         */
        
        // 获取选中项的索引
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("选中项的indexPath为:\(indexPath)")
            })
            .disposed(by: disposeBad)
        
        // 获取选中项的内容
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { item in
                print("选中项的标题：\(item)")
            })
        .disposed(by: disposeBad)
        
        /* 或者也可以在响应中调用外部的方法
        // 获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
           self?.showMessage("选中项的indexPath为：\(indexPath)")
        })
        .disposed(by: disposeBad)
        
        //获取选中项的内容
       tableView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] item in
                    self?.showMessage("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        */
        
        /*
         (4)当然同时获取选中项的索引以及内容也是可以的
         Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
         .bind { [weak self] indexPath, item in
         self?.showMessage("选中项的indexPath为：\(indexPath)")
         self?.showMessage("选中项的标题为：\(item)")
         }
         .disposed(by: disposeBag)    }
         */
        
        /*
         4、单元格删除事件响应
         */
        // 获取删除项的索引
        tableView.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                print("删除项的indexpath为：\(indexPath)")
            })
        .disposed(by: disposeBad)
        
        // 获取删除项的内容
        tableView.rx.modelDeleted(String.self)
            .subscribe(onNext: { item in
                print("删除项的标题为：\(item)")
            })
        .disposed(by: disposeBad)
        
        /*
         5、单元格移动事件响应
         */
        // 获取移动项的索引
        tableView.rx.itemMoved
            .subscribe(onNext: { sourceIndexPath,destinationIndexPath in
                print("移动项原来的indexPath为：\(sourceIndexPath)","移动项现在的indexPath为：\(destinationIndexPath)")
            })
        .disposed(by: disposeBad)
        
        /*
         6、单元格插入事件响应
         */
        // 获取插入项的索引
        tableView.rx.itemInserted
            .subscribe(onNext: { indexPath in
                print("插入项的indexpath为:\(indexPath)")
            })
        .disposed(by: disposeBad)
        
        /*
         7、单元格尾部附件（图标）点击事件响应
         */
        // 获取点击的尾部图标的索引
        tableView.rx.itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("尾部项的indexPath为：\(indexPath)")
            })
        .disposed(by: disposeBad)
        
        /*
         8、单元格将要显示出来的时间响应
         */
        // 单元格将要显示出来的事件响应
        tableView.rx.willDisplayCell
            .subscribe(onNext: {cell,indexPath in
                print("将要显示单元格indexPath为：\(indexPath)")
                print("将要显示单元格cell为：\(cell)\n")
            })
        .disposed(by: disposeBad)
    }
}
