//
//  ModelViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/31/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class ModelViewController: UIViewController {

    var tableView: UITableView!
    
    let disposeBug = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        /*
         三、将结果转为JSON对象
         1、实现方法
         (1)如果服务器返回的数据是 json 格式的话，我们可以使用 iOS 内置的 JSONSerialization 将其转成 JSON 对象，方便我们使用。
         */
        // 创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        // 创建请求对象
        let request = URLRequest(url: url!)
        
        // 创建并发起请求
        URLSession.shared.rx.data(request: request)
            .subscribe(onNext: { data in
            let json = try?JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print("--- 请求成功！返回的如下数据 ---")
            print(json!)
        }).disposed(by: disposeBug)
        
        // (2)当然我们在订阅前就进行转换也是可以的
        URLSession.shared.rx.data(request: request)
            .map{
                try JSONSerialization.jsonObject(with: $0, options: .allowFragments) as! [String: Any]
            }
            .subscribe(onNext: { data in
                print("--- 请求成功！返回的如下数据 ---")
                print(data)
            }).disposed(by: disposeBug)
        
        // (3) 还有更简单的方法，就是直接使用RxSwift提供的rx.json方法获取数据，它会直接将结果转成JSON对象
        
        URLSession.shared.rx.json(request: request).subscribe(onNext: {data in
            let json = data as! [String: Any]
            print("--- 请求成功！返回的如下数据 ---")
            print(json)
        }).disposed(by: disposeBug)
        */
        
        /*
         2、使用样例
         我们将获取到的豆瓣频道列表数据转换成JSON对象，并绑定到表格上显示
         豆瓣数据请求.png
         */
        // 创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        // 创建请求对象
        let request = URLRequest(url: url!)
        
        // 获取列表数据
        let data = URLSession.shared.rx.json(request: request)
            .map{ result -> [[String: Any]] in
                if let data = result as? [String: Any],
                    let channels = data["channels"] as? [[String: Any]] {
                    return channels
                } else {
                    return []
                }
        }
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView , row , element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row) :\(element["name"]!)"
            return cell
        }.disposed(by: disposeBug)
        
        /*
         四、将结果映射成自定义对象
         为了让 ObjectMapper 能够更好地与 RxSwift 配合使用，我们对 Observable 进行扩展（RxObjectMapper.swift），增加数据转模型对象、以及数据转模型对象数组这两个方法。
         */
        
        /*
         我们还是以前面的豆瓣音乐频道数据为例。首先我定义好相关模型（需要实现 ObjectMapper 的 Mappable 协议，并设置好成员对象与 JSON 属性的相互映射关系。）
         */
        
        // 创建并发起请求
        /*
        URLSession.shared.rx.json(request: request)
        .mapObject(type: Douban.self)
            .subscribe(onNext: { (douban: Douban) in
                if let channels = douban.channels {
                    print("--- 共\(channels.count)个频道 ---")
                    for channel in channels {
                        if let name = channel.name,let channelId = channel.channelId {
                            print("\(name) （id:\(channelId)）")
                        }
                    }
                }
            }).disposed(by: disposeBug)
        */
        
        let data1 = URLSession.shared.rx.json(request: request)
            .mapObject(type: Douban.self)
            .map { $0.channels ?? []}
        
        // 将数据绑定到表格
        data1.bind(to: tableView.rx.items) { (tableView,row,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row):\(element.name!)"
            return cell
        }.disposed(by: disposeBug)
        
        
    }
}

// 数据映射错误
public enum RxObjectMapperError: Error {
    case parsingError
}
// 扩展Observable：增加模型映射方法
public extension Observable where Element: Any {
    
    // 将JSON数据转成对象
    public func mapObject<T>(type:T.Type) -> Observable<T> where T:Mappable {
        let mapper = Mapper<T>()
        
        return self.map{ (element) -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedElement
        }
    }
    
    // 将JSON数据转成数组
    public func mapArray<T>(type: T.Type) -> Observable<[T]> where T:Mappable {
        let mapper = Mapper<T>()

        return self.map { (element) ->[T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedArray
        }
    }
}

// 豆瓣接口模型
// 我们还是以前面的豆瓣音乐频道数据为例。首先我定义好相关模型（需要实现 ObjectMapper 的 Mappable 协议，并设置好成员对象与 JSON 属性的相互映射关系。）

class Douban: Mappable {
    // 频道列表
    var channels: [Channel]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mapple
    func mapping(map: Map) {
        channels <- map["channels"]
    }
}

// 频道模型
class Channel: Mappable {
    
    var name:String?
    var nameEn:String?
    var channelId:String?
    var seqId:Int?
    var abbrEn:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}
