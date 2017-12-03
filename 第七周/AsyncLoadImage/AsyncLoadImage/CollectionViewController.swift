//
//  CollectionViewController.swift
//  AsyncLoadImage
//
//  Created by 刘勇刚 on 03/12/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    override func loadView() {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width - 30) * 0.5
        flowLayout.itemSize = CGSize(width: width, height: width)
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView!.backgroundColor = .lightGray
        collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 全局队列异步下载图片
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            sleep(UInt32(0.5)) // 模拟下载图片
            // 模拟主队列刷新图片
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                cell.backgroundColor = .yellow
            })
        }
        
    }
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }



}
