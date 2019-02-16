//
//  ObservableViewControllerCreate.swift
//  RXSwift
//
//  Created by bdb on 12/27/18.
//  Copyright © 2018 fulihao. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class ObservableViewControllerCreate: UIViewController {
    // 歌曲列表数据源
    let musicListViewModel = MusicListViewModel()
    
    // 负责对象销毁
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        // 将数据源绑定到tableView上
        musicListViewModel.data.bind(to: tableView.rx.items(cellIdentifier:"musicCell")) { _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
            }.disposed(by: disposeBag)
        
        // tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,y:0,width:100,height: 300), style: .grouped)
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        return tableView
    }()
}
//extension ObservableViewControllerCreate: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return musicListViewModel.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell")
//        let music = musicListViewModel.data[indexPath.row]
//        cell?.textLabel?.text = music.name
//        cell?.detailTextLabel?.text = music.singer
//        return cell!
//    }
//
//}
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("你选中的歌曲信息【\(musicListViewModel.data[indexPath.row])】")
//    }
//}
// 歌曲结构体
struct Music {
    let name: String // 歌名
    let singer: String // 演唱者
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

// 实现CustomStringConvertible协议 方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name:\(name) singer: \(singer)"
    }
    
}

// viewModel 普通方式
//struct MusicListViewModel {
//    let data = [
//        Music(name: "无条件", singer: "陈奕迅"),
//        Music(name: "你曾是少年", singer: "S.H.E"),
//        Music(name: "从前的我", singer: "陈洁仪"),
//        Music(name: "在木星", singer: "朴树"),
//                ]
//}

// viewModel RXSwift
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ])
}
