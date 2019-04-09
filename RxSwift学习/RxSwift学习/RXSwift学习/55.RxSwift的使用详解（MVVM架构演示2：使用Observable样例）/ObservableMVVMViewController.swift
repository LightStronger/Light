//
//  ObservableMVVMViewController.swift
//  RXSwift学习
//
//  Created by bdb on 3/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// (4)最后我们试图控制器(ViewController)只需要调用ViewModel进行数据绑定就g可以了，可以看到由于网络请求、数据处理等逻辑已经被剥离到ViewModel中，VC这边的负担大大减轻了
class ObservableMVVMViewController: UIViewController {

    // 显示资源列表的tableView
    var tableView:UITableView!
    
    // 搜索栏
    var searchBar:UISearchBar!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 三、一个使用Observable的MVVM样例
         （1）当我们在表格上方的搜索框中输入文字时，会实时地去请求 GitHub 接口查询相匹配的资源库。
         （2）数据返回后，将查询结果数量显示在导航栏标题上，同时把匹配度最高的资源条目显示显示在表格中（这个是 GitHub 接口限制，由于数据太多，可能不会一次全部都返回）。
         （3）点击某个单元格，会弹出显示该资源的详细信息（全名和描述）
         （4）删除搜索框的文字后，表格内容同步清空，导航栏标题变成显示“hangge.com”
        */
        
        // 创建表视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 创建表头的搜索栏
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 56))
        self.tableView.tableHeaderView = self.searchBar
        
        // 查询条件输入
        let searAction = searchBar.rx.text.orEmpty
        .throttle(0.5, scheduler: MainScheduler.instance) // 只有间隔超过0.5k秒才发送
        .distinctUntilChanged()
        .asObservable()
        
        // 初始化ViewModel
        let viewModel = ViewModel(searchAction: searAction)
        
        // 绑定导航栏标题数据
        viewModel.navigationTitle.bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
        
        // 将数据绑定到表格
        viewModel.repositories.bind(to: tableView.rx.items) {(tableView , row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlUrl
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe (onNext: {[weak self] item in
                // 显示资源信息(完整名称和描述信息)
                self?.showAlert(title: item.fullName, message: item.description)
            })
    }
    
    // 显示信息
    func showAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        self.present(alertController, animated: true, completion: nil)
    }
}
