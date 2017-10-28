//
//  ViewController.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var tableViewVM: ContactViewModel = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .blue
        
        // 添加 && 刷新
        view.addSubview(tableViewVM.tableView)
        tableViewVM.tableView.reloadData()
        // 记录当前NavVc
        tableViewVM.navVc = navigationController
    }

}

