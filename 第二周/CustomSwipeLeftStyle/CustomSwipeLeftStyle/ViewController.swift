//
//  ViewController.swift
//  CustomSwipeLeftStyle
//
//  Created by 刘勇刚 on 28/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// tableView
    private var tableView: UITableView!
    /// cell标识ID
    private static let cellId = "cellId"
    /// 数据
    private var dataSource = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial tableView
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.cellId)
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellId, for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
    // make tableView cell can be edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "删除") { (action, indexPath) in
            print("toggle 删除 action and do something.")
        }
        delete.backgroundColor = .blue
        let share = UITableViewRowAction(style: .default, title: "分享") { (action, indexPath) in
            print("toggle 分享 action and do something.")
        }
        share.backgroundColor = .purple
        let post = UITableViewRowAction(style: .destructive, title: "发送") { (action, indexPath) in
            print("toggle 发送 action and do something.")
        }
        post.backgroundColor = .red
        return [delete, share, post]
    }
    
}
