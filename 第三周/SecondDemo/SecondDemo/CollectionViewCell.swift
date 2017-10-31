//
//  CollectionViewCell.swift
//  SecondDemo
//
//  Created by 刘勇刚 on 31/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

}
