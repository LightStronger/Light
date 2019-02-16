//
//  RxAlamofireBasicViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/31/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxAlamofire

class RxAlamofireBasicViewController: UIViewController {

    //“发起请求”按钮
    var startBtn: UIButton!
    //“取消请求”按钮
    var cancelBtn: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         在之前的两篇文章中，我介绍了 RxSwift 对 URLSession 的扩展以及使用。当然除了可以使用 URLSession 进行网络请求外，网上还有许多优秀的第三方网络库也可以与 RxSwift 结合使用的，比如：RxAlamofire 和 Moya。这次我先介绍下前者。
         */
        /*
         二、基本用法
         1、使用request请求数据
         */
        // 创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // 创建并发起请求
        request(.get, url)
            .data()
            .subscribe(onNext: { (data) in
                // 数据处理
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("返回的数据是：",str ?? "")
            }, onError: { error in
                print("请求失败！错误原因：", error)
            }).disposed(by: disposeBag)
        
        /*
         2、使用requestData请求数据
         */
        // 创建并发起请求
        requestData(.get, url)
            .subscribe(onNext: { (reqponse ,data) in
                // 数据处理
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("返回的数据是：",str ?? "")
            })
            .disposed(by: disposeBag)
        
        // 使用 requestData 的话，不管请求成功与否都会进入到 onNext 这个回调中。如果我们想要根据响应状态进行一些相应操作，通过 response 参数即可实现。
        // 创建并发起请求
        requestData(.get, url).subscribe(onNext: { (response,data) in
            // 判断响应结果状态码
            if 200 ..< 300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：",str ?? "")
                
            } else {
                print("请求失败！")
            }
        })
        .disposed(by: disposeBag)
        
        /*
         3、获取String类型数据
         (1)如果请求的数据是字符串类型的，我们可以在request】请求时直接通过responseString()方法实现自动转换，省的在回调中还要手动将data转为string
         */
        request(.get, url)
        .responseString()
            .subscribe(onNext: { (response,data) in
                // 数据处理
                print("返回的数据是：",data)
            }).disposed(by: disposeBag)
        
        
        // (2)当然更简单的方法就是直接使用requestString去获取数据
        requestString(.get, url)
            .subscribe(onNext: { (response,data) in
                // 数据处理
                print("返回的数据是：",data)
            })
            .disposed(by: disposeBag)
        
        /*
         三、手动发起请求、取消请求
         .每次点击“发起请求”按钮则去请求一次数据。
         .如果请求没返回时，点击“取消请求”则可将其取消（取消后即使返回数据也不处理了）。
         */
        
        startBtn.rx.tap.asObservable()
            .flatMap {
                request(.get, url).responseString()
                .takeUntil(self.cancelBtn.rx.tap) //如果“取消按钮”点击则停止请求
            }
            .subscribe(onNext: { (response,data) in
                print("请求成功！返回的数据是：",data)
            }, onError: { (error) in
                print("请求失败！错误原因：",error)
            }).disposed(by: disposeBag)
        
        
        
    }
}
