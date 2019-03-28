//
//  MBProgressHUDExtension.swift
//  RXSwift学习
//
//  Created by bdb on 3/28/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import Foundation

/*
 当成功、失败的提示显示后，经过 1 秒钟会自动隐藏消失。
 而普通消息提示和等待提示显示后不会自动取消，需要手动将其隐藏。
 */
extension MBProgressHUD {
    // 显示等待消息
    class func showWait(_ title:String) {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
    }
    
    // 显示普通消息
    class func showInfo(_ title: String) {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView // 模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "info")!) // 自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
    }
    
    // 显示成功消息
    class func showSuccess(_ title: String) {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView // 模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "tick")!) // 自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        // hud窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    // 显示失败消息
    class func showError(_ title:String) {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView // 模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "cross")!) // 自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        // hud窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    // 获取用于显示提示框的view
    class func viewToShow() -> UIView {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin;
                    break
                }
            }
        }
        return window!
    }
}

extension UIView {
    //显示等待消息
    func showWait(_ title: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
     }
    //显示普通消息
    func showInfo(_ title: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "info")!) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
    }
    
    //显示成功消息
    func showSuccess(_ title: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "tick")!) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    //显示失败消息
    func showError(_ title: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "cross")!) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
}
