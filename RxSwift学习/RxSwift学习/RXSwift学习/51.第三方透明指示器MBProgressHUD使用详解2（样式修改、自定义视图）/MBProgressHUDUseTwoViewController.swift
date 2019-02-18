//
//  MBProgressHUDUseTwoViewController.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit

class MBProgressHUDUseTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         四、修改默认样式
         1、设置遮罩的背景色
         下面将提示框遮罩设置为黑色半透明(默认为透明的)
         */
        //初始化HUD窗口，并置于当前的View当中显示
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        /// 设置提示标题
        hud.label.text = "请稍等"
        // 设置遮罩为半透明黑色
        hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        /*
         2、设置毛玻璃效果的遮罩背景
         可以看到遮罩下方的控件都会有模糊效果
         毛玻璃遮罩.png
         */
        let hud1 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud1.label.text = "请稍等"
        hud1.backgroundView.style = .blur // 模糊的遮罩背景
        
        /*
         3、设置提示框背景色
         下面将提示框的背景色改成透明的。
         */
        let hud2 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud2.label.text = "请稍等"
        hud2.bezelView.color = UIColor.clear // 将提示框背景改成透明
        
        /*
         4、设置提示框圆角值
         提示框圆角值.png
         */
        let hud3 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud3.label.text = "请稍等"
        hud3.bezelView.layer.cornerRadius = 20.0 // 设置提示框圆角
        
        /*
         5、设置文字的颜色和字体
         文字的颜色和字体.png
         */
        let hud4 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud4.label.text = "请稍等"
        hud4.detailsLabel.text = "具体要等多久我也不知道"
        hud4.label.textColor = .orange // 标题文字颜色
        hud4.label.font = UIFont.systemFont(ofSize: 20) // 标题文字字体
        hud4.detailsLabel.textColor = .blue // 详情文字颜色
        hud4.detailsLabel.font = UIFont.systemFont(ofSize: 11) // 详情文字字体
        
        // 6、设置菊花颜色
        // 将菊花设置成橙色
        UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = .orange
        
        /*
         7、设置提示框偏移量
         即提示框相对于父视图中心点的偏移，正值为向右下偏移，负值为向左上偏移。
         提示框偏移量.png
         */
        let hud5 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud5.label.text = "请稍等"
        hud5.offset = CGPoint(x: -100, y: -150) // 向左偏移100，向上偏移150
        
        /*
         8、设置提示框内边距
         */
        let hud6 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud6.label.text = "请稍等"
        hud6.margin = 0 // 将各个元素与矩形边框的距离设为0
        
        /*
         9、设置提示框的最小尺寸
         提示框的最小尺寸.png
         */
        let hud7 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud7.label.text = "请稍等"
        hud7.minSize = CGSize(width: 250, height: 110) // 设置最小尺寸
        
        /*
         10、设置正方形提示框
         即强制提示框的宽度和高度相等
         */
        let hud8 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud8.label.text = "请稍等"
        hud8.isSquare = true // 正方形提示框
        
        /*
         五、自定义视图
         下面样例在提示框中显示一个“打勾”的图标。
         提示框中显示一个“打勾”的图标.png
         */
        //初始化HUD窗口，并置于当前的View当中显示
        let hud9 = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud9.mode = .customView // 模式设置为自定义视图
        hud9.customView = UIImageView(image: UIImage(named: "tick")!) // 自定义视图显示图片
        hud9.label.text = "操作成功"
    }
}
