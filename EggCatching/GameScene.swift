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
    var VelocityYEgg:CGFloat = -50
    var gravityY:CGFloat = -1
    var ScoreLabel:SKLabelNode!
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: gravityY)
        //basket
        self.basket = self.childNode(withName: "basket") as? SKSpriteNode
        self.basketPosY = self.basket.position.y
        self.basket.physicsBody = SKPhysicsBody(circleOfRadius: self.basket.size.width/2)
        self.basket.physicsBody?.affectedByGravity = false
        self.basket.physicsBody?.isDynamic = false
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
        self.bound.physicsBody?.categoryBitMask = 0b100
        self.bound.physicsBody?.contactTestBitMask = 0b10
        
        //eggs spawner
        let startSpawnEggs = SKAction.run(enableGravityEggs)
        let timer = SKAction.wait(forDuration: 0.6)
        let spawnEggSequence = SKAction.sequence([timer,startSpawnEggs])
        let spawnForever = SKAction.repeatForever(spawnEggSequence)
        self.run(spawnForever)
        
        //check walls for basket
        let startwc = SKAction.run(CheckWalls)
        let t = SKAction.wait(forDuration: 0.0001)
        let wcsequence = SKAction.sequence([t,startwc])
        let wcforever = SKAction.repeatForever(wcsequence)
        self.run(wcforever)
    }
    func CheckWalls()
    {
        if(self.basket.position.x >= (375 - self.basket.size.width/2.4))
        {
            self.basket.position.x -= self.basket.size.width/2.4
        }
        if(self.basket.position.x <= -375 + self.basket.size.width/2.4)
        {
            self.basket.position.x += self.basket.size.width/2.4
        }
    }
    func enableGravityEggs()
    {
        let object = SKSpriteNode(imageNamed: "egg2")
        object.size = CGSize(width:70.71,height:80)
        let randomX = CGFloat.random(in: -375+object.size.width...375-object.size.width)
        let startPoint = CGPoint(x: randomX, y: self.size.height + 50)
        
        object.position = startPoint
        object.name = "egg"
        addChild(object)
        object.zPosition = 1
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width/2)
        object.physicsBody?.affectedByGravity = true
        object.physicsBody?.isDynamic = true
        object.physicsBody?.allowsRotation = false
        //object.physicsBody?.velocity.dy = CGFloat.random(in: (-2000 * 1)...(-50 * 1))
        object.physicsBody?.velocity.dy = VelocityYEgg
        object.physicsBody?.categoryBitMask = 0b10
        object.physicsBody?.contactTestBitMask = 0b1
    }
  
    func didBegin(_ contact: SKPhysicsContact) {

        var phys1:SKPhysicsBody!
        var phys2:SKPhysicsBody!
                
               
        if contact.bodyA.categoryBitMask == 0b10
            {
                phys1 = contact.bodyA
                phys2 = contact.bodyB
                    
            }
            else if contact.bodyB.categoryBitMask == 0b10
            {
            
                phys1 = contact.bodyB
                phys2 = contact.bodyA
                    
            }
            else if contact.bodyA.categoryBitMask == 0b100
            {
                phys1 = contact.bodyB
                phys2 = contact.bodyA
            }
            else if contact.bodyB.categoryBitMask == 0b100
            {
                phys1 = contact.bodyA
                phys2 = contact.bodyB
            }
           //in case if it's player
            if phys2.categoryBitMask == 0b1
            {
                currentScore += 1
                phys1.node?.removeFromParent()
               // gravityY -= 0.5
                if self.VelocityYEgg > -2000
                {
                    self.VelocityYEgg -= 25
                }
                
                
            }
            //in case if it's bound
            else if phys2.categoryBitMask == 0b100
            {
                if lives == 3
                {
                    lives -= 1
                    self.life1.removeFromParent()
                }
                else if lives == 2
                {
                    lives -= 1
                    self.life2.removeFromParent()
                }
                else if lives == 1
                {
                    lives -= 1
                    self.life3.removeFromParent()
                    let gamescene = SKScene(fileNamed: "GameOverScene") as? GameOverScene
                    gamescene?.scaleMode = .aspectFit
                    gamescene?.myscore = currentScore
                    view?.presentScene(gamescene)
                }
                phys1.node?.removeFromParent()
            }
        self.ScoreLabel.text = "Score : \(currentScore)"
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
       
    }
}
