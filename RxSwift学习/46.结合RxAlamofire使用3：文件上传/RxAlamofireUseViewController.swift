//
//  RxAlamofireUseViewController.swift
//  RxSwift学习
//
//  Created by bdb on 2/1/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
class RxAlamofireUseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var progressView:UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         六、文件上传
         1、支持的上传类型
         Alamofire支持如下上传类型，使用RxAlamofire也是一样的：
         .File
         .Data
         .Stream
         .MultiparFormData
         */
        
        /*
         2、使用文件流的形式上传文件
         */
        // 需要上传的文件路径
        let fileURL = Bundle.main.url(forResource: "hangge", withExtension: "zip")
        // 服务器路径
        let upLoadURL = URL(string: "http://www.hangge.com/upload.php")!
        
        // 将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, upLoadURL))
            .subscribe(onCompleted: {
                 print("上传完毕!")
            })
            .disposed(by: disposeBag)
        /*
         如何在上传时附带上文件名？
         有时我们在文件上传的同时还会想要附带一些其它参数，比如文件名。这样服务端接收到文件后，就可以根据我们传过来的文件名来保存。实现这个其实很简单，客户端和服务端分别做如下修改。
         客户端：将文件名以参数的形式跟在链接后面。比如：http://hangge.com/upload.php?fileName=image1.png
         服务端：通过 $_GET["fileName"] 得到这个参数，并用其作为文件名保存。
         */
        
        /*
         3、获得上传进度
         下面代码在文件上穿过程中会不断地打印当前进度、已上传部分的大小、以及文件总大小(单位都是字节)
         */

        // 将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, upLoadURL))
            .subscribe(onNext: { (element) in
                print("--- 开始上传 ---")
                element.uploadProgress(closure: { (progress) in
                    print("当前进度：\(progress.fractionCompleted)")
                    print("已上传载：\(progress.completedUnitCount/1024)KB")
                    print("总大小：\(progress.totalUnitCount/1024)KB")
                })
            }, onError: { (error) in
                print("上传失败！失败原因：\(error)")
            }, onCompleted: {
                print("上传完毕！")
            })
        .disposed(by: disposeBag)
        
        // (2) 下面我换种写法。将进度转成可观察序列，并绑定到进度条上显示
        
        // 将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, upLoadURL))
            .map{ request in
                // 返回一个关于进度的可观察序列
                Observable<Float>.create({ (observable)  in
                    request.uploadProgress(closure: { (progress) in
                        observable.onNext(Float(progress.fractionCompleted))
                        if progress.isFinished {
                            observable.onCompleted()
                        }
                    })
                    return Disposables.create()
                })
        }
        .flatMap{$0}
        .bind(to: progressView.rx.progress) // 将进度条绑定到UIProgressView上
        .disposed(by: disposeBag)
        
        /*
         4、上传MultipartFormData类型的文件数据(类似于网页上Form表单里的文件提交)
         */
        // (1)上传两个文件
        // 需要上传的文件
        let fileURL1 = Bundle.main.url(forResource: "0", withExtension: "png")
        let fileURL2 = Bundle.main.url(forResource: "1", withExtension: "png")
        
        // 服务器路径
        let upLoadURL1 = URL(string: "http://www.hangge.com/upload2.php")!
        
        // 将文件上传到服务器
        upload(multipartFormData: { (multipartForData) in
            multipartForData.append(fileURL1!, withName: "file1")
            multipartForData.append(fileURL2!, withName: "file2")
        }, to: upLoadURL1,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
        // (2) 文本参数与文件一起提交(文件除了可以使用fileURL，还可以上传Data类型的文件数据)
        // 字符串
        let strData = "hangge.com".data(using: String.Encoding.utf8)
        // 数字
        let intData = String(10).data(using: String.Encoding.utf8)
        // 文件1
        let path = Bundle.main.url(forResource: "0", withExtension: "png")
        let file1Data = try! Data(contentsOf: path!)
        // 文件2
        let file2URL = Bundle.main.url(forResource: "1", withExtension: "png")
        
        // 服务器路径
        let upLoadURL2 = URL(string: "http://www.hangge.com/upload2.php")!
        
        // 将文件上传到服务器
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(strData!, withName: "value1")
            multipartFormData.append(intData!, withName: "value2")
            multipartFormData.append(file1Data, withName: "file1", fileName: "php.png", mimeType: "image/png")
            multipartFormData.append(file2URL!, withName: "file2")
        }, to: upLoadURL2,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON { (response) in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
}
