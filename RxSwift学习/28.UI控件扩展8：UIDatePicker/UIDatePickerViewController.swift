//
//  UIDatePickerViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/26/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UIDatePickerViewController: UIViewController {

    let disposeBag = DisposeBag()
    var time = TimeInterval()
    // 日期格式化器
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()

    // 剩余时间(必须为60的整数倍，比如设置为100，值自动变为60)
    let leftTime = BehaviorRelay(value: TimeInterval(180))
    
    // 当前倒计时是否结束
    let countDownStopped = BehaviorRelay(value: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        /*
         八、UIDatePicker
         1、日期选择响应
         当日期选择器里面的时间改变之后，将时间格式化显示到label中
         */
        
        let ctimer = UIDatePicker()
        ctimer.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 500, width: UIScreen.main.bounds.size.width, height:500)
        self.view.addSubview(ctimer)
        
        let label = UILabel()
        label.backgroundColor = UIColor.cyan
        label.frame = CGRect(x: 10, y: 100, width: UIScreen.main.bounds.size.width - 20, height: 40)
        self.view.addSubview(label)
        
        
//        ctimer.rx.date
//            .map { [weak self] in
//                "当前时间：" + self!.dateFormatter.string(from: $0)
//        }
//        .bind(to: label.rx.text)
//        .disposed(by: disposeBag)
        
        
        /*
         2、倒计时功能
         通过上方的 datepicker 选择需要倒计时的时间后，点击“开始”按钮即可开始倒计时。
         倒计时过程中，datepicker 和按钮都不可用。且按钮标题变成显示倒计时剩余时间。
         
         高亮部分代码说明：
         <-> 是自定义的双向绑定符号，具体可以查看我之前的文章：Swift - RxSwift的使用详解27（双向绑定：<->）
         加 DispatchQueue.main.async 是为了解决第一次拨动表盘不触发值改变事件的问题（这个是 iOS 的 bug）
         */
        
        let btnstart = UIButton(type: .system)
        btnstart.frame = CGRect(x: 10, y: 150, width: UIScreen.main.bounds.size.width - 20, height: 40)
        btnstart.setTitle("点击", for: .normal)
        btnstart.setTitleColor(UIColor.black, for: .normal)
        btnstart.setTitleColor(UIColor.darkGray, for:.disabled)
        self.view.addSubview(btnstart)

        ctimer.datePickerMode = UIDatePicker.Mode.countDownTimer
        
        // 剩余时间与datepicker做双向绑定
        DispatchQueue.main.async {
            _ = ctimer.rx.countDownDuration <-> self.leftTime
        }
        
        // 绑定button标题
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) { leftTimeValue,countDownStoppedValue in
            // 根据当前的状态何止按钮的标题
            if countDownStoppedValue {
                return "开始"
            } else {
                return "倒计时开始，还有\(Int(leftTimeValue)) 秒..."
            }
        }
        .bind(to: btnstart.rx.title())
        .disposed(by: disposeBag)
        
        // 绑定button和datepicker状态(在倒计过程中，按钮和时间选择组件不可用)
        countDownStopped.asDriver().drive(ctimer.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(btnstart.rx.isEnabled).disposed(by: disposeBag)
        
        // 按钮点击响应
        btnstart.rx.tap
            .bind { [weak self] in
                self?.startClicked()
            }
        .disposed(by: disposeBag)
        
        
        
    }
    
    // 开始倒计时
    func startClicked() {
        // 开始倒计时
        self.countDownStopped.accept(false)
        
        // 创建一个计时器
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter { $0 }) // 倒计时结束时停止计时器
            .subscribe { event in
                // 每次剩余时间减1
                self.time -= 1
                self.leftTime.accept(TimeInterval(self.time))
                // 如果剩余时间小于等于0
                if (self.leftTime.value == 0) {
                    print("倒计时结束！")
                    // 结束倒计时
                    self.countDownStopped.accept(true)
                    // 重制时间
                    self.leftTime.accept(180)
                }
        }
        .disposed(by: disposeBag)
    }
}
