//
//  GitHubRepositories.swift
//  RXSwift学习
//
//  Created by bdb on 4/9/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import ObjectMapper

// （2）接着定义好相关模型：GitHubModel.swift（需要实现 ObjectMapper 的 Mappable 协议，并设置好成员对象与 JSON 属性的相互映射关系。）
// 包含查询返回的所有库模型
struct GitHubRepositories: Mappable {

    var totalCount: Int!
    var incompleteResults:Bool!
    var items:[GitHubRepository]!// 本次查询返回的所有仓库集合
    
    init() {
        print("init()")
        totalCount = 0
        incompleteResults = false
        items = []
    }
    
    init?(map:Map) {}
    
    // Mappabble
    mutating func mapping(map:Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}

// 单个仓库模型
struct GitHubRepository:Mappable {
    var id:Int!
    var name:String!
    var fullName:String!
    var htmlUrl:String!
    var description:String!
    
    init?(map:Map) { }
    
    // Mappable
    mutating func mapping(map:Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        htmlUrl <- map["html_url"]
        description <- map["description"]
    }
}
