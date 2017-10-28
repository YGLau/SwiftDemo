//
//  ContactCellVIewModel.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ContactCellVIewModel: NSObject {
    
    var person: Person!
    
    private var cell: ContactCell!
    
    open func bind(_ view: UIView) {
        cell = view as! ContactCell
        cell.iconView.image = UIImage(named: person.icon)
        cell.nameLabel.text = "\(person.name!)"
    }

}
