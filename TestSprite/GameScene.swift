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
        
        
        let holdTap = UILongPressGestureRecognizer(target: self, 
            action: #selector(throwMultipleRubys(3)))
        addGestureRecognizer(holdTap)
        
    }

}

// MARK: Touch

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let position = CGPoint(x: location.x, y: location.y)
            self.tapPosition = position
            
            throwRuby()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RubyCategory) {
            
            if (contact.bodyA.node!.position.y > self.tapPosition!.y) {
                showBonus()
            }
            
          contact.bodyA.node?.physicsBody?.collisionBitMask = 0
          contact.bodyA.node?.physicsBody?.categoryBitMask = 0
          
        } else if (contact.bodyA.categoryBitMask == FloorCategory) {
        
            bodyB.node.removeFromParent()
        
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        }
    }
    
}

// MARK: Ruby related functions
extension GameScene {
    
    private func throwRuby() {
        let position = self.tapPosition
        let ruby = SKSpriteNode(texture: redRubyTexture)
        ruby.physicsBody = SKPhysicsBody(texture: redRubyTexture, size: ruby.size)
        ruby.scale(to: CGSize(width: 20, height: 20))
        ruby.position = position
        ruby.physicsBody?.linearDamping = 0.01 // Droping velocity
        ruby.physicsBody?.restitution = 0.5 // Bouncy level
        
        ruby.physicsBody?.categoryBitMask = RubyCategory
        ruby.physicsBody?.contactTestBitMask = RubyCategory | FloorCategory

        addChild(ruby)
        
        let rdmX = CGFloat.random(in: -10...10)
        let vector: CGVector = CGVector(dx: rdmX, dy: 150)
        ruby.physicsBody?.applyImpulse(vector)
    }
    
    private func throwYellowRuby() {
        let position = self.tapPosition!
        let ruby = SKSpriteNode(texture: yellowRubyTexture)
        ruby.physicsBody = SKPhysicsBody(texture: yellowRubyTexture, size: ruby.size)
        ruby.scale(to: CGSize(width: 20, height: 20))
        ruby.position = position
        ruby.physicsBody?.linearDamping = 0.01 // Droping velocity
        ruby.physicsBody?.restitution = 0.5 // Bouncy level

        ruby.physicsBody?.categoryBitMask = RubyCategory
        ruby.physicsBody?.contactTestBitMask = RubyCategory

        addChild(ruby)
        
        let rdmX = CGFloat.random(in: -10...10)
        let vector: CGVector = CGVector(dx: rdmX, dy: 150)
        ruby.physicsBody?.applyImpulse(vector)
    }   
    
    @objc private func throwMultipleRubys(_ nbItems: Int) {
        let position = self.tapPosition 
        if nbItems = 1 {
            throwRuby()
        } else {
            throwRuby() // shoot first ruby
            for i in 1...nbItems - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                    throwRuby()
                }
            }
        }
    }
    
}

// MARK: Achievements
extension GameScene {
    
    func showBonus() {
        let bonusAnimatedAtlas = SKTextureAtlas(named: "BonusImages")
        var bonusFrames: [SKTexture] = []
        
        // show bonus frame
        let firstFrameTexture = bonusFrames[0]
        let bonus = SKSpriteNode(texture: firstFrameTexture)
        bonus.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        bonus.scale(to: CGSize(width: 200, height: 75))
        addChild(bonus)
        
        // set bonusFrames
        let numImages = bonusAnimatedAtlas.textureNames.count
        for i in 1...numImages {
          let bonusTextureName = "bonus\(i)"
          bonusFrames.append(bonusAnimatedAtlas.textureNamed(bonusTextureName))
        }
        
        // anime
        let act =  SKAction.repeat(
          SKAction.animate(with: bonusFrames, timePerFrame: 0.2, resize: false, restore: true), count: 2)
      
        bonus.run(act, completion: {
            bonus.removeFromParent()
        })
    }
    
}