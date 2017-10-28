//
//  LandscapeCell.swift
//  Landscape
//
//  Created by 刘勇刚 on 25/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class LandscapeCell: UICollectionViewCell {
    
    // 图片名称
    var image: String! {
        didSet {
            imageView.image = UIImage(named: image)
        }
    }
    
    // cell图片
    private var imageView: UIImageView!
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: contentView.bounds)
        contentView.addSubview(imageView)
        
        // TODO: 下面的文字就不加 =.=
        /// 假定这里有一个label :]
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
