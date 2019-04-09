//
//  GitHubAPI.swift
//  RXSwift学习
//
//  Created by bdb on 3/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import Foundation
import Moya
import RxMoya
// 初始化GitHub请求的provider
let GitHubProvider = MoyaProvider<GitHubAPI>()

/***************** 下面定义GitHub请求的endpoints(供provider使用) ********************/
// 请求分类
public enum GitHubAPI {
    case reposittories(String) // 查询资源库
}

// 请求配置
extension GitHubAPI: TargetType {

    // 服务器地址
    public var baseURL:baseURL {
        return URL(string: "https://api.github.com")!
    }
    
    // 各个请求的具体路径
    public var path:String {
        switch self {
        case .reposittories:
            return "/search/repositories"
        }
    }
    
    // 请求类型
    public var method:Moya.method {
        return .get
    }
    
    // 请求任务事件(这里附带上参数)
    public var task:Task {
        print("发起请求。")
        switch self {
        case .reposittories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            params["sort"] = "starts"
            params["order"] = "desc"
        return .requestParameters(parameters:params,endcoding:URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    // 是否执行Alamofire验证
    public var validate:Bool {
        return false
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData:Data {
        return "{}".data(using:String.Encoding.utf8)!
    }
    
    // 请求头
    public var headers: [String:String]? {
        return nil
    }
}
