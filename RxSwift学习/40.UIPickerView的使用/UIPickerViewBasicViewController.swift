//
//  UIPickerViewBasicViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UIPickerViewBasicViewController: UIViewController {

    var pickerView: UIPickerView!
    
    // 最简单的pickerView适配器(显示普通文本) 单列的
    // 单列的UIPickerView.png
    private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: {_,_,_ in 1},
        numberOfRowsInComponent: { (_,_, items,_) -> Int in
            return items.count
    }, titleForRow: {(_,_, items,row,_) -> String? in
        return items[row]
    })

    // 多列的pickerView 多列UIPickerView.png
    private let stringPickerAdapterMuch = RxPickerViewStringAdapter<[[String]]>(
        components: [], numberOfComponents: { (datasource, pickerView, components) in components.count
    }, numberOfRowsInComponent: { (_,_,components, component) -> Int in
        return components[component].count
    }) { (_, _, components, row, component) -> String? in
        return components[component][row]
    }
//    private let string = RxPickerViewStringAdapter<[[String]]>(
//        components: <#T##[[String]]#>, numberOfComponents: { (<#RxPickerViewDataSource<[[String]]>#>, <#UIPickerView#>, <#[[String]]#>) -> Int in
//            <#code#>
//    }, numberOfRowsInComponent: { (<#RxPickerViewDataSource<[[String]]>#>, <#UIPickerView#>, <#[[String]]#>, <#Int#>) -> Int in
//        <#code#>
//    }) { (<#RxPickerViewStringAdapter<[[String]]>#>, <#UIPickerView#>, <#[[String]]#>, <#Int#>, <#Int#>) -> String? in
//        <#code#>
//    }
    
    
    // 修改默认的样式
    private let attrStringPickerAdapter = RxPickerViewAttributedStringAdapter<[String]>(
        components: [], numberOfComponents: {_,_,_ in 1}, numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count
    }) { (_, _, items, row, _) -> NSAttributedString? in
        return NSAttributedString(string: items[row],
            
        attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.orange, // 橙色文字
            NSAttributedString.Key.underlineStyle:
                NSUnderlineStyle.double.rawValue, // 双下划线
            NSAttributedString.Key.textEffect:
            NSAttributedString.TextEffectStyle.letterpressStyle
        ])
    }
    
    // 设置自定义视图的pickerView适配器
    private let viewPickerAdapter = RxPickerViewViewAdapter<[UIColor]>(
        components: [], numberOfComponents: {_,_,_ in 1}, numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count
    }) { (_, _, items, row, _, view) -> UIView in
        let componentView = view ?? UIView()
        componentView.backgroundColor = items[row]
        return componentView
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.cyan
        /*
         一、UIPickerView的使用
         基本用法
         */
        
        /*
         (1)单列情况
         */
        // 创建pickerView
        pickerView = UIPickerView()
        self.view.addSubview(pickerView)
        
        // 绑定pickerView数据
        Observable.just(["one","Two","Three"])
        .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
        .disposed(by: disposeBag)
        
        // 建立一个按钮，触摸按钮时获得选择框被选择的索引
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.center = self.view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息", for: .normal)
        
        // 按钮点击响应
        button.rx.tap
            .bind{ [ weak self] in
                self?.getPickerViewValue()
        }
        .disposed(by: disposeBag)
        self.view.addSubview(button)
    
        /*
         (2)多列的情况
         */
        // 绑定pickerView数据
        Observable.just([
            ["One","Two","Three"],
            ["A","B","C","D"]
            ])
        .bind(to: pickerView.rx.items(adapter: stringPickerAdapterMuch))
        .disposed(by: disposeBag)
        // 其余步骤与上面雷同
        
        
        /*
         3、修改默认的样式
         修改默认的样式UIPickerView.png
         (1)将选项的文字修改成橙色，同时在文字下方加上下划线
         (2)要实现这个效果，只需要改用RxPickerViewAttributedStringAdapter这个可以设置文字属性的适配器即可
         */
        
        // 绑定pickerView数据
        Observable.just(["One","Two","Three"])
        .bind(to: pickerView.rx.items(adapter: attrStringPickerAdapter))
        .disposed(by: disposeBag)
        
        /*
         4、使用自定义视图
         （1）我们将选项视图改成单纯显示颜色色块的 view，其颜色由传入的值决定。
         （2）要实现这个效果，只需改用 RxPickerViewViewAdapter 这个可以返回自定义视图的适配器即可。
         自定义UIPickerView.png
         */
        
        // 绑定pickerView数据
        Observable.just([UIColor.red,UIColor.orange,UIColor.yellow])
        .bind(to: pickerView.rx.items(adapter: viewPickerAdapter))
        .disposed(by: disposeBag)
    }
    
    // 触摸按钮时，获得被选中的索引
    @objc func getPickerViewValue(){
        let message = String(pickerView.selectedRow(inComponent: 0))
        let alertController = UIAlertController(title: "被选中的索引为", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
