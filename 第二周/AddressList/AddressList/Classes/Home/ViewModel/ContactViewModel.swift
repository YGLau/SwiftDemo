//
//  ContactViewModel.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ContactViewModel: NSObject {
    
    // 模型数据
    private var listArr = [Item]()
    
    private var cellViewModel = [ContactCellVIewModel]()
    
    public var navVc: UINavigationController?
    
    // cellID
    private static let cellId = "cellId"
    
    fileprivate(set) lazy var tableView: UITableView = {
        let t = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.rowHeight = 70
        return t
    }()
    
    override init() {
        super.init()
        tableView.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: ContactViewModel.cellId)
        // 初始化数据
        if let filePath = Bundle.main.path(forResource: "list", ofType: "plist"),
        let arr = NSArray(contentsOfFile: filePath) {
            for item in arr {
                let model = Item(dict: item as! [String: Any])
                listArr.append(model)
            }
        }
    }

}
//MARK: UITableVIewDelegate && UITableViewDataSource
extension ContactViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr[section].listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactViewModel.cellId) as! ContactCell
        let item = listArr[indexPath.section]
        let cellViewModel = item.listArr[indexPath.row]
        cellViewModel.bind(cell)
        return cell
    }
    
    // cell 点击跳转详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVc.person = listArr[indexPath.section].listArr[indexPath.row].person
        navVc?.pushViewController(detailVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return listArr[section].title
    }
}

