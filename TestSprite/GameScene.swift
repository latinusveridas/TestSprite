//
//  GameScene.swift
//  TestSprite
//
//  Created by Quentin Duquesne on 09/02/2020.
//  Copyright © 2020 Quentin Duquesne. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
        
    private var bounds: [Boundaries] = []
    
    let redRubyTexture = SKTexture(imageNamed: "ruby")
    let yellowRubyTexture = SKTexture(imageNamed: "yellowRuby")
    
    var tapPosition: CGPoint?
    var rotationGesture = UIGestureRecognizer()
    
    override func sceneDidLoad() {
        
        let grd = Boundaries() // used to trigger to object flush
        grd.setupGround(size: size)
        
        let left = Boundaries()
        left.setupLeft(size: size)
        
        let right = Boundaries()
        right.setupRight(size: size)
        
        bounds = [grd,left,right]
        bounds.forEach{ item in
            addChild(item)
        }
        
        self.backgroundColor = .clear
        self.physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let position = CGPoint(x: location.x, y: location.y)
            self.tapPosition = position
            
            spawnRaindrop(position: position)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RubyCategory) {
            
            if (contact.bodyA.node!.position.y > self.tapPosition!.y) {
                print("Above")
                buildBonus()
            }
            
          contact.bodyA.node?.physicsBody?.collisionBitMask = 0
          contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        }
    }
        
    private func spawnRaindrop(position: CGPoint) {
                
        let raindrop = SKSpriteNode(texture: redRubyTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: redRubyTexture, size: raindrop.size)
        raindrop.scale(to: CGSize(width: 20, height: 20))
        raindrop.position = position
        raindrop.physicsBody?.linearDamping = 0.01 // Droping velocity
        raindrop.physicsBody?.restitution = 0.5 // Bouncy level
        
        raindrop.physicsBody?.categoryBitMask = RubyCategory
        raindrop.physicsBody?.contactTestBitMask = RubyCategory

        addChild(raindrop)
        
        let rdmX = CGFloat.random(in: -10...10)
        let vector: CGVector = CGVector(dx: rdmX, dy: 150)
        raindrop.physicsBody?.applyImpulse(vector)

    }
    
    private func spawnYellowRaindrop() {
        let position = self.tapPosition!
        let raindrop = SKSpriteNode(texture: yellowRubyTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: yellowRubyTexture, size: raindrop.size)
        raindrop.scale(to: CGSize(width: 20, height: 20))
        raindrop.position = position
        raindrop.physicsBody?.linearDamping = 0.01 // Droping velocity
        raindrop.physicsBody?.restitution = 0.5 // Bouncy level

        addChild(raindrop)
        
        let rdmX = CGFloat.random(in: -10...10)
        let vector: CGVector = CGVector(dx: rdmX, dy: 150)
        raindrop.physicsBody?.applyImpulse(vector)

    }
    
    func buildBonus() {
        let bonusAnimatedAtlas = SKTextureAtlas(named: "BonusImages")
        var bonusFrames: [SKTexture] = []
        
        // set bonusFrames
        let numImages = bonusAnimatedAtlas.textureNames.count
        for i in 1...numImages {
          let bonusTextureName = "bonus\(i)"
          bonusFrames.append(bonusAnimatedAtlas.textureNamed(bonusTextureName))
        }
        
        // show bonus frame
        let firstFrameTexture = bonusFrames[0]
        let bonus = SKSpriteNode(texture: firstFrameTexture)
        bonus.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        bonus.scale(to: CGSize(width: 200, height: 75))
        addChild(bonus)
        
        // anime
        let act =  SKAction.repeat(
          SKAction.animate(with: bonusFrames, timePerFrame: 0.2, resize: false, restore: true), count: 2)
      
        bonus.run(act, completion: {
            bonus.removeFromParent()
        })
        
    }
    


}
