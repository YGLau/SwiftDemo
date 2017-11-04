//
//  FlowLayout.swift
//  ThirdDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewLayout {
    
    // 保存cell的布局属性
    private var attrArr = [UICollectionViewLayoutAttributes]()
    // 保存当前列的高度
    private var columnHeightArr = [Int]()
    // 2列
    private let columns = 2
    
    override func prepare() {
        super.prepare()
        
        columnHeightArr.removeAll()
        for _ in 0 ..< columns {
            columnHeightArr.append(0)
        }
        
        attrArr.removeAll()
        
        let count = collectionView?.numberOfItems(inSection: 0)
        for i in 0 ..< count! {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = layoutAttributesForItem(at: indexPath)
            attrArr.append(attr!)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let collectionViewWidth = collectionView?.bounds.size.width
        // 设置每个Cell的大小
        let w = collectionViewWidth! / CGFloat(columns)
        let h = CGFloat(100 + arc4random_uniform(150))
        
        var destColumn = 0
        var minHeight = columnHeightArr[0]
        
        for i in 1 ..< columns {
            let height = columnHeightArr[i]
            if (minHeight > height) {
                minHeight = height
                destColumn = i
            }
        }
        
        let x = CGFloat(destColumn) * w
        let y: CGFloat = CGFloat(minHeight)
        attr.frame = CGRect(x: x, y: y, width: w, height: h)
        columnHeightArr[destColumn] = Int(attr.frame.maxY)
        
        return attr
    }
    
    override var collectionViewContentSize: CGSize {
        var maxColumnHeight = columnHeightArr[0]
        for i in 1 ..< columns {
           let height = columnHeightArr[i]
            if (maxColumnHeight < height) {
                maxColumnHeight = height
            }
        }
        
        return CGSize(width: 0, height: maxColumnHeight)
    }

}
