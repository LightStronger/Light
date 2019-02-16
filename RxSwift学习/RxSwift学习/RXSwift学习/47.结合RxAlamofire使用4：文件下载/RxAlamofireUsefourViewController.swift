//
//  RxAlamofireUsefourViewController.swift
//  RxSwift学习
//
//  Created by bdb on 2/2/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxAlamofire
class RxAlamofireUsefourViewController: UIViewController {

    let disposeBag = DisposeBag()
    var progressView:UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         七、文件下载
         1、自定义下载文件的保存目录
         （1）下面代码将 logo 图片下载下来，并保存到用户文档目录下（Documnets 目录），文件名不变。
         */
        
        // 指定下载路径（文件名不变）
        let destination:DownloadRequest.DownloadFileDestination = {_, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            // 两个参数表示如果有同名文件会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
        }
        
        // 需要下载的文件
        let fileURL = URL(string: "http://www.hangge.com/blog/images/logo.png")!
        
        // 开始下载
        download(URLRequest(url: fileURL), to: destination)
            .subscribe(onNext: { element in
                print("开始下载。")
            }, onError: { error in
                print("下载失败! 失败原因：\(error)")
            }, onCompleted: {
                print("下载完毕!")
            })
            .disposed(by: disposeBag)
        
        // (2)将logo图片下载下来，并保存到用户文档目录下的file1子目录(Documnets/file1目录)，文件名改成myLogo.png
        // 指定瞎子路径和保存文件名
        let destination1:DownloadRequest.DownloadFileDestination = {_,_ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file1/myLogo.png")
            // 两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // 需要下载的文件
        let fileURL1 = URL(string: "http://www.hangge.com/blog/images/logo.png")!
        // 开始下载
        download(URLRequest(url: fileURL1), to: destination1)
            .subscribe(onNext: { (element) in
                print("开始下载。")
            }, onError: { (error) in
                print("下载失败！失败原因：\(error)")
            }, onCompleted: {
                print("下载完毕！")
            })
        .disposed(by: disposeBag)
        
        /*
         2、使用默认提供的下载路径
         Alamofile内置的许多常用的下载路径方便我们使用，简化代码。注意的是，使用这种方式如果下载路径下有同名文件，不会覆盖原来的文件
         比如，下载到用户文档目录下可以改成
         */
        let destination2 = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        /*
         3、下载进度
         (1)下面代码在文件下载过程中会不断地打印出当前下载进度、已下载部分的大小、以及文件总大小(单位都是字节)
         */
        
        // 开始下载
        download(URLRequest(url: fileURL1), to: destination2)
            .subscribe(onNext: { (element) in
                print("开始下载。")
                element.downloadProgress(closure: { (progress) in
                    print("当前进度：\(progress)")
                    print("已下载：\(progress.completedUnitCount/1024)KB")
                    print("总大小：\(progress.totalUnitCount/1024)KB")
                })
            }, onError: { (error) in
                print("下载失败！失败原因：\(error)")
            }, onCompleted: {
                print("下载完毕！")
            }).disposed(by: disposeBag)
        
        // (2) 下面我换种写法，将进度转成可观察序列，并绑定到进度条上显示
        // 开始 下载
        download(URLRequest(url: fileURL1), to: destination2)
            .map { (request) in
                // 返回一个关于进度的可观察序列
                Observable<Float>.create({ (observer) in
                    request.downloadProgress(closure: { (progress) in
                        observer.onNext(Float(progress.fractionCompleted))
                        if progress.isFinished {
                            observer.onCompleted()
                        }
                    })
                    return Disposables.create()
                })
        }
        .flatMap{$0}
        .bind(to: progressView.rx.progress) //将进度绑定UIProgressView上
        .disposed(by: disposeBag)
        
    }
}
