//
//  GameScene.swift
//  Amoeba Wars
//
//  Created by 20072163 on 23/11/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let margin = CGFloat(75)
    let marginVertical = CGFloat(100)
    
    var histolyticaButton: ButtonNode!
    var fowleriButton: ButtonNode!
    var proteusButton: ButtonNode!
    
    let coinLeftLabel = SKLabelNode(fontNamed: "Courier-Bold")
    let coinRightLabel = SKLabelNode(fontNamed: "Courier-Bold")
    
    var lastUpdateTimeInterval: TimeInterval = 0
    
    var gameOver = false
    var entityManager: EntityManager!
    
    override func didMove(to view: SKView) {
        
        // Create entity manager
        entityManager = EntityManager(scene: self)
        
        // Start background music
        let bgMusic = SKAudioNode(fileNamed: SoundFile.BackgroundMusic)
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        
        // Add background
        let background = SKSpriteNode(imageNamed: ImageName.Background)
//        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = Layer.Background
        background.size = CGSize(width: self.size.width, height: self.size.height)
        print("Width:  \(self.size.width)","Height: \(self.size.height)")
        addChild(background)
        
        // Add histolytica button
        histolyticaButton = ButtonNode(iconName: ImageName.HistolyticaLeft, text: String(GameConfig.HistolyticaCost), onButtonPress: histolyticaPressed)
        histolyticaButton.position = CGPoint(x: size.width * 0.25, y: marginVertical + histolyticaButton.size.height / 2)
        addChild(histolyticaButton)
        
        // Add fowleri button
        fowleriButton = ButtonNode(iconName: ImageName.FowleriLeft, text: String(GameConfig.FowleriCost), onButtonPress: fowleriPressed)
        fowleriButton.position = CGPoint(x: size.width * 0.5, y: marginVertical + fowleriButton.size.height / 2)
        addChild(fowleriButton)
        
        // Add proteus button
        proteusButton = ButtonNode(iconName: ImageName.ProteusLeft, text: String(GameConfig.ProteusCost), onButtonPress: proteusPressed)
        proteusButton.position = CGPoint(x: size.width * 0.75, y: marginVertical + proteusButton.size.height / 2)
        addChild(proteusButton)
        
        // Add coin left indicator
        let coinLeft = SKSpriteNode(imageNamed: ImageName.Coin)
        
        coinLeft.position = CGPoint(x: margin + coinLeft.size.width/2,
                                    y: size.height - marginVertical - coinLeft.size.height/2)
        addChild(coinLeft)
        coinLeftLabel.fontSize = 50
        coinLeftLabel.fontColor = SKColor.black
        coinLeftLabel.position = CGPoint(x: coinLeft.position.x + coinLeft.size.width/2 + margin, y: coinLeft.position.y)
        coinLeftLabel.zPosition = Layer.HUD
        coinLeftLabel.horizontalAlignmentMode = .left
        coinLeftLabel.verticalAlignmentMode = .center
        coinLeftLabel.text = "0"
        self.addChild(coinLeftLabel)
        
        // Add coin right indicator
        let coinRight = SKSpriteNode(imageNamed: ImageName.Coin)
        
        coinRight.position = CGPoint(x: size.width - margin - coinRight.size.width/2,
                                    y: size.height - marginVertical - coinRight.size.height/2)
        addChild(coinRight)
        coinRightLabel.fontSize = 50
        coinRightLabel.fontColor = SKColor.black
        coinRightLabel.position = CGPoint(x: coinRight.position.x - coinRight.size.width/2 - margin * 2, y: coinRight.position.y)
        coinRightLabel.zPosition = Layer.HUD
        coinRightLabel.horizontalAlignmentMode = .left
        coinRightLabel.verticalAlignmentMode = .center
        coinRightLabel.text = "0"
        self.addChild(coinRightLabel)
        
        // Add base left
//        let baseLeftDefence = SKSpriteNode(imageNamed: ImageName.Base_Left_Defence)
//        baseLeftDefence.position = CGPoint(x: size.width * 0.25 - margin, y: histolyticaButton.size.height + baseLeftDefence.size.height / 2)
//        addChild(baseLeftDefence)
        
        let baseLeft = Base(imageName: ImageName.Base_Left_Attack, team: .teamLeft, entityManager: entityManager)
        if let spriteComponent = baseLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width/2, y: size.height/2)
        }
        entityManager.add(baseLeft)
        
        // Add base right
//        let baseRightDefence = SKSpriteNode(imageNamed: ImageName.Base_Right_Defence)
//        baseRightDefence.position = CGPoint(x: size.width * 0.75 + margin, y: proteusButton.size.height + baseRightDefence.size.height / 2)
//        addChild(baseRightDefence)
        
        let baseRight = Base(imageName: ImageName.Base_Right_Attack, team: .teamRight, entityManager: entityManager)
        if let spriteComponent = baseRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width - spriteComponent.node.size.width/2, y: size.height/2)
        }
        entityManager.add(baseRight)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        print("\(touchLocation)")
        
        if gameOver {
            let newScene = GameScene(size: size)
            newScene.scaleMode = scaleMode
            view?.presentScene(newScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            return
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        
        // update player left coins
        if let playerLeft = entityManager.base(for: .teamLeft),
            let playerLeftBase = playerLeft.component(ofType: BaseComponent.self) {
            coinLeftLabel.text = "\(playerLeftBase.coins)"
        }
        
        // update player right coins
        if let playerRight = entityManager.base(for: .teamRight),
            let playerRightBase = playerRight.component(ofType: BaseComponent.self) {
            coinRightLabel.text = "\(playerRightBase.coins)"
        }
    }
    
    //MARK: - Button methods
    
    func histolyticaPressed() {
        print("Histolytica pressed!")
        entityManager.spawnHistolytica(team: .teamLeft)
    }
    
    func fowleriPressed() {
        print("Fowleri pressed!")
    }
    
    func proteusPressed() {
        print("Proteus pressed!")
    }
    
}
