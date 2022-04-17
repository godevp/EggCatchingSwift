//
//  GameScene.swift
//  EggCatching
//
//  Created by Виталий Карабанов on 2022-04-17.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var currentScore:Int = 0
    var basket:SKSpriteNode!
    var basketPosY:CGFloat = 0
    var egg1:SKSpriteNode!
    var egg2:SKSpriteNode!
    var egg3:SKSpriteNode!
    var currentScore:SKLabelNode!
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.basket = self.childNode(withName: "basket") as? SKSpriteNode
        self.egg1 = self.childNode(withName: "egg1") as? SKSpriteNode
        self.basketPosY = self.basket.position.y
        self.currentScore = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        self.basket.physicsBody = SKPhysicsBody(circleOfRadius: self.basket.size.width/2)
        self.basket.physicsBody?.affectedByGravity = false
        self.basket.physicsBody?.isDynamic = false
        self.basket.physicsBody?.collisionBitMask = 0
        self.basket.physicsBody?.categoryBitMask = 0b1
        self.basket.physicsBody?.contactTestBitMask = 0b10
        
        enableGravityEggs(this: self.egg1)
      //  enableGravityEggs(this: self.egg2)
    
    }
    func enableGravityEggs( this: SKSpriteNode)
    {
        this.physicsBody = SKPhysicsBody(circleOfRadius: this.size.width/2)
        this.physicsBody?.affectedByGravity = true
        this.physicsBody?.isDynamic = true
        this.physicsBody?.collisionBitMask = 0
        this.physicsBody?.categoryBitMask = 0b10
        this.physicsBody?.contactTestBitMask = 0b1
    }
    func didBegin(_ contact: SKPhysicsContact) {

        if contact.bodyA.contactTestBitMask == 0b1
        {
            print("1111")
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.contactTestBitMask == 0b1
        {
            currentScore += 1
            print("2222")
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    
        if let basket = self.basket{
            basket.run(SKAction.move(to: CGPoint(x: pos.x, y: basketPosY) , duration: 0.1))
        }
        
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let basket = self.basket{
            basket.run(SKAction.move(to: CGPoint(x: pos.x, y: basketPosY) , duration: 0.1))
        }
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let basket = self.basket{
            basket.run(SKAction.move(to: CGPoint(x: pos.x, y: basketPosY) , duration: 0.1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//        if let t = touches.first{
//            let nodes = self.nodes(at: t.location(in: self))
//            if nodes.contains(where: {n in return n.name == basket.name})
//            {
//                let gamescene = SKScene(fileNamed: "GameOverScene")
//                gamescene?.scaleMode = .aspectFill
//                view?.presentScene(gamescene)
//
//            }
//    }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
