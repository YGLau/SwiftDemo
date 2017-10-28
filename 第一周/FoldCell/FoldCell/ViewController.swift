//
//  ViewController.swift
//  FoldCell
//
//  Created by 刘勇刚 on 15/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var close = [Bool]()
    
    private var zhouArr = ["亚洲", "北美洲", "非洲"]
    private var dataList: [[String]] = [
        [
            "中国",
            "日本",
            "卡塔尔"
        ],
        [
            "美国",
            "加拿大"
        ],
        [
            "不丹",
            "刚果"
        ]
    ]
    
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        t.dataSource = self
        t.delegate = self
        t.rowHeight = 44
        self.view.addSubview(t)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if let filePath = Bundle.main.path(forResource: "Area", ofType: "plist"),
//            let arr = NSArray(contentsOfFile: filePath) {
//        }
        
        for _ in 0 ..< 3 {
            close.append(true)
        }
        
        title = "FoldCell"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
    }


}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (close[section]) {
            return 0
        }
        return dataList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        let country = dataList[indexPath.section]
        cell?.textLabel?.text = country[indexPath.row]
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ctrView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        ctrView.tag = section
        ctrView.backgroundColor = .lightGray
        
        let btn = UIButton(type: .custom)
        btn.tag = section
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.layer.anchorPoint = CGPoint(x: 1.0, y: 0)
        btn.layer.position = CGPoint(x: UIScreen.main.bounds.width - 30, y: 10)
        btn.addTarget(self, action: #selector(foldCell), for: .touchUpInside)
        if close[section] == true {
            btn.setTitle( "+", for: .normal)
        } else {
            btn.setTitle( "-", for: .normal)
        }
        ctrView.addSubview(btn)
        
        let l = UILabel(frame: CGRect(x: 10, y: 4, width: 70, height: 30))
        l.textColor = UIColor(red: 1.0, green: 0.98, blue: 0.99, alpha: 1.0)
        l.font = UIFont.systemFont(ofSize: 17)
        l.text = zhouArr[section]
        ctrView.addSubview(l)
        
        return ctrView
    }
    
    @objc func foldCell(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        // 获取组
        let i = btn.tag;
        // 取反
        close[i] = !close[i]
        // 刷新
        let index = IndexSet.init(integer: i)
        tableView .reloadSections(index, with: .automatic)
    }
}
