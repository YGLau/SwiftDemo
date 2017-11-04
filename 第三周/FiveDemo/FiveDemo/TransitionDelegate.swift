//
//  TransitionDelegate.swift
//  FiveDemo
//
//  Created by 刘勇刚 on 04/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionCtx: UIViewControllerContextTransitioning!
    
    open var navigationOperation: UINavigationControllerOperation!
    
    open var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    // 选中的cell
    open var selectedCell: CollectionViewCell!
    // 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // 动画过程
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionCtx = transitionContext
        
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc = transitionContext.viewController(forKey: .to)
        let container = transitionContext.containerView
        
        var detailVC: SecondViewController!
        var fromView: UIView!
        var alpha: CGFloat = 1.0
        var destTransform: CGAffineTransform!
        var snapshotImageView: UIView!

        let originalView = selectedCell
        
        if navigationOperation == .push {
            
            container.insertSubview(toVc!.view, aboveSubview: fromVc!.view)
            snapshotImageView = originalView?.snapshotView(afterScreenUpdates: false)
            detailVC = toVc as! SecondViewController
            fromView = fromVc!.view
            alpha = 0
            detailVC.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            destTransform = CGAffineTransform(scaleX: 1, y: 1)
            snapshotImageView.frame = originalView!.frame
            
        } else if navigationOperation == .pop {
            
            container.insertSubview(toVc!.view, belowSubview: fromVc!.view)
            detailVC = fromVc as! SecondViewController
            snapshotImageView = detailVC.imageView?.snapshotView(afterScreenUpdates: false)
            fromView = toVc!.view
            destTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            snapshotImageView.frame = detailVC.imageView!.frame
        }
        
        originalView?.isHidden = true
        detailVC.imageView?.isHidden = true
        
        container.addSubview(snapshotImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            detailVC.view.transform = destTransform
            fromView.alpha = alpha
            if self.navigationOperation == .push {
                snapshotImageView.frame = detailVC.imageView!.frame
            } else if self.navigationOperation == .pop {
                snapshotImageView.frame = originalView!.frame
            }
        }, completion: ({completed in
            originalView?.isHidden = false
            detailVC.imageView?.isHidden = false
            snapshotImageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }))
        
    }

}
