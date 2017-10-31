//
//  CollectionViewCell.swift
//  FirstDemo
//
//  Created by 刘勇刚 on 31/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont.systemFont(ofSize: 20)
    }

}
