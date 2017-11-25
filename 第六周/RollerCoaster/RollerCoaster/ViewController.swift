//
//  ViewController.swift
//  RollerCoaster
//
//  Created by 刘勇刚 on 25/11/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// 高度
    let kHeight = UIScreen.main.bounds.size.height
    /// 宽度
    let kWidth = UIScreen.main.bounds.size.width
    /// 绿色轨道
    private var green: CAShapeLayer!
    /// 黄色轨道
    private var yellow: CAShapeLayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 绘制天空背景色
        setupSkyBackground()
        // 绘制山峰
        setupSnowMountain()
        // 绘制草地
        setupLawn()
        // 画大地
        setupLand()
        // 黄色轨道
        drawYellowTrack()
        // 绿色轨道
        drawGreenTrack()
        // 画树
        setupTrees()
        // 画云朵
        setupClouds()
        // 开车
        driveCar(carImageName: "otherTrain", trackLayer: yellow, animationDuration: 5.0, startTime: CACurrentMediaTime())
        driveCar(carImageName: "train", trackLayer: green, animationDuration: 6.0, startTime: CACurrentMediaTime() + 1)
    }
    
    /// 天空背景色
    private func setupSkyBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight - 20)
        let lightColor = UIColor(red: 56/255.0, green: 150/255.0, blue: 200/255.0, alpha: 1.0)
        let darkColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        bgLayer.colors = [lightColor.cgColor , darkColor.cgColor]
        bgLayer.startPoint = CGPoint(x: 0, y: 0)
        bgLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.addSublayer(bgLayer)
    }
    /// 初始化雪山
    private func setupSnowMountain() {
        let leftMountainLayer = CAShapeLayer()
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: 0, y: kHeight - 120))
        leftPath.addLine(to: CGPoint(x: 100, y: 100))
        leftPath.addLine(to: CGPoint(x: kWidth * 0.5, y: kHeight))
        leftPath.addLine(to: CGPoint(x: 0, y: kHeight))
        leftPath.close()
        
        leftMountainLayer.path = leftPath.cgPath
        leftMountainLayer.fillColor = UIColor.white.cgColor
        view.layer.addSublayer(leftMountainLayer)
        
        let leftMBodyL = CAShapeLayer()
        let leftBodyPath = UIBezierPath()
        let startPoint = CGPoint(x: 0, y: kHeight - 120)
        let endPoint = CGPoint(x: 100, y: 100)
        let firstPoint = calculateY(withX: 20, startPoint: startPoint, endPoint: endPoint)
        leftBodyPath.move(to: startPoint)
        
        leftBodyPath.addLine(to: firstPoint)
        leftBodyPath.addLine(to: CGPoint(x: 60, y: firstPoint.y))
        leftBodyPath.addLine(to: CGPoint(x: 100, y: firstPoint.y - 20))
        leftBodyPath.addLine(to: CGPoint(x: 130, y: firstPoint.y))
        leftBodyPath.addLine(to: CGPoint(x: 160, y: firstPoint.y + 10))
        
        let secondPoint = calculateY(withX: kWidth * 0.5 - 125, startPoint: endPoint, endPoint: CGPoint(x: kWidth * 0.5, y: kHeight))
        leftBodyPath.addLine(to: CGPoint(x: secondPoint.x - 30, y: firstPoint.y))
        leftBodyPath.addLine(to: secondPoint)
        leftBodyPath.addLine(to: CGPoint(x: kWidth * 0.5, y: kHeight))
        leftBodyPath.addLine(to: CGPoint(x: 0, y: kHeight))
        leftBodyPath.close()
        
        leftMBodyL.path = leftBodyPath.cgPath
        leftMBodyL.fillColor = UIColor.purple.cgColor
        view.layer.addSublayer(leftMBodyL)
        
    }
    /// 根据x坐标计算y坐标
    private func calculateY(withX x: CGFloat, startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let k = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x)
        let b = startPoint.y - startPoint.x * k
        let y = k * x + b
        return CGPoint(x: x, y: y)
    }
    /// 画草坪
    private func setupLawn() {
        let leftLawn = CAShapeLayer()
        let leftLawnPath = UIBezierPath()
        leftLawnPath.move(to: CGPoint(x: 0, y: kHeight))
        leftLawnPath.addLine(to: CGPoint(x: 0, y: kHeight - 100))
        
        leftLawnPath.addQuadCurve(to: CGPoint(x: kWidth / 3, y: kHeight - 20), controlPoint: CGPoint(x: kWidth / 5, y: kHeight - 100))
        leftLawn.path = leftLawnPath.cgPath
        leftLawn.fillColor = UIColor(red: 0.34, green: 0.67, blue: 0.2, alpha: 1.0).cgColor
        view.layer.addSublayer(leftLawn)
        
        // 右边的草坪
        let rightLawn = CAShapeLayer()
        let rightLawnPath = UIBezierPath()
        rightLawnPath.move(to: CGPoint(x: 0, y: kHeight))

        rightLawnPath.addQuadCurve(to: CGPoint(x: kWidth, y: kHeight - 100), controlPoint: CGPoint(x: kWidth * 0.5, y: kHeight - 100))
        rightLawnPath.addLine(to: CGPoint(x: kWidth, y: kHeight))
        rightLawn.path = rightLawnPath.cgPath
        rightLawn.fillColor = UIColor(red: 0.34, green: 0.67, blue: 0.2, alpha: 1.0).cgColor
        view.layer.insertSublayer(rightLawn, below: leftLawn)
        
    }
    /// 画大地
    private func setupLand() {
        let landLayer = CALayer()
        landLayer.frame = CGRect(x: 0, y: kHeight - 20, width: kWidth, height: 20)
        landLayer.backgroundColor = UIColor(patternImage: UIImage(named: "mud")!).cgColor
        view.layer.addSublayer(landLayer)
        
    }
    /// 黄色轨道
    private func drawYellowTrack() {
        yellow = CAShapeLayer()
        yellow.lineWidth = 5
        yellow.strokeColor = UIColor.yellow.cgColor
        
        let trackPath = UIBezierPath()
        trackPath.move(to: CGPoint(x: 0, y: kHeight - 60))
        trackPath.addCurve(to: CGPoint(x: kWidth / 1.5, y: kHeight / 2 - 20), controlPoint1: CGPoint(x: kWidth / 6, y: kHeight - 200), controlPoint2: CGPoint(x: kWidth / 3, y: kHeight + 50))
        trackPath.addQuadCurve(to: CGPoint(x: kWidth + 50, y: kHeight / 3), controlPoint: CGPoint(x: kWidth - 100, y: 50))
        trackPath.addLine(to: CGPoint(x: kWidth + 10, y: kHeight + 10))
        trackPath.addLine(to: CGPoint(x: 0, y: kHeight + 10))
        yellow.fillColor = UIColor(patternImage: UIImage(named: "yellowTrack")!).cgColor
        yellow.path = trackPath.cgPath
        view.layer.addSublayer(yellow)
        handle(trackPath: trackPath)
    }
    private func handle(trackPath: UIBezierPath) {
        let trackLine = CAShapeLayer()
        trackLine.lineCap = kCALineCapRound
        trackLine.strokeColor = UIColor.white.cgColor
        trackLine.lineDashPattern = [1.0, 0.6]
        trackLine.lineWidth = 2
        trackLine.fillColor = UIColor.clear.cgColor
        trackLine.path = trackPath.cgPath
        view.layer.addSublayer(trackLine)
    }
    /// 画绿色轨道
    private func drawGreenTrack() {
        green = CAShapeLayer()
        green.lineWidth = 5
        green.strokeColor = UIColor.green.cgColor
        
        let trackPath = UIBezierPath()
        trackPath.move(to: CGPoint(x: kWidth + 10, y: kHeight - 20))
        trackPath.addLine(to: CGPoint(x: kWidth + 10, y: kHeight - 70))
        trackPath.addQuadCurve(to: CGPoint(x: kWidth / 1.5, y: kHeight - 70), controlPoint: CGPoint(x: kWidth - 150, y: 200))
        
        trackPath.addArc(withCenter: CGPoint(x: kWidth / 1.6, y: kHeight - 140), radius: 70, startAngle: .pi * 0.5, endAngle: .pi * 2.5, clockwise: true)
        trackPath.addCurve(to: CGPoint(x: 0, y: kHeight - 100), controlPoint1: CGPoint(x: kWidth / 1.8 - 60, y: kHeight - 60), controlPoint2: CGPoint(x: 150, y: kHeight / 2.4))
        trackPath.addLine(to: CGPoint(x: -10, y: kHeight - 20))
        green.path = trackPath.cgPath
        green.fillColor = UIColor(patternImage: UIImage(named: "greenTrack")!).cgColor
        view.layer.addSublayer(green)
        handle(trackPath: trackPath)
    }
    /// 画🌲
    private func setupTrees() {
        addTree(totalNum: 5, treeFrame: CGRect(x: 0, y: kHeight - 30, width: 13, height: 23))
        addTree(totalNum: 6, treeFrame: CGRect(x: 0, y: kHeight - 55, width: 15, height: 28))
        addTree(totalNum: 7, treeFrame: CGRect(x: 0, y: kHeight - 73, width: 20, height: 32))
    }
    private func addTree( totalNum: Int, treeFrame: CGRect) {
        for i in 0 ..< totalNum {
            let treeLayer = CALayer()
            treeLayer.contents = #imageLiteral(resourceName: "tree").cgImage
            treeLayer.frame = CGRect(x: kWidth - 50 * CGFloat(i) * CGFloat((arc4random_uniform(4) + 1)) , y: treeFrame.origin.y, width: treeFrame.size.width, height: treeFrame.size.height)
            view.layer.insertSublayer(treeLayer, above: green)
        }
    }
    /// 画云朵 && 开始动画
    private func setupClouds() {
        let cloud = CALayer()
        cloud.contents = #imageLiteral(resourceName: "cloud").cgImage
        cloud.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        view.layer.addSublayer(cloud)
        // 动画
        let cloudPath = UIBezierPath()
        cloudPath.move(to: CGPoint(x: kWidth + 60, y: 50))
        cloudPath.addLine(to: CGPoint(x: -60, y: 50))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = cloudPath.cgPath
        animation.duration = 20
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
        animation.calculationMode = kCAAnimationPaced
        cloud.add(animation, forKey: "position")
    }
    
    private func driveCar( carImageName: String, trackLayer: CAShapeLayer, animationDuration: CFTimeInterval, startTime: CFTimeInterval) {
        let carLayer = CALayer()
        carLayer.frame = CGRect(x: 0, y: 0, width: 22, height: 15);
        let car = UIImage(named: carImageName)
        carLayer.contents = car?.cgImage
        // 动画
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = trackLayer.path
        anim.duration = animationDuration
        anim.repeatCount = MAXFLOAT
        anim.autoreverses = false
        anim.calculationMode = kCAAnimationPaced
        anim.rotationMode = kCAAnimationRotateAuto
        trackLayer.addSublayer(carLayer)
        carLayer.add(anim, forKey: "position")
    }
    

}

