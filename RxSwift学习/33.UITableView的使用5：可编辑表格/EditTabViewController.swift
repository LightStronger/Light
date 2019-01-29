//
//  EditTabViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/28/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


// (1)由于编辑操作比较多，我们首先使用enum创建一个命令枚举，里面定义了对tableView数据的各种操作
// 定义各种操作命令
enum TableEditingCommand {
    case setItems(items: [String]) // 设置表格数据
    case addItem(item: String) // 新增数据
    case moveItem(from: IndexPath, to: IndexPath) // 移动数据
    case deleteItem(IndexPath) // 删除数据
}

// (2)接着定义 tableView 对应的 ViewModel。这里面除了保存有表格数据外，还包含上面定义的 4 个操作命令的具体实现。
// 定义表格对应的ViewModel
struct TableViewModel {
    // 表格数据项
    fileprivate var items:[String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    // 执行相应的命令，并返回最终的结果
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据")
            return TableViewModel(items: items)
        case .addItem(let item):
            print("新增数据项")
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            print("移动数据项")
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexPath):
            print("删除数据项")
            var items = self.items
            items.remove(at: indexPath.row)
            return TableViewModel(items: items)
        }
    }
}

class EditTabViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    // 刷新按钮
    var refreshButton: UIBarButtonItem!
    // 新增按钮
    var addButton: UIBarButtonItem!
    // 表格
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         八、可编辑表格
         一、效果图
         (1)程序启动后表格会自动加载5条随机数据，点击“刷新”则又生成5条数据并显示
         (2)点击“加号”图标后，会在当前数据集的末尾添加一条随机数据并显示
         (3)点击单元格左侧的“减号”图标则可以将改行数据删除
         (4)拖动单元格右侧的控制图标可以改变显示顺序
         */
        
        /*
         2、样例代码
         (1)由于编辑操作比较多，我们首先使用enum创建一个命令枚举，里面定义了对tableView数据的各种操作
         TableEditingCommand
         (2)接着定义 tableView 对应的 ViewModel。这里面除了保存有表格数据外，还包含上面定义的 4 个操作命令的具体实现。
         
         */
        
        
        
        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        // 表格模型
        let initialVM = TableViewModel()
        
        // 刷新数据命令
        let refreshCommand = refreshButton.rx.tap.asObservable()
        .startWith(())
        .flatMapLatest(getRandomResult)
        .map(TableEditingCommand.setItems)
        
        // 新增条目命令
        let addCommand = addButton.rx.tap.asObservable()
            .map{"\(arc4random())"}
            .map(TableEditingCommand.addItem)
        
        // 移动位置命令
        let movedCommand = tableView.rx.itemMoved
        .map(TableEditingCommand.moveItem)
        
        // 删除条目命令
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
        .map(TableEditingCommand.deleteItem)
        
        // 绑定单元格数据
         Observable.of(refreshCommand, addCommand, movedCommand, deleteCommand)
        .merge()
        .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand) -> TableViewModel in
                return vm.execute(command: command)
        }
        .startWith(initialVM)
        .map {
                [AnimatableSectionModel(model: "", items: $0.items)]
        }
        .share(replay: 1)
        .bind(to: tableView.rx.items(dataSource: ViewController.dataSource()))
        .disposed(by: disposeBag)
        
        
        
        
        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setEditing(true, animated: true)
    }
    
    // 获取随机数据
    func getRandomResult() -> Observable<[String]> {
        print("生成随机数据")
        let items = (0..<5).map { _ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }
}

extension ViewController {
    // 创建表格数据源
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String,String>> {
        return RxTableViewSectionedAnimatedDataSource(
            // 设置插入、删除、移动单元格的动画效果
            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left), configureCell: {
                (dataSource,tv,indexPath,element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "条目\(indexPath.row):\(element)"
                return cell
        },
            canEditRowAtIndexPath: {_,_ in
                return true // 单元格可删除
        },
            canMoveRowAtIndexPath: {_,_ in
                return true // 单元格可移动
        }
        )
    }
}
