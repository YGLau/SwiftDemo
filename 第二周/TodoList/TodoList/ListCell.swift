//
//  ListCell.swift
//  TodoList
//
//  Created by 刘勇刚 on 27/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        imageView?.layer.cornerRadius = 68 * 0.5
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderWidth = 0.5
        imageView?.layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
