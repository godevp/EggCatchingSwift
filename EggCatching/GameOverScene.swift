//
//  GameOverScene.swift
//  EggCatching
//
//  Created by Виталий Карабанов on 2022-04-17.
//

import SpriteKit
import GameplayKit

class GameOverScene:SKScene
{
    var score:Int = 0
    var resumeB:SKSpriteNode!
    private var resultLabel:SKLabelNode!
    override func didMove(to view: SKView) {
        
        self.resumeB = self.childNode(withName: "resumeB") as? SKSpriteNode
        self.resultLabel = self.childNode(withName: "score") as? SKLabelNode
        
        resultLabel.text = "Score: \(score)"
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if let t = touches.first{
            let nodes = self.nodes(at: t.location(in: self))
            if nodes.contains(where: {n in return n.name == resumeB.name})
            {
                let gamescene = SKScene(fileNamed: "GameScene")
                gamescene?.scaleMode = .aspectFill
                view?.presentScene(gamescene)
        
            }
        }
    }
    
}
