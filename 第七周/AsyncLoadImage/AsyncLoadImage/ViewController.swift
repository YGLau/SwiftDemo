//
//  ViewController.swift
//  AsyncLoadImage
//
//  Created by 刘勇刚 on 03/12/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func click(_ sender: UIBarButtonItem) {
        let vc = CollectionViewController()
        navigationController!.pushViewController(vc, animated: true)
    }
    

}

