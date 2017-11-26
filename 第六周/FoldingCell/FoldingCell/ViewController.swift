//
//  ViewController.swift
//  FoldingCell
//
//  Created by 刘勇刚 on 26/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    /// 关闭时cell的高度
    let kCloseCellHeight: CGFloat = 120
    /// 打开时cell的高度
    let kOpenCellHeight: CGFloat = 320
    /// cell数量
    let kRowsCount = 10
    /// 保存所有cell高度的数组
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        cellHeights = Array(repeatElement(kCloseCellHeight, count: kRowsCount))
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FoldingCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "cell")
    }
}

extension ViewController {
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kRowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations // 打开时长
        cell.durationsForCollapsedState = durations // 折叠时长
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed { // 折叠，所以打开
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else { // 打开，所以折叠
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        // 根据时长更新整个tableView的样式
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
        
//        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
}

