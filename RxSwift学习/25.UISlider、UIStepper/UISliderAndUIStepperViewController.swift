//
//  UISliderAndUIStepperViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/25/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UISliderAndUIStepperViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // 六、UISlider、UIStepper
        /*
         1、UISlider(滑块)
         当我们拖动滑块时，在控制台中实时输出 slider 当前值。

         */
        let slider = UISlider()
        slider.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        self.view.addSubview(slider)
        slider.rx.value.asObservable()
            .subscribe(onNext: {
                print("当前值为：\($0)")
            })
            .disposed(by: disposeBag)
        
        /*
         2、UIStepper(步进器)
         在控制台中实时输出当前值。
         使用滑块（stepper）来控制 slider 的步长。
         */
        let stepper = UIStepper()
        stepper.frame = CGRect(x: 100, y: 150, width: 100, height: 30)
        self.view.addSubview(stepper)
        
        stepper.rx.value.asObservable()
            .subscribe(onNext: {
                print("当前值为：\($0)")
            })
//            .map { Float($0)}
//            .bind(to: slider.rx.value) 使用滑块（stepper）来控制 slider 的步长。
            .disposed(by: disposeBag)
        
        
    }
}
