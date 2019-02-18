//
//  MoyaUseTwoWayViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class MoyaUseTwoWayViewController: UIViewController {

    var tableView:UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         三、将结果转为JSON对象
         1、实现方法
         (1)如果服务器返回的数据是json格式的话，直接通过mapJSON方法即可将其转成JSON对象。
         注意：关于 DouBanProvider 里的具体内容，可以参考上文（点击查看）。
         */

        // 获取数据 方式一
        DouBanProvider.rx.request(.channels)
            .subscribe(onSuccess: { (response) in
                // 数据处理
                let json = try? response.mapJSON() as! [String: Any]
                print("-----请求成功！返回的如下数据 ----")
                print(json!)
                
            }, onError: { error in
                print("数据请求失败！错误原因",error)
            }).disposed(by: disposeBag)
        
        //获取数据 方式二
        DouBanProvider.rx.request(.channels)
            .mapJSON()
            .subscribe(onSuccess: { data in
                //数据处理
                let json = data as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json)
            },onError: { error in
                print("数据请求失败!错误原因：", error)
                
            }).disposed(by: disposeBag)
        
        /*
         2、使用样例
         (1)效果图
         .我们使用Moya调用豆瓣的FM的API接口，获取所有的频道 列表并显示在表格中
         .点击任意一个频道，调用另外一个接口随机获取该频道下的一首歌曲，并弹出显示
         结合Moya使用2：结果处理、模型转换。png
         */
        
        // 创建表视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 获取列表数据
        let data = DouBanProvider.rx.request(.channels)
        .mapJSON()
            .map { (data) -> [[String:Any]] in
                if let json = data as? [String:Any],
                    let channels = json["channels"] as? [[String:Any]] {
                return channels
                } else {
                    return []
                }
        }.asObservable()
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView,row,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element["name"]!)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected([String:Any].self)
            .map{ $0["channel_id"] as! String }
            .flatMap { DouBanProvider.rx.request(.playlist($0))
        }
        .mapJSON()
            .subscribe(onNext: { [weak self] data in
                // 解析数据，获取歌曲信息
                if let json = data as? [String: Any], let musics = json["song"] as? [[String: Any]] {
                    let artist = musics[0]["artist"]!
                    let title = musics[0]["title"]!
                    let message = "歌手：\(artist)\n歌曲：\(title)"
                    // 将歌曲信息弹出显示
                    self?.showAlert(title:"歌曲信息",message:message)
                }
            }).disposed(by: disposeBag)
    }
    // 显示消息
    func showAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style:.cancel , handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
