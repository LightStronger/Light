//
//  ObjectMapperAndMoyaViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper
class ObjectMapperAndMoyaViewController: UIViewController {

    // 显示频道列表的tableView
    var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         四、将结果映射成自定义对象
         1，准备工作
         （1）要实现数据转模型（model），我们这里还要先引入一个第三方的数据模型转换框架：ObjectMapper。关于它的安装配置，以及相关说明可以参考我之前写的文章：
             .Swift - 使用ObjectMapper实现模型转换1（JSON与Model的相互转换）
         （2）为了让 ObjectMapper 能够更好地与 Moya 配合使用，我们需要使用 Moya-ObjectMapper 这个 Observable 扩展库。它的作用是增加数据转模型对象、以及数据转模型对象数组这两个方法。我们现将其下载到本地。
             GitHub 主页：https://github.com/ivanbruel/Moya-ObjectMapper
         （3）Moya-ObjectMapper 配置很简单只需把 sourcs 文件夹中的如下 3 个文件添加到项目中来即可。
             .Response+ObjectMapper.swift
             .ObservableType+ObjectMapper.swift
             .Single+ObjectMapper.swift
         2、使用样例
         （1）我们还是以前面的豆瓣音乐频道数据为例。首先我定义好相关模型（需要实现 ObjectMapper 的 Mappable 协议，并设置好成员对象与 JSON 属性的相互映射关系。）
         */
        
        // 获取数据
        DouBanProvider.rx.request(.channels)
        .mapObject(Douban.self)
            .subscribe(onSuccess: { (douban) in
                if let channels = douban.channels {
                    print("----共\(channels.count)个频道 ---")
                    for channel in channels {
                        if let name = channel.name, let channelId = channel.channelId {
                            print("\(name) (id:\(channelId)")
                        }
                    }
                }
            }, onError: { error in
                print("数据请求失败！错误原因：",error)
            }).disposed(by: disposeBag)
        
        
        // 创建表视图
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 获取列表数据
        let data = DouBanProvider.rx.request(.channels)
        .mapObject(DoubanD.self)
        .map{ $0.channels ?? [] }
        .asObservable()
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(String(describing: element.name))!"
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected(ChannelD.self)
            .map { $0.channelId! }
            .flatMap { DouBanProvider.rx.request(.playlist($0))}
            .mapObject(Playlist.self)
            .subscribe(onNext: { [weak self] playlist in
                // 解析数据，获取歌曲信息
                if playlist.song.count > 0 {
                    let artist = playlist.song[0].artist!
                    let title = playlist.song[0].title!
                    let message = "歌曲：\(artist)\n歌曲：\(title)"
                    // 将歌曲信息弹出显示
                    self?.showAlert(title: "歌曲信息", message: message)
                }
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

// 豆瓣接口模型
struct DoubanD:Mappable {
    // 频道列表
    var channels: [ChannelD]?
    
    init?(map:Map) { }
    
    // Mappable
    mutating func mapping(map:Map) {
        channels <- map["Channels"]
    }
}

// 频道模型
struct ChannelD: Mappable {
    var name: String?
    var nameEn: String?
    var channelId: String?
    var seqId: String?
    var abbrEn: String?
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map:Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}

// 歌曲列表模型
struct Playlist: Mappable {
    var r: Int!
    var isShowQuickStart: Int!
    var song:[Song]!
    
    init?(map:Map) { }
    
    // Mappable
    mutating func mapping(map:Map) {
        r <- map["r"]
        isShowQuickStart <- map["is_show_quick_start"]
        song <- map["song"]
    }
}

// 歌曲模型
struct Song: Mappable {
    var title: String!
    var artist: String!
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        title <- map["title"]
        artist <- map["artist"]
    }
}
