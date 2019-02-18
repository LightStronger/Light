//
//  ObjectMapperNetPerfection ViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper
class ObjectMapperNetPerfection_ViewController: UIViewController {

    // 显示频道列表tableView
    var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         功能改进：将网络请求服务提取出来
         (1)上面的样例中我们是在VC里是直接调用Moya的 provider进行数据请求，并进行模型转换
         (2)我们也可以把网络请求和数据转换相关代码提取出来，作为一个专门的Service。比如DouBanNetworkService，内容如下：
         */
        
        // 创建表视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 豆瓣网络请求服务
        let networkService = DouBanNetworkService()
        
        // 获取列表数据
        let data = networkService.loadChannels()
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView , row , element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected(Channel.self)
            .map { $0.channelId! }
            .flatMap(networkService.loadFirstSong)
            .subscribe(onNext: { [weak self] song in
                // 将歌曲信息弹出显示
                let message = "歌曲：\(song.artist!)\n歌曲：\(song.title!)"
                self?.showAlert(title: "歌曲信息", message: message)
            }).disposed(by: disposeBag)
        
        
    }
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
