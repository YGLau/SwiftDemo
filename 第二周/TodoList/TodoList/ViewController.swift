//
//  ViewController.swift
//  TodoList
//
//  Created by 刘勇刚 on 25/10/2017.
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
    
    /// done btn的点击回调
    public var doneBtnCallback: ((String, String, String) ->Void)?

    @IBAction func editClick(_ sender: UIBarButtonItem) {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // initial tableView
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(ListCell.self, forCellReuseIdentifier: ViewController.cellId)
        view.addSubview(tableView)
        
        doneBtnCallback = { [unowned self] (imageName, dateStr, text) -> Void in
            self.dataSource.append(["imageName": imageName, "date": dateStr, "text": text])
            self.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellId, for: indexPath) as! ListCell
        cell.imageView?.image = UIImage(named: dataSource[indexPath.row]["imageName"]!)
        cell.textLabel?.text = dataSource[indexPath.row]["text"]
        cell.detailTextLabel?.text = dataSource[indexPath.row]["date"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dataSource.remove(at: indexPath.row) // 删除数据
            tableView.deleteRows(at: [indexPath], with: .left) // 删除cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 移动cell
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceData = dataSource[sourceIndexPath.row]
        // 删除原来位置元素
        dataSource.remove(at: sourceIndexPath.row)
        // 插入新位置
        dataSource.insert(sourceData, at: destinationIndexPath.row)
    }
}
