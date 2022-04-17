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
    var myscore:Int = 0
    var highestScore: Int = 0
    var resumeB:SKSpriteNode!
    
    private var resultLabel:SKLabelNode!
    private var highResultLabel:SKLabelNode!
    override func didMove(to view: SKView) {
        
        self.highestScore = UserDefaults.standard.integer(forKey: "HScore")
        self.resumeB = self.childNode(withName: "resumeB") as? SKSpriteNode
        self.resultLabel = self.childNode(withName: "score") as? SKLabelNode
        self.highResultLabel = self.childNode(withName: "highestScore") as?SKLabelNode
        if myscore > highestScore
        {
            highestScore = myscore
            UserDefaults.standard.set(highestScore, forKey: "HScore")
        }
        resultLabel.text = "Score: \(myscore)"
        highResultLabel.text = "Highest Score: \(highestScore)"
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if let t = touches.first{
            let nodes = self.nodes(at: t.location(in: self))
            if nodes.contains(where: {n in return n.name == resumeB.name})
            {
                let gamescene = SKScene(fileNamed: "GameScene")
                gamescene?.scaleMode = .aspectFit
                view?.presentScene(gamescene)
                
        
            }
        }
    }
    
}
