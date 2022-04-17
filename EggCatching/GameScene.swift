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
    var lives:Int = 3
    var life1:SKSpriteNode!
    var life2:SKSpriteNode!
    var life3:SKSpriteNode!
    var bound:SKSpriteNode!
    var basket:SKSpriteNode!
    var basketPosY:CGFloat = 0
    var ScoreLabel:SKLabelNode!
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        //basket
        self.basket = self.childNode(withName: "basket") as? SKSpriteNode
        self.basketPosY = self.basket.position.y
        self.basket.physicsBody = SKPhysicsBody(circleOfRadius: self.basket.size.width/2)
        self.basket.physicsBody?.affectedByGravity = false
        self.basket.physicsBody?.isDynamic = false
        self.basket.physicsBody?.collisionBitMask = 1
        self.basket.physicsBody?.categoryBitMask = 0b1
        self.basket.physicsBody?.contactTestBitMask = 0b10
        //score label
        self.ScoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        //lives
        self.life1 = self.childNode(withName: "life1") as? SKSpriteNode
        self.life2 = self.childNode(withName: "life2") as? SKSpriteNode
        self.life3 = self.childNode(withName: "life3") as? SKSpriteNode
        //bounds
        self.bound = self.childNode(withName: "bound") as? SKSpriteNode
        self.bound.physicsBody = SKPhysicsBody(rectangleOf: self.bound.size)
        self.bound.physicsBody?.affectedByGravity = false
        self.bound.physicsBody?.isDynamic = false
        self.bound.physicsBody?.categoryBitMask = 0b1
        self.bound.physicsBody?.collisionBitMask = 0
        self.bound.physicsBody?.contactTestBitMask = 0b10
        
      
        
        
       
        let startSpawnEggs = SKAction.run(enableGravityEggs)
        let timer = SKAction.wait(forDuration: 0.6)
        let spawnEggSequence = SKAction.sequence([timer,startSpawnEggs])
        let spawnForever = SKAction.repeatForever(spawnEggSequence)
        self.run(spawnForever)
    }
    func enableGravityEggs()
    {
        
        let object = SKSpriteNode(imageNamed: "egg2")
        object.size = CGSize(width:70.71,height:80)
        
        let randomX = CGFloat.random(in: -375+object.size.width...375-object.size.width)
        
        let startPoint = CGPoint(x: randomX, y: self.size.height * 1.2)
        
         
        object.position = startPoint
        object.name = "egg"
        addChild(object)
        object.zPosition = 1
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width/2)
        object.physicsBody?.affectedByGravity = true
        object.physicsBody?.isDynamic = true
        object.physicsBody?.categoryBitMask = 0b10 || 0b1000
        object.physicsBody?.contactTestBitMask = 0b1
    }
  
    func didBegin(_ contact: SKPhysicsContact) {

        if contact.bodyA.contactTestBitMask == 0b1
        {
            currentScore += 1
            self.ScoreLabel.text = "Score: \(currentScore)"
            
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.contactTestBitMask == 0b1
        {
            
            currentScore += 1
            
            self.ScoreLabel.text = "Score: \(currentScore)"

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
