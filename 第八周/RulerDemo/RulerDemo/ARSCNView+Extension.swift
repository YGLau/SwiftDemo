//
//  ARSCNView+Extension.swift
//  ARuler
//
//  Created by XerangaWang on 2017/9/7.
//  Copyright © 2017年 Johannes Ruof. All rights reserved.
//

import ARKit

extension ARSCNView {
//    拿到三維座標
    func worldVector(for position: CGPoint) -> SCNVector3?{
        
        let results = self.hitTest(position, types: [.featurePoint])
        
        
        guard let result = results.first else {
            return nil
        }
        
//        等一下我們要來返回相機的位置
        return SCNVector3.positionTrasform(result.worldTransform)
    }
    
}
