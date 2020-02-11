//
//  BackgroundNode.swift
//  TestSprite
//
//  Created by Quentin Duquesne on 09/02/2020.
//  Copyright © 2020 Quentin Duquesne. All rights reserved.
//

import Foundation
import SpriteKit

public class Boundaries : SKNode {
    
    public func setupGround(size : CGSize) {

        // Ground
        let yPos : CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)

    }
    
    public func setupLeft(size : CGSize) {
    
        // Left
        let xPosLeft: CGFloat = 0
        let startPointLeft = CGPoint(x: xPosLeft, y: 0)
        let endpointLeft = CGPoint(x: xPosLeft, y: size.height)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPointLeft, to: endpointLeft)
    
    }
    
    public func setupRight(size : CGSize) {
    
        // Right
        let xPosRight: CGFloat = size.width
        let startPointRight = CGPoint(x: xPosRight, y: 0)
        let endpointRight = CGPoint(x: xPosRight, y: size.height)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPointRight, to: endpointRight)
    
    }
    
}
