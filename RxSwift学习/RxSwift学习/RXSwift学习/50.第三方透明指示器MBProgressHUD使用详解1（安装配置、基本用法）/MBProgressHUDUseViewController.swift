//
//  MBProgressHUDUseViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit

class MBProgressHUDUseViewController: UIViewController {

    // 提示框
    var hud:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         1、普通提示框
         (1)显示最简单的“菊花”的提示
         */
        // 初始化HUD窗口，并置于当前的View当中显示 菊花.png
        _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // (2)显示“纯文字”的显示 纯文字.png
        // 初始化HUD窗口，并置于当前的view当中显示
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        // 纯文本模式
        hud.mode = .text
        // 设置提示文字
        hud.label.text = "请稍等"
        
        // (3)显示“纯文字标题+详情”的提示
        //初始化HUD窗口，并置于当前的View当中显示
        let hud1 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud1.mode = .text
        // 设置提示标题
        hud1.label.text = "请稍等"
        // 设置提示详情
        hud1.detailsLabel.text = "具体要等多久我也不知道"
        
        // (4)显示“菊花+文字”的提示
        //初始化HUD窗口，并置于当前的View当中显示
        let hud2 = MBProgressHUD.showAdded(to: self.view, animated: true)
        // 设置提示文字
        hud2.label.text = "请稍等"
        
        // (5)显示“菊花+文字标题+详情”的提示
        //初始化HUD窗口，并置于当前的View当中显示
        let hud3 = MBProgressHUD.showAdded(to: self.view, animated: true)
        // 设置提示标题
        hud3.label.text = "请稍等"
        // 设置提示详情
        hud3.detailsLabel.text = "具体要等多久我也不知道"
        
        /*
         2、带进度的提示框
         (1)使用水平进度条
         */
        let hud4 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud4.mode = .determinateHorizontalBar // 显示水平进度条
        hud4.progress = 0.3 // 当前进度
        hud4.label.text = "当前进度：30%"
        
        // (2) 使用环形进度条
        let hud5 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud5.mode = .annularDeterminate // 显示环形进度条
        hud5.progress = 0.3 // 当前进度
        hud5.label.text = "当前进度：30%"
        
        // (3)使用饼状进度条
        let hud6 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud6.mode = .determinate // 显示饼状进度条
        hud6.progress = 0.3 // 当前进度
        hud6.label.text = "当前进度：30%"
        
        /*
         三、对提示框进行操作
         1、隐藏提示框
         (1)立刻隐藏
         */
        //初始化HUD窗口，并置于当前的View当中显示
        let hud7 = MBProgressHUD.showAdded(to: self.view, animated: true)
        // 立刻隐藏HUD窗口
        hud7.hide(animated: true)
        
        // (2) 延迟隐藏
        //初始化HUD窗口，并置于当前的View当中显示
        let hud8 = MBProgressHUD.showAdded(to: self.view, animated: true)
        // HUD窗口显示2秒后自动隐藏
        hud8.hide(animated: true, afterDelay: 2)
        
        // (3) 通过minShowTime属性可以设置最短显示时间(默认为0)。使用这个设置可以避免提示框后立刻被隐藏
        let hud9 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud9.label.text = "请稍等"
        hud9.minShowTime = 3 // 至少要等3秒钟才隐藏
        hud9.hide(animated: true) // 由于设置了minShowTime，所以还需要等3秒钟才隐藏
        
        /* (4) 通过animationType属性可以设置提示框消失动画，有如下三种可选值
         1).fade:逐渐透明消失(默认值)
         2).zoomOut:逐渐缩小并透明消失
         3).zoomIn:逐渐放大并透明消失
        */
        
        // (5) 通过removeFromSuperViewOnHide属性，可以设置提示框隐藏的时候是否从俯视图中移除(默认为false)
        let hud0 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud0.label.text = "请稍等"
        hud0.removeFromSuperViewOnHide = true // 隐藏时从俯视图中移除
        hud0.hide(animated: true, afterDelay: 2) // 2秒钟后自动隐藏
        
        /*
         2、添加点击手势
         下面样例给提示框添加个点击手势。当点击提示框后，提示框自动消失。当然在实际应用中，我们还可以在点击响应中进行一些其它操作，比如取消当前的网络请求等等。
         */
        // 初始化HUD窗口，并置于当前的View当中显示
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud?.label.text = "请稍等"
        
        // 添加单击手势
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(hudTapped))
        self.hud?.addGestureRecognizer(tapSingle)
        
    }
    
    // 提示框点击相应
    @objc func hudTapped() {
        self.hud?.hide(animated: true)
    }
}
