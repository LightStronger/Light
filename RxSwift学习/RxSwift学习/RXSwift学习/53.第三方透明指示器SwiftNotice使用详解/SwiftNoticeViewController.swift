//
//  SwiftNoticeViewController.swift
//  RXSwift学习
//
//  Created by bdb on 3/28/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit

class SwiftNoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         （1）SwiftNotice 是一个使用纯 Swift 写的 HUD 库，该库提供多种类型的弹出窗口。
         （2）同时 SwiftNotice 可完美适配各种滚动视图（scrollview），并且支持 iPhone X。
         */
        
        /*
         我们可以直接调用 SwiftNotice 提供的类方法。
         */
        
        //显示等待提示框
        SwiftNotice.wait()
        
        // 显示等待提示框
        self.pleaseWait()
        
        // 由于 SwiftNotice 还对 UIResponder 进行了扩展，我们直接使用扩展方法也是可以的。
        
        // 纯文字显示
        SwiftNotice.showText("请稍等")
        
        self.noticeOnlyText("请稍等")
        
        // 默认情况下，文字提示显示 2 秒后会自动隐藏。我们可以通过参数修改显示时间，或者是否自动隐藏。
        // 显示后不自动隐藏
        SwiftNotice.showText("请稍等", autoClear: false)
        SwiftNotice.showText("请稍等", autoClearTime: 1)
        
        // 成功提示 ✔️
        SwiftNotice.showNoticeWithText(.success, text: "操作成功", autoClear: true, autoClearTime: 2)
        self.noticeSuccess("操作成功", autoClear: true, autoClearTime: 2)
        
        // 失败提示 ❌
        SwiftNotice.showNoticeWithText(.error, text: "操作失败", autoClear: true, autoClearTime: 2)
        self.noticeError("操作失败", autoClear: true, autoClearTime: 2)
        
        // 普通消息提示 !
        SwiftNotice.showNoticeWithText(.info, text: "普通消息", autoClear: true, autoClearTime: 2)
        self.noticeInfo("普通消息", autoClear: true , autoClearTime: 2)
        
        // 关闭提示框
        SwiftNotice.clear()
        self.clearAllNotice()
        
        // 三、高级功能
        // 1.顶部状态栏消息
        SwiftNotice.noticeOnStatusBar("这是一条通知消息", autoClear: true, autoClearTime: 2)
        
        self.noticeTop("这是一条通知消息", autoClear: true, autoClearTime: 2)
        
        // 2.播放图片动画
        // 准备好图片数组
        var images = [UIImage]()
        for i in 1..<74 {
            images.append(UIImage(named: "frame_apngframe\(i)")!)
        }
        
        SwiftNotice.wait(images, timeInterval: 50) //每隔50毫秒切换一张图片
        self.pleaseWaitWithImages(images, timeInterval: 50) //每隔50毫秒切换一张图片
    }
}
