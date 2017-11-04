//
//  UIColor.swift
//  FourDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1.0)
    }
}
