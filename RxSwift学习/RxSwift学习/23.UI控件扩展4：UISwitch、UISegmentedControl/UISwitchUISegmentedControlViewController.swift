//
//  UISwitchUISegmentedControlViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/21/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UISwitchUISegmentedControlViewController: UIViewController {

    let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // 四、UISwitch与UISegmentedControl 这两个控件的用法其实差不多。
        /*
         1、UISwitch(开关按钮)
         (1)假设我们想实现当switch开关状态改变时，输出当前值
         
         (2)下面样例当我们切换switch开关时，button会在可用和不可用的状态间切换
         */
        let switch1 = UISwitch()
        switch1.frame = CGRect(x: 100, y: 100, width: 80, height: 40)
        self.view.addSubview(switch1)
        
        let button1 = UIButton()
        button1.frame = CGRect(x: 100, y: 150, width: 80, height: 40)
        button1.setTitle("按钮", for: .normal)
        self.view.addSubview(button1)
        // (1)
        switch1.rx.isOn.asObservable()
            .subscribe(onNext: {
                print("当前开关状态：\($0)")
            })
            .disposed(by: disposBag)
        // (2)
        switch1.rx.isOn
        .bind(to: button1.rx.isEnabled)
        .disposed(by: disposBag)
        
        /*
         2、UISegmentedControl（分段选择控件）
         （1）我们想实现当 UISegmentedControl 选中项改变时，输出当前选中项索引值。
         （2）下面样例当 segmentedControl 选项改变时，imageView 会自动显示相应的图片。
         */
        
        let items = ["选项一","选项二","选项三"]
        let segmented = UISegmentedControl(items: items)
        segmented.frame = CGRect(x: 100, y: 200, width: 300, height: 40)
        segmented.selectedSegmentIndex = 0 // 默认选中第二项
        self.view.addSubview(segmented)
        segmented.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext:{
                print("当前项:\($0)")
            })
            .disposed(by: disposBag)
        
        let imageV = UIImageView()
        imageV.frame = CGRect(x: 100, y: 260, width: 100, height: 100)
        self.view.addSubview(imageV)
        
        // 创建一个当前需要显示的图片的可观察序列
        let showImageObservable: Observable<UIImage> = segmented.rx.selectedSegmentIndex.asObservable().map {
            let images = ["聊天室","刷新","pic"]
            return UIImage(named: images[$0])!
        }
        
        // 把需要显示的图片绑定到imageView上
        showImageObservable.bind(to: imageV.rx.image)
        .disposed(by: disposBag)
        

    }
}
