//
//  ViewController.swift
//  Landscape
//
//  Created by 刘勇刚 on 25/10/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate static let cellId = "cellId"
    
    fileprivate let dataSource = ["l1", "l2", "l3", "l4", "l5", "l6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIImageView(frame: UIScreen.main.bounds)
        bgView.image = UIImage(named: "bg.jpg")
        view.addSubview(bgView)
        
        let blur = UIVisualEffectView(frame: bgView.bounds)
        blur.effect = UIBlurEffect(style: .regular)
        blur.alpha = 0.8
        view.addSubview(blur)
        
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: 180, height: 280)
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: view.bounds.size.width, height: 300), collectionViewLayout: flow)
        collectionView.register(LandscapeCell.self, forCellWithReuseIdentifier: ViewController.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath) as! LandscapeCell
        cell.image = dataSource[indexPath.row]
        return cell
    }
}
