//
//  RxAlamofireResultViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/31/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import ObjectMapper
class RxAlamofireResultViewController: UIViewController {

    var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         四、将结果转为JSON对象
         */
        
        // 创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // 创建并发起请求
        request(.get, url)
            .data()
            .subscribe(onNext: { (data) in
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json!)
            }).disposed(by: disposeBag)
        
        // (2)我们换种方式，在订阅前使用responseJSON()进行转换也是可以的
        request(.get, url)
            .responseJSON()
            .subscribe(onNext: { (dataResponse) in
                let json = dataResponse.value as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json)
            })
            .disposed(by: disposeBag)
        
        // (3) 当然最简单的还是直接使用requestJSON方法去获取JSON数据
        requestJSON(.get, url)
            .subscribe(onNext: { (response,data) in
                let json = data as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json)
            })
            .disposed(by: disposeBag)
        
        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 获取列表数据
        let data = requestJSON(.get, url)
            .map{ response , data -> [[String: Any]] in
                if let json = data as? [String: Any],
                    let channels = json["channels"] as? [[String: Any]] {
                    return channels
                } else {
                    return []
                }
        }
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView,row,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row):\(element["name"]!)"
            return cell
        }.disposed(by: disposeBag)
        
        
        /*
         五、将结果映射称自定义对象
         为了让 ObjectMapper 能够更好地与 RxSwift 配合使用，我们对 Observable 进行扩展（RxObjectMapper.swift），增加数据转模型对象、以及数据转模型对象数组这两个方法。
         */
    }
}
