//
//  ViewController.swift
//  ThirdDemo
//
//  Created by 刘勇刚 on 31/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var titles = ["推荐", "随听", "视频", "段子", "排行", "互动区", "网红", "多一个", "再多一个"]
    
    private static let titleCellId = "title"
    private static let contentCellId = "contentCellId"
    
    fileprivate var titlesCollection: UICollectionView!
    fileprivate var contentCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 44)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        titlesCollection = UICollectionView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 44), collectionViewLayout: layout)
        let n = UINib(nibName: "TitleViewCell", bundle: nil)
        titlesCollection.backgroundColor = .red
        titlesCollection.register(n, forCellWithReuseIdentifier: ViewController.titleCellId)
        titlesCollection.dataSource = self
        view.addSubview(titlesCollection)
        titlesCollection.reloadData()
        
        let flowLayout = FlowLayout()
        let frame = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64)
        contentCollection = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        contentCollection.backgroundColor = .white
        let nib = UINib(nibName: "ContentViewCell", bundle: nil)
        contentCollection.register(nib, forCellWithReuseIdentifier: ViewController.contentCellId)
        contentCollection.dataSource = self
        view.addSubview(contentCollection)
        contentCollection.reloadData()
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == titlesCollection ? titles.count : 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == titlesCollection) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.titleCellId, for: indexPath) as! TitleViewCell
            cell.titleLabel.text = "\(titles[indexPath.row])"
            cell.titleLabel.backgroundColor = .purple
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.contentCellId, for: indexPath) as! ContentViewCell
            cell.imageView.image = UIImage(named: "\(indexPath.row + 1).jpg")
            return cell
        }
    }
    
}

