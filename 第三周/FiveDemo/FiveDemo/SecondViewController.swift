//
//  SecondViewController.swift
//  FiveDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    open var imageName: String?

    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imageName {
            imageView.image = UIImage(named: image)
        }
    }
    

}
