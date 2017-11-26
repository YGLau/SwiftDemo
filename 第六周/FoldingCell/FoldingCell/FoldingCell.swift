//
//  FoldingCell.swift
//  FoldingCell
//
//  Created by 刘勇刚 on 26/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class FoldingCell: UITableViewCell {
    /// 折叠时展示的cell
    @IBOutlet weak var foregroundView: RotatedView!
    @IBOutlet weak var foregroundViewTop: NSLayoutConstraint!
    /// 展开时展示的cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    var animationView: UIView?
    
    ///  可折叠的cell的个数  默认2 [这个在xib做了设置为4个]
    @IBInspectable open var itemCount: NSInteger = 2
    open var backViewColor: UIColor = .brown
    
    var animationItemViews: [RotatedView]?
    /// cell的展开状态 枚举
    public enum AnimationType {
        case open
        case close
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        backgroundColor = .clear
        commonInit()
    }
    
    open func commonInit() {
        configureDefaultState()
        selectionStyle = .none
        containerView.layer.cornerRadius = foregroundView.layer.cornerRadius
        containerView.layer.masksToBounds = true
    }
    
    func configureDefaultState() {
        
        guard let foregroundViewTop = self.foregroundViewTop,
            let containerViewTop = self.containerViewTop else {
                fatalError("set constratins outlets")
        }
        
        containerViewTop.constant = foregroundViewTop.constant
        containerView.alpha = 0
        
        if let height = (foregroundView.constraints.filter { $0.firstAttribute == .height && $0.secondItem == nil}).first?.constant {
            foregroundView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            foregroundViewTop.constant += height / 2
        }
        foregroundView.layer.transform = foregroundView.transform3d()
        
        createAnimationView()
        self.contentView.bringSubview(toFront: foregroundView)
    }
    
    func configureAnimationItems(_ animationType: AnimationType) {
        
        guard let animationViewSuperView = animationView?.subviews else {
            fatalError()
        }
        
        if animationType == .open {
            for view in animationViewSuperView.filter({$0 is RotatedView}) {
                view.alpha = 0;
            }
        } else {
            for case let view as RotatedView in animationViewSuperView.filter({$0 is RotatedView}) {
                if animationType == .open {
                    view.alpha = 0
                } else {
                    view.alpha = 1
                    view.backView?.alpha = 0
                }
            }
        }
    }
    
    func createAnimationView() {
        animationView = UIView(frame: containerView.frame)
        animationView?.layer.cornerRadius = foregroundView.layer.cornerRadius
        animationView?.backgroundColor = .clear
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.alpha = 0
        
        guard let animationView = self.animationView else { return }
        
        contentView.addSubview(animationView)
        
        // copy constraints from containerView
        var newConstraints = [NSLayoutConstraint]()
        for constraint in self.contentView.constraints {
            if let item = constraint.firstItem as? UIView , item == containerView {
                let newConstraint = NSLayoutConstraint( item: animationView, attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier, constant: constraint.constant)
                
                newConstraints.append(newConstraint)
            } else if let firstItem = constraint.firstItem as? UIView, let secondItem: UIView = constraint.secondItem as? UIView , secondItem == containerView {
                let newConstraint = NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute,
                   relatedBy: constraint.relation, toItem: animationView, attribute: constraint.secondAttribute,
                   multiplier: constraint.multiplier, constant: constraint.constant)
                
                newConstraints.append(newConstraint)
            }
        }
        self.contentView.addConstraints(newConstraints)
        
        for constraint in containerView.constraints { // added height constraint
            if constraint.firstAttribute == .height, let item: UIView = constraint.firstItem as? UIView, item == containerView {
                let newConstraint = NSLayoutConstraint(item: animationView, attribute: constraint.firstAttribute,
                   relatedBy: constraint.relation, toItem: nil, attribute: constraint.secondAttribute,
                   multiplier: constraint.multiplier, constant: constraint.constant)
                
                animationView.addConstraint(newConstraint)
            }
        }
    }
    
    func createAnimationItemView()->[RotatedView] {
        guard let animationView = self.animationView else {
            fatalError()
        }
        
        var items = [RotatedView]()
        items.append(foregroundView)
        var rotatedViews = [RotatedView]()
        for case let itemView as RotatedView in animationView.subviews.filter({$0 is RotatedView}).sorted(by: {$0.tag < $1.tag}) {
            rotatedViews.append(itemView)
            if let backView = itemView.backView {
                rotatedViews.append(backView)
            }
        }
        items.append(contentsOf: rotatedViews)
        return items
    }
    
    func addImageItemsToAnimationView() {
        containerView.alpha = 1;
        let containerViewSize = containerView.bounds.size
        let foregroundViewSize = foregroundView.bounds.size
        
        // 添加第一块 view
        var image = containerView.pb_takeSnapshot(CGRect(x: 0, y: 0, width: containerViewSize.width, height: foregroundViewSize.height))
        var imageView = UIImageView(image: image)
        imageView.tag = 0
        imageView.layer.cornerRadius = foregroundView.layer.cornerRadius
        animationView?.addSubview(imageView)
        
        // 添加第二块 view
        image = containerView.pb_takeSnapshot(CGRect(x: 0, y: foregroundViewSize.height, width: containerViewSize.width, height: foregroundViewSize.height))
        
        imageView                     = UIImageView(image: image)
        let rotatedView               = RotatedView(frame: imageView.frame)
        rotatedView.tag               = 1
        rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        rotatedView.layer.transform   = rotatedView.transform3d()
        
        rotatedView.addSubview(imageView)
        animationView?.addSubview(rotatedView)
        rotatedView.frame = CGRect(x: imageView.frame.origin.x, y: foregroundViewSize.height, width: containerViewSize.width, height: foregroundViewSize.height)
        
        // 下面的两个
        let itemHeight = (containerViewSize.height - 2 * foregroundViewSize.height) / CGFloat(itemCount - 2)
        
        if itemCount == 2 {
            // decrease containerView height or increase itemCount
            assert(containerViewSize.height - 2 * foregroundViewSize.height == 0, "contanerView.height too high")
        }
        else{ // 进这个分支
            assert(containerViewSize.height - 2 * foregroundViewSize.height >= itemHeight, "contanerView.height too high")
        }
        
        var yPosition = 2 * foregroundViewSize.height
        var tag = 2
        // 遍历一遍，把这4个子view添加到需要动画的view中
        for _ in 2..<itemCount {
            // 生成一张对应子view的屏幕快照？
            image = containerView.pb_takeSnapshot(CGRect(x: 0, y: yPosition, width: containerViewSize.width, height: itemHeight))
            
            imageView = UIImageView(image: image)
            let rotatedView = RotatedView(frame: imageView.frame)
            rotatedView.addSubview(imageView)
            rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
            rotatedView.layer.transform = rotatedView.transform3d()
            // 动画View将每一个快照加上
            animationView?.addSubview(rotatedView)
            rotatedView.frame = CGRect(x: 0, y: yPosition, width: rotatedView.bounds.size.width, height: itemHeight)
            rotatedView.tag = tag
            
            yPosition += itemHeight
            tag += 1
        }
        
        containerView.alpha = 0;
        
        if let animationView = self.animationView {
            // added back view
            var previuosView: RotatedView?
            for case let container as RotatedView in animationView.subviews.sorted(by: { $0.tag < $1.tag })
                where container.tag > 0 && container.tag < animationView.subviews.count {
                    previuosView?.addBackView(container.bounds.size.height, color: backViewColor)
                    previuosView = container
            }
        }
        
        animationItemViews = createAnimationItemView()
    }
    
    fileprivate func removeImageItemsFromAnimationView() {
        
        guard let animationView = self.animationView else {
            return
        }
        
        animationView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    // MARK: public methods
    open func unfold(_ value: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            value ? openAnimation(completion) : closeAnimation(completion)
        } else {
            foregroundView.alpha = value ? 0 : 1
            containerView.alpha = value ? 1 : 0
        }
    }
    
    open func isAnimating() -> Bool {
        return animationView?.alpha == 1 ? true : false
    }
    
    open var isUnfolded = false
    
    // MARK: Animations
    open func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
        return type == .close ? durationsForCollapsedState[itemIndex] : durationsForExpandedState[itemIndex]
    }
    /// 动画展开的时长
    open var durationsForExpandedState: [TimeInterval] = []
    /// 动画关闭的时长
    open var durationsForCollapsedState: [TimeInterval] = []
    /// 计算cell中每一个子view所需要的动画时长
    /// @return - 返回一个包含 n - 1 个子view的动画时长
    func durationSequence(_ type: AnimationType)-> [TimeInterval] {
        var durations  = [TimeInterval]()
        for i in 0..<itemCount-1 {
            let duration = animationDuration(i, type: type)
            durations.append(TimeInterval(duration / 2.0))
            durations.append(TimeInterval(duration / 2.0))
        }
        return durations
    }
    /// 展开时动画
    func openAnimation(_ completion: (() -> Void)?) {
        // 标记为打开
        isUnfolded = true
        // 先删除之前的快照图片
        removeImageItemsFromAnimationView()
        // 从新添加一遍
        addImageItemsToAnimationView()
        
        guard let animationView = self.animationView else {
            return
        }
        // 先展示屏幕快照
        animationView.alpha = 1
        // 隐藏下面的图层
        containerView.alpha = 0
        // 根据动画类型计算需要的动画时长 类似 [1, 2, 3]
        let durations = durationSequence(.open)
        
        var delay: TimeInterval   = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0;
        var to: CGFloat           = -CGFloat.pi / 2
        var hidden                = true
        configureAnimationItems(.open)
        
        guard let animationItemViews = self.animationItemViews else {
            return
        }
        
        // 每一个屏幕快照执行动画
        for index in 0..<animationItemViews.count {
            let animatedView = animationItemViews[index]
            
            animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            from   = from == 0.0 ? CGFloat.pi / 2 : 0.0
            to     = to == 0.0 ? -CGFloat.pi / 2 : 0.0
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn
            hidden = !hidden
            delay += durations[index]
        }
        
        let firstItemView = animationView.subviews.filter { $0.tag == 0 }.first
        
        firstItemView?.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + durations[0], execute: {
            firstItemView?.layer.cornerRadius = 0
        })
        // 动画执行完成后
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // 隐藏所有屏幕快照的父view
            self.animationView?.alpha = 0
            // 展示下面的内容cell
            self.containerView.alpha  = 1
            // 执行动画执行完后用户的一些操作
            completion?()
        }
    }
    // 关闭动画
    func closeAnimation(_ completion: (() -> Void)?) {
        // 标记为关闭
        isUnfolded = false
        // 删除所有快照
        removeImageItemsFromAnimationView()
        // 再从新创建一遍
        addImageItemsToAnimationView()
        
        guard let animationItemViews = self.animationItemViews else {
            fatalError()
        }
        
        animationView?.alpha = 1
        containerView.alpha  = 0
        // 这里这个数据要取反，因为 顺序执行完后，要到退回去
        var durations: [TimeInterval] = durationSequence(.close).reversed()
        
        var delay: TimeInterval   = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0
        var to: CGFloat           = CGFloat.pi / 2
        var hidden                = true
        configureAnimationItems(.close)
        
        if durations.count < animationItemViews.count {
            fatalError("wrong override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval")
        }
        // 关闭每一个屏幕快照
        for index in 0..<animationItemViews.count {
            // 动画时长的数组取反了，所有对应里面的子view也要取反，来与自己的动画时长一一对应
            let animatedView = animationItemViews.reversed()[index]
            
            animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            to     = to == 0.0 ? CGFloat.pi / 2 : 0.0
            from   = from == 0.0 ? -CGFloat.pi / 2 : 0.0
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn
            hidden = !hidden
            delay += durations[index]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            // 关闭完了，就隐藏这些屏幕快照
            self.animationView?.alpha = 0
            completion?()
        })
        
        let firstItemView = animationView?.subviews.filter { $0.tag == 0 }.first
        firstItemView?.layer.cornerRadius = 0
        firstItemView?.layer.masksToBounds = true
        // 这一块不是懂
        if let durationFirst = durations.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay - durationFirst * 2, execute: {
                firstItemView?.layer.cornerRadius = self.foregroundView.layer.cornerRadius
                firstItemView?.setNeedsDisplay()
                firstItemView?.setNeedsLayout()
            })
        }
    }

}

