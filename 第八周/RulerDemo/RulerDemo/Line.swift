//
//  Line.swift
//  ARuler
//
//  Created by XerangaWang on 2017/9/7.
//  Copyright © 2017年 Johannes Ruof. All rights reserved.
//

import ARKit

enum LengthUnit {
    case meter, cenitMeter, inch
    
    var factor: Float{
        switch self {
        case .meter:
            return 1.0
        case .cenitMeter:
            return 100.0
        case .inch:
            return 39.3700787
        }
    }
    
    var name: String {
        switch self {
        case .meter:
            return "m"
        case .cenitMeter:
            return "cm"
        case .inch:
            return "inch"
        }
    }
}

class Line {
    
    var color = UIColor.orange
    var startNode: SCNNode
    var endNode: SCNNode
    var textNode: SCNNode
    var text: SCNText
    var lineNode: SCNNode?
    
    let sceneView: ARSCNView
    let startVector: SCNVector3
    let unit: LengthUnit
    
    init(sceneView: ARSCNView, startVector: SCNVector3, unit: LengthUnit) {
//        我們將要在這裡創建節點。（開始，結束，線，數字，單位）
        
        self.sceneView = sceneView
        self.startVector = startVector
        self.unit = unit
        
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = color
        dot.firstMaterial?.lightingModel = .constant //不會產生陰影
        dot.firstMaterial?.isDoubleSided = true //想面都依樣光亮
//        創建一個圓的兩面光亮的，正反兩面都拋光的球
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0) // 注意 這裡有坑 巨坑！！！
        startNode.position = startVector
        
        sceneView.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0) // 注意 這裡有坑 巨坑！！！
        
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 5)
        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.lightingModel = .constant //不會產生陰影
        text.firstMaterial?.isDoubleSided = true //想面都依樣光亮
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle // ...
        //        包裝文字的節點
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0) // 讓字體對著我
        textWrapperNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0) // 注意 這裡有坑 巨坑！！！
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        
//        我們無法預期說文字會出現在哪？ 所以我們要給他來個約束，這個約束，把文字節點綁在 我們的線的中間位置
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
//        SCNLookAtConstraint 是一個約束，讓他跟隨我們設定的目標
//        永遠面向使用者啦！
        
        constraint.isGimbalLockEnabled = true // 默認是 false
        
        textNode.constraints = [constraint] // 添加約束
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func update(to vector: SCNVector3) {
        lineNode?.removeFromParentNode() // 把舊有的線給移除掉
        
        lineNode = startVector.line(to: vector, color: color)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
//        更新文字
        text.string = distance(to: vector)
//        設置文字的位置 （放在線的中間）
        textNode.position = SCNVector3((startVector.x + vector.x) / 2.0 , (startVector.y + vector.y) / 2.0 ,(startVector.z + vector.z) / 2.0 )
        
//        結束節點的位置 在手機移動了多少 他就在哪裡！
        endNode.position = vector
        
        if endNode.parent == nil {
            
            sceneView.scene.rootNode.addChildNode(endNode)
        }
        
        
    }
    
    func distance(to vector: SCNVector3) -> String {
        
        return String(format:"%0.2f %@", startVector.distance(form: vector)*unit.factor, unit.name)
    }
    
    func remove(){
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
