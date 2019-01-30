//
//  UICollectionViewStyleEditViewController.swift
//  RxSwift学习
//
//  Created by bdb on 1/30/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UICollectionViewStyleEditViewController: UIViewController {

    var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         四、相关样式的修改
         有时我们可能需要调整 collectionView 单元格尺寸、间距，或者修改 section 头尾视图尺寸等等。虽然 RxSwift 没有封装相关的方法，但我们仍然可以通过相关的代理方法来设置。
         */
        
        /*
         .不管屏幕尺寸如何，collectionView 每行总是固定显示 4 个单元格，即单元格的宽度随屏幕尺寸的变化而变化。
         .而单元格的高度为宽度的 1.5 倍。
         */
        
        // 定义布局方式
        let flowLayout = UICollectionViewFlowLayout()
        
        // 创建集合视图
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        
        // 创建一个重用的单元格
        self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView!)
        
        // 初始化数据
        let items = Observable.just([
            SectionModel(model: "", items: [
                "Swift",
                "PHP",
                "Python",
                "Java",
                "C++",
                "C#"
                ])
            ])
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,String>>(
        configureCell: {(dataSource,collectionView,indexPath,element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        // 绑定单元格数据
        items
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        // 设置代理
        collectionView.rx.setDelegate(self)
        .disposed(by: disposeBag)
    }
}

// collectionView的代理实现
extension UICollectionViewStyleEditViewController: UICollectionViewDelegateFlowLayout {
    
    // 设置单元格尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 4 // 每行显示4个单元格
        return CGSize(width: cellWidth, height: cellWidth * 1.5) // 单元格宽度为高度的1.5倍
    }
}
