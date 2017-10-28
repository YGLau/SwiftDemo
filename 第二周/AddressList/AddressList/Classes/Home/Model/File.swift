//
//  File.swift
//  AddressList
//
//  Created by 刘勇刚 on 24/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import Foundation

// 因为是本地数据，所以保证一定有值，省去可选解包
struct Item {
    /// 分组标题
    var title: String!
    /// 改组中联系人
    var listArr = [ContactCellVIewModel]()
    
    init(dict: [String: Any]) {
        title = dict["title"] as! String
        let arr = dict["contact"] as! [[String: String]]
        for item in arr {
            let person = Person(dict: item)
            let cellVM = ContactCellVIewModel()
            cellVM.person = person
            listArr.append(cellVM)
        }
    }
}

struct Person {
    /// 名字
    var name: String!
    /// 头像
    var icon: String!
    // 手机号
    var phone: String!
    // 邮箱
    var email: String!
    // 地址
    var address: String!
    
    init(dict: [String: Any]) {
        if let i = dict["avatar"] as? String {
            icon = i
        }
        if let n = dict["name"] as? String {
            name = n
        }
        
        if let p = dict["phone"] as? String {
            phone = p
        }
        
        if let e = dict["email"] as? String {
            email = e
        }
        if let a = dict["address"] as? String {
            address = a
        }
    }
}
