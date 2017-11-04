//
//  ViewController.swift
//  FiveDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let transitionDelegate = TransitionDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokemon"
        
        let n = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(n, forCellWithReuseIdentifier: "cell")
        
        let popPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ViewController.handlePop(_:)))
        popPan.edges = .left
        navigationController?.view.addGestureRecognizer(popPan)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.delegate = self
    }
    
    @objc func handlePop(_ pop: UIScreenEdgePanGestureRecognizer) {
        var progress = pop.translation(in: navigationController!.view).x / navigationController!.view.bounds.size.width
        
        progress = min(1.0, max(0.0, progress))
        
        if pop.state == .began {
            transitionDelegate.interactivePopTransition = UIPercentDrivenInteractiveTransition()
        } else if pop.state == .changed {
            transitionDelegate.interactivePopTransition!.update(progress)
            //TODO: 在这里进行缩放，不想研究了
        } else if pop.state == .ended || pop.state == .cancelled {
            if progress > 0.5 {
                transitionDelegate.interactivePopTransition.finish()
                navigationController!.popViewController(animated: true)
            } else {
                transitionDelegate.interactivePopTransition.cancel()
            }
            transitionDelegate.interactivePopTransition = nil
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: "\(indexPath.row + 1).jpg")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        transitionDelegate.selectedCell = selectedCell // 记录当前cell
        let vc = SecondViewController()
        vc.imageName = "\(indexPath.row + 1).jpg"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionDelegate.navigationOperation = operation
        return transitionDelegate;
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if transitionDelegate.interactivePopTransition == nil {
            return nil
        }
        return transitionDelegate.interactivePopTransition
    }
}
