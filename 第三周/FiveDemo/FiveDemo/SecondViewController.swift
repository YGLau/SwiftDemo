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
    // 定义为open是为了在外面获取，这样其实违背了封装原则 :(
    open var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        if let image = imageName {
            imageView.image = UIImage(named: image)
        }
    }
    

}
