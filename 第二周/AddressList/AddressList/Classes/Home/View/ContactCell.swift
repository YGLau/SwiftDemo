//
//  ContactCell.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        iconView.layer.cornerRadius = 41.5 * 0.5
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 0.5
        iconView.layer.borderColor = UIColor.black.cgColor
    }
    
}
