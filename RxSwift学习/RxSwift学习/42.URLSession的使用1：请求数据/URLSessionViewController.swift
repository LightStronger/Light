//
//  URLSessionViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/31/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class URLSessionViewController: UIViewController {
    
    //“发起请求”按钮
    var startBtn: UIButton!
    //“取消请求”按钮
    var cancelBtn: UIButton!
    
    let disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // RxSwift(或者说RxCocoa)除了对系统原生的UI控件提供了rx扩展外，对URLSession也进行了扩展，从而让我们可以很方便地发送HTTP请求
        
        /*
         一、请求网络数据
         1、通过rx.response请求数据
         */
        
        // 创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        // 创建请求对象
        let request = URLRequest(url: url!)
        
        // 创建并发起请求
        URLSession.shared.rx.response(request: request).subscribe(onNext: { (response,data) in
            // 数据处理
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("返回的数据是：%@",str ?? "")
            
        }).disposed(by: disposed)
        
        /*
         从上面样例可以发现，不管请求成功与否都会进入到 onNext 这个回调中。如果我们需要根据响应状态进行一些相应操作，比如：
         .状态码在 200 ~ 300 则正常显示数据。
         .如果是异常状态码（比如：404）则弹出告警提示框。
         如果是异常状态码（比如：404）则弹出告警提示框。
         */
        
        URLSession.shared.rx.response(request: URLRequest(url: URL(string: "https://www.douban.com/xxxxxxxxxx/app/radio/channels")!)).subscribe(onNext: { (response,data) in
            // 判断响应结果状态码
            if 200..<300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：%@",str ?? "")
            } else {
                print("请求失败")
            }
        })
        
        /*
         2、通过rx.data请求数据
         rx.data 与 rx.response 的区别：
         如果不需要获取底层的 response，只需知道请求是否成功，以及成功时返回的结果，那么建议使用 rx.data。
         因为 rx.data 会自动对响应状态码进行判断，只有成功的响应（状态码为 200~300）才会进入到 onNext 这个回调，否则进入 onError 这个回调。
         （1）如果不需要考虑请求失败的情况，只对成功返回的结果做处理可以在 onNext 回调中进行相关操作。
         */
        
        // 创建并发起请求
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("请求成功！返回的数据是：%@",str ?? "")
        }).disposed(by: disposed)
        
        
        /*
         （2）如果还要处理失败的情况，可以在 onError 回调中操作。
         */
        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "https://www.douban.com/xxxxxx/app/radio/channels")!))
            .subscribe(onNext: { (data) in
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：%@",str ?? "")
            }, onError: { (error) in
                print("请求失败！错误原因：%@",error)
            }).disposed(by: disposed)
        
        /*
         二、手动发起请求、取消请求
         在很多情况下，网络请求并不是由程序自动发起的。可能需要我们点击个按钮，或者切换个标签时才去请求数据。除了手动发起请求外，同样的可能还需要手动取消上一次的网络请求（如果未完成）。下面通过样例演示这个如何实现。
         
         （1）每次点击“发起请求”按钮则去请求一次数据。
         （2）如果请求没返回时，点击“取消请求”则可将其取消（取消后即使返回数据也不处理了）。
         */
        
        // 发起请求按钮点击
        startBtn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.data(request: request)
                .takeUntil(self.cancelBtn.rx.tap) // 如果“取消按钮”点击则停止请求
            }
            .subscribe(onNext: { (data) in
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是%@", str ?? "")
            }, onError: { (error) in
                print("请求失败 错误原因：%@",error)
            }).disposed(by: disposed)
        
        
    }
}
