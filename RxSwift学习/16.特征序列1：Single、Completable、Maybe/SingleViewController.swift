//
//  SingleViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/9/19.
//  Copyright © 2019 fulihao. All rights reserved.
//
public enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
}

import UIKit
import RxSwift
import RxCocoa

class SingleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposeBag = DisposeBag()
        
        /*
         通过之前的一系列文章，关于可被观察的序列（Observable）我们应该都了解的查不多了。 除了 Observable，RxSwift 还为我们提供了一些特征序列（Traits）：Single、Completable、Maybe、Driver、ControlEvent。
         
         我们可以将这些 Traits 看作是 Observable 的另外一个版本。它们之间的区别是：
         .Observable是能够用于任何上下文环境的通用序列
         .而Traits可以帮助我们更准确的描述序列。同时它们还为我们提供上下文含义、语法糖，让我们能够用更加优雅的方式书写代码
         */
        
        
        /*
         一、Single
         1.基本介绍
         Single是Observable的另外一个版本。但它不像Observable可以发出多个元素，它要么只能发出一个元素，要么产生一个error事件
         .发出一个元素，或一个error事件
         .不会共享状态变化
         
         2.应用场景
         Single比较常见的例子就是执行HTTP请求，然后返回一个应答或错误。不过我们也可以用Single来描述任何只有一个元素的序列
         
         3.SingleEvent
         为了方便使用，RxSwift还为Single订阅提供了一个枚举(SingleEvent)
         （1）.success:里面包含该Single的一个元素值
         （2）.error:用于包含错误
         enum DataError: Error {
         case cantParseJSON
         }

         */
        
        
        /*
         4、使用样例
         (1)创建Single和创建Observable非常相似，下面代码我们定义一个用于生成网络请求Single的函数
         
         (2) 接着调用getPlayList
         */
        // 获取第0个频道的歌曲信息
        getPlayList("0")
            .subscribe { (event) in
                switch event {
                case .success(let json):
                    print("JSON结果：",json)
                case .error(let error):
                    print("发生错误：",error)
                }
        }
        .disposed(by: disposeBag)
        
        // (3) 也可以用subscribe(onSuccess:onError:)这种方式
        getPlayList("0")
            .subscribe(onSuccess: { (json) in
                print("JSON结果：",json)
            }, onError: { error in
                print("发生错误：",error)
            })
            .disposed(by: disposeBag)
        
        /*
         5、asSingle()
         (1)我们可以调用Observable序列.asSIngle()方法，将它转换为Single
         */
        Observable.of("1")
        .asSingle()
        .subscribe({ print($0)})
        .disposed(by: disposeBag)
        /*打印
         success("1")
         */
        
        /*
         二、Completable
         1、基本介绍
         Completable是Observable的另外一个版本。不像Observable可以发出多个元素，他要么只能产生一个completed事件，要么产生一个error事件
         .不会发出任何元素
         .只会发出一个completed事件或者一个error事件
         .不会共享状态变化
         
         2、应用场景
         Completable和Observable<Void>有点类似。适用于那些只关心任务是否完成，而不是需要在意任务返回值的情况。比如：在程序退出时将一些数据缓存到本地文件，供下次启动时加载，像这种情况我们只关心缓存是否成功
         
         3、CompletableEvent
         为了方便使用，RxSwift为Completable订阅提供了一个枚举(CompletableEvent)
         (1).completed:用于产生完成事件
         (2).error:用于产生一个错误
         public enum CompletableEvent {
                 case error(Swift.Error)
                 case completed
         }
         4、使用样例
         */
        
    }
}

// (1)创建Single和创建Observable非常相似，下面代码我们定义一个用于生成网络请求Single的函数
func getPlayList(_ channel: String) -> Single<[String:Any]> {
    return Single<[String: Any]>.create{ (single) in
        let url = "https://douban.fm/j/mine/playlist?" + "type=n&channel=\(channel)&from=mainsite"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data,_,error in
            if let error = error {
                single(.error(error))
                return
            }
            guard let data = data,
                let json = try?JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                let result = json as? [String: Any] else {
                    single(.error(DataError.cantParseJSON))
                    return
            }
            single(.success(result))
        }
        task.resume()
        return Disposables.create { task.cancel()}
    }
}

// 与数据相关的错误类型
enum DataError: Error {
    case cantParseJSON
}


// CompletableEvent
public enum CompletableEvent {
    case error(Swift.Error)
    case completed
}
