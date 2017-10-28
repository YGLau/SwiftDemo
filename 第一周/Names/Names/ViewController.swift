//
//  ViewController.swift
//  Names
//
//  Created by 刘勇刚 on 15/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataList = [[String]]()
    private var indexList = ["A", "B", "C", "D", "E"]
    
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        t.dataSource = self
        t.rowHeight = 44
        self.view.addSubview(t)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Names"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        // 读取数据
        if let path = Bundle.main.path(forResource: "names", ofType: "plist"),
            let arr = NSArray(contentsOfFile: path) as? [[String]] {
            dataList = arr;
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        let section = dataList[indexPath.section]
        cell?.textLabel?.text = section[indexPath.row]
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexList[section]
    }
    
    // 右边索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexList
    }
}