// MARK: RotatedView
open class RotatedView: UIView {
    var hiddenAfterAnimation = false
    // 这个变量定义也不是很懂，有看懂的大神给讲讲，感激
    var backView: RotatedView?
    
    // 这个方法难道是自己往自己身上添加，根据自己生成的屏幕快照？？
    func addBackView(_ height: CGFloat, color:UIColor) {
        let view                                       = RotatedView(frame: CGRect.zero)
        view.backgroundColor                           = color
        view.layer.anchorPoint                         = CGPoint.init(x: 0.5, y: 1)
        view.layer.transform                           = view.transform3d()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        backView = view
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil,attribute: .height,
                                              multiplier: 1, constant: height))
        
        self.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1,
                               constant: self.bounds.size.height - height + height / 2),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading,
                               multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing,
                               multiplier: 1, constant: 0)
        ])
    }
}

extension RotatedView: CAAnimationDelegate {
    
    func rotatedX(_ angle : CGFloat) {
        var allTransofrom    = CATransform3DIdentity;
        let rotateTransform  = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransofrom        = CATransform3DConcat(allTransofrom, rotateTransform)
        allTransofrom        = CATransform3DConcat(allTransofrom, transform3d())
        self.layer.transform = allTransofrom
    }
    // 翻转动画
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000; // 这个值也没理解
        return transform
    }
    
    // MARK: animations
    func foldingAnimation(_ timing: String, from: CGFloat, to: CGFloat, duration: TimeInterval, delay:TimeInterval, hidden:Bool) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction      = CAMediaTimingFunction(name: timing)
        rotateAnimation.fromValue           = (from)
        rotateAnimation.toValue             = (to)
        rotateAnimation.duration            = duration
        rotateAnimation.delegate            = self;
        rotateAnimation.fillMode            = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false;
        rotateAnimation.beginTime           = CACurrentMediaTime() + delay
        
        self.hiddenAfterAnimation = hidden
        // 绕着 锚点 （0.5, 1) x轴翻转
        self.layer.add(rotateAnimation, forKey: "rotation.x")
    }
    
    public func animationDidStart(_ anim: CAAnimation) {
        // 这里为什么要栅格化？
        self.layer.shouldRasterize = true
        self.alpha = 1
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation {
            self.alpha = 0
        }
        self.layer.removeAllAnimations()
        // 这里为什么不用栅格化？
        self.layer.shouldRasterize = false
        self.rotatedX(CGFloat(0))
    }
    
}

private extension UIView {
    
    // 根据给定View的尺寸，生成一张一样的图片(？)
    func pb_takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // 这句没懂
        context.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
