//
//  CollectionViewCell.swift
//  AsyncLoadImage
//
//  Created by 刘勇刚 on 03/12/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
