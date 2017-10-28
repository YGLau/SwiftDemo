//
//  DetailViewController.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // 为了图省事，就没有严格按照MVVM架构来
    
    open var person: Person?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var addr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let person = person {
            iconView.image = UIImage(named: person.icon)
            nameLabel.text = "\(person.name!)"
        }
    }

}
