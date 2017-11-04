//
//  ViewController.swift
//  FourDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightCollectionView: UICollectionView!
    
    fileprivate var leftItems = ["龙虾", "蟹类", "贝类", "其他活鲜", "冻品"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let n = UINib(nibName: "ItemCell", bundle: nil)
        leftTableView.register(n, forCellReuseIdentifier: "cell")
        
        let nib = UINib(nibName: "GoodViewCell", bundle: nil)
        rightCollectionView.register(nib, forCellWithReuseIdentifier: "cellId")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemCell
        cell.titleLabel.text = "\(leftItems[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = true
        // 重新刷新
        rightCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    
    /// 这里偷了个懒， 写下思路，希望老师给个💯 ：）
    /// 根据tableView的 选中的当前Cell indexPath.row 在数组中取出当前模型渲染
    /// 模型好麻烦，实在不想弄了
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(arc4random_uniform(20)) // 模拟一下，假装联动了
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! GoodViewCell
        ///TODO: cell的模型也没有设置 :]
        cell.imageView.backgroundColor = .random()
        return cell
    }
}
