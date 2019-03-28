//
//  MbExtensionViewController.swift
//  RXSwift学习
//
//  Created by bdb on 3/28/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit

class MbExtensionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 显示成功消息
        MBProgressHUD.showSuccess("操作成功")
        // 显示失败消息
        MBProgressHUD.showError("操作失败")
        // 显示普通消息
        MBProgressHUD.showInfo("这是普通提示消息")
        // 显示等待消息
        MBProgressHUD.showWait("请稍等")
        
        //显示成功消息
        self.view.showSuccess("操作成功")
        //显示失败消息
        self.view.showError("操作失败")
        //显示普通消息
        self.view.showInfo("这是普通提示消息")
        //显示等待消息
        self.view.showWait("请稍等")
    }
}
