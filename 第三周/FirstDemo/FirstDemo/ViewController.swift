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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 20
        let rect = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 250)
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.cellId)
        collectionView.backgroundColor = .blue
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
        cell.label.text = "\(indexPath.row)"
        return cell
    }
}
