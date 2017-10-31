//
//  ViewController.swift
//  FirstDemo
//
//  Created by 刘勇刚 on 31/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private static let cellId = "cellId"
    /// 分页控件
    fileprivate var pageCon: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        let rect = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 250)
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ViewController.cellId)
        collectionView.backgroundColor = .blue
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let pageControl = UIPageControl()
        pageControl.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pageControl.layer.position = CGPoint(x: collectionView.bounds.size.width * 0.5, y: 100 + collectionView.bounds.size.height + 10)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2 /// 这里是写死的一个数据，在不同屏幕尺寸下显示会有点小问题，看效果就好~ :]
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .gray
        view.addSubview(pageControl)
        pageCon = pageControl
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .red
        cell.label.text = "\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / UIScreen.main.bounds.size.width
        pageCon.currentPage = Int(index)
    }
}
