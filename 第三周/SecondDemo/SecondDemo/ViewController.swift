//
//  ViewController.swift
//  SecondDemo
//
//  Created by 刘勇刚 on 31/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate static let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
        title = "CollectionView"
        
        let layout = UICollectionViewFlowLayout()
        let w = UIScreen.main.bounds.size.width * 0.5 - 10
        layout.itemSize = CGSize(width: w, height: w)
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ViewController.cellId)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath) as! CollectionViewCell
        let index = indexPath.row + 1
        cell.imageView.image = UIImage(named: "\(index).jpg")
        return cell
    }
}
