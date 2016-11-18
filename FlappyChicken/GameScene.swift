//
//  GameScene.swift
//  FlappyChicken
//
//  Created by Xin Zou on 8/21/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode() // object in game.
    var bg = SKSpriteNode()
    var gameOver = false
    var gameOverLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var score = 0
    var lifeCount = 1
    let heartLabel = SKLabelNode();
    var bestScore = 0
    var timer = Timer()
    var player : AVAudioPlayer = AVAudioPlayer()
    
    enum ColliderType : UInt32 { // MUST add extends SKPhysicsContactDelegate class!!!
        case Bird = 1  // ..0000 0001
        case Pipe = 2  // and follow by 4,8,16,32.. bcz when have collide, we use case1 + case2 = 3 to identify them.
        case Gap = 4   // ..0000 0100
        case Heart = 8 // ..0000 1000
        case Ground = 16
        case Lighting = 32
        case Point = 64
    }
    
    func makePipes(){
        
        // add pipes into screen ====================================================
        let pipeTexture1 = SKTexture(imageNamed: "pipe1.png") // upper pipe facing down
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png") // bottom pipe facing up
        
        // use random num generator to let pipe move up or down to screen:
        let movementAmount = arc4random() % UInt32(self.frame.height / 2) // range of 0 to 2^32.
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4  // move up or down from center of screen.
        // let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: CGFloat(movementAmount / 10)), duration: TimeInterval(self.frame.width / 126 ))
        let removePipe = SKAction.removeFromParent()
        let moveAndRemovePipe = SKAction.sequence([movePipes, removePipe])
        
        var gapHeight = (bird.size.height * 10)
        if score > 20 {
            gapHeight = gapHeight - CGFloat(20 * 20)
        }else{
            gapHeight = gapHeight - CGFloat(score * 20) // make the gap smaller and game harder.
        }
        
        let xPosition = self.frame.midX + self.frame.width
        let yPositionDif = pipeTexture1.size().height / 2 + gapHeight / 2
        
        let pipe1 = SKSpriteNode(texture: pipeTexture1) // ======================================
        pipe1.position = CGPoint(x: xPosition, y: self.frame.midY + yPositionDif + pipeOffset)
        pipe1.zPosition = 2
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture1.size())
        pipe1.physicsBody!.isDynamic = false // not affect by gravity.
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Pipe.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Pipe.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Pipe.rawValue
        pipe1.run(moveAndRemovePipe)
        
        self.addChild(pipe1)
        
        let pipe2 = SKSpriteNode(texture: pipeTexture2) // ======================================
        pipe2.position = CGPoint(x: xPosition, y: self.frame.midY - yPositionDif + pipeOffset)
        pipe2.zPosition = 2
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
        pipe2.physicsBody!.isDynamic = false // do NOT fall off screen
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Pipe.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Pipe.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Pipe.rawValue
        pipe2.run(moveAndRemovePipe)
        
        self.addChild(pipe2)
        
        // make a gap node between 2 pipes so that we can count how much the player get through =================
        let gap = SKNode()
        gap.position = CGPoint(x: xPosition, y: self.frame.midY + pipeOffset) // y point is at the center of 2 pipes.
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: gapHeight))
        gap.zPosition = 2
        gap.physicsBody!.isDynamic = false
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue // who will hit you
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue     // who are you
        gap.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue   // who can pass through you
        gap.run(moveAndRemovePipe)
        
        self.addChild(gap)
        
        
        if(score % 2 == 0){ // add one heart into game =====================================================
            let heartTexture = SKTexture(imageNamed: "heart_red_60x60.png")
            let heartMovement = arc4random() % UInt32(self.frame.height / 2)
            let heartOffset = CGFloat(heartMovement) - self.frame.height / 4  // move up or down
            let moveHeart = SKAction.move(by: CGVector(dx: -2.6 * self.frame.width, dy: -0.5 * CGFloat(movementAmount)), duration: TimeInterval(self.frame.width / 150))
            let removeHeart = SKAction.removeFromParent()
            let moveAndRemoveHeart = SKAction.sequence([moveHeart, removeHeart])
            
            let heart = SKSpriteNode(texture: heartTexture)
            heart.position = CGPoint(x: xPosition, y: self.frame.midY + heartOffset)
            heart.zPosition = 2
            heart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: heartTexture.size().width * 0.5, height: heartTexture.size().height * 0.5))
            heart.physicsBody!.isDynamic = false  // do not fall off screen
            heart.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
            heart.physicsBody!.categoryBitMask = ColliderType.Heart.rawValue
            heart.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
            heart.run(moveAndRemoveHeart)
            
            self.addChild(heart)
        }
        
        
        if (score > 1) && (score % 5 == 0){ // add a boost mark into game =================================================
            let lightingTexture = SKTexture(imageNamed: "lighting.png")
            let lighting = SKSpriteNode(texture: lightingTexture)
            lighting.position = gap.position
            lighting.zPosition = 2
            lighting.physicsBody = SKPhysicsBody(rectangleOf: lightingTexture.size())
            lighting.physicsBody!.isDynamic = false
            lighting.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
            lighting.physicsBody!.categoryBitMask = ColliderType.Lighting.rawValue
            lighting.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
            lighting.run(moveAndRemovePipe)
            
            self.addChild(lighting)
        }
        
        if (score > 1) && (score % 7) == 0 {  // point == 🌭
            let pointTexture = SKTexture(imageNamed: "hotdog_60x60.png")
            let pointMovement = arc4random() % UInt32(self.frame.height / 2)
            let pointOffset = CGFloat(pointMovement) - self.frame.height / 4 // move up, move down
            let movePoint = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: -1.0 * CGFloat(movementAmount)), duration: TimeInterval(self.frame.width / 100))
            let removePoint = SKAction.removeFromParent()
            let moveAndRemovePoint = SKAction.sequence([movePoint, removePoint])
            
            let point = SKSpriteNode(texture: pointTexture)
            point.position = CGPoint(x: xPosition, y: self.frame.midY + pointOffset)
            point.zPosition = 2
            point.physicsBody = SKPhysicsBody(texture: pointTexture, size: pointTexture.size())
            point.physicsBody!.isDynamic = false
            point.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
            point.physicsBody!.categoryBitMask = ColliderType.Point.rawValue
            point.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
            point.run(moveAndRemovePoint)
            
            self.addChild(point)
        }
    }
    
    
    func defrozenScreen() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    func resumeNormalSpeed() {
        if self.speed > 2 {
            self.speed -= 3.0 // == boost
            scoreLabel.fontSize -= 10
        }
        scoreLabel.fontColor = UIColor.white
        bird.physicsBody!.isDynamic = true
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue // so bird can NOT pass pipes
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    func popScoreLabel() {
        scoreLabel.fontColor = UIColor.yellow
        scoreLabel.fontSize += 10
    }
    func shinkScoreLabel() {
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontSize -= 10
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // detect collection ====================================
        
        if gameOver == true {
            return
        }
        
        // check either bird or gap (i.e. A or B) collide:
        if  contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue ||
            contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score += 1
            scoreLabel.text = String(score)
            if(score < 12){
                self.speed += CGFloat(score) * 0.01
            }else{
                self.speed = 1.8
            }
        }
        else if contact.bodyA.categoryBitMask == ColliderType.Heart.rawValue ||
                contact.bodyB.categoryBitMask == ColliderType.Heart.rawValue {
            
            lifeCount += 1
            if var heartStr = heartLabel.text {
                heartStr += "❤️"
                heartLabel.text = heartStr
            }
            
        }
        else if contact.bodyA.categoryBitMask == ColliderType.Lighting.rawValue ||
                contact.bodyB.categoryBitMask == ColliderType.Lighting.rawValue {
            
            self.speed += CGFloat(3)
            UIApplication.shared.beginIgnoringInteractionEvents() // frozen screen
            score += 6
            scoreLabel.text = String(score)
            scoreLabel.fontSize += 10
            scoreLabel.fontColor = UIColor.yellow
            bird.physicsBody!.isDynamic = false // frozen bird
            bird.physicsBody!.categoryBitMask = ColliderType.Pipe.rawValue // so bird can hit pipes
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(resumeNormalSpeed), userInfo: nil, repeats: false)
            
        }
        else if contact.bodyA.categoryBitMask == ColliderType.Point.rawValue ||
                contact.bodyB.categoryBitMask == ColliderType.Point.rawValue {
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(popScoreLabel), userInfo: nil, repeats: false)
            score += 3
            scoreLabel.text = String(score)
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(shinkScoreLabel), userInfo: nil, repeats: false)
            
        }
        else { // collide to pipe or ground, subtract lifeCount or game over.
            
            if lifeCount < 1 || // life < 1 or touching ground, game over
                contact.bodyA.categoryBitMask == ColliderType.Ground.rawValue ||
                contact.bodyB.categoryBitMask == ColliderType.Ground.rawValue {
                
                UIApplication.shared.beginIgnoringInteractionEvents() // frozen screen
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(defrozenScreen), userInfo: nil, repeats: false)
            
                heartLabel.text = "💔"
                self.speed = 0 // stop the game
                timer.invalidate()
                player.stop()
                gameOver = true
            
                gameOverLabel.fontName = "Helvetica"
                if score > bestScore {  // save the best record.
                    UserDefaults.standard.set(score, forKey: "bestScore")
                    gameOverLabel.fontSize = 76
                    gameOverLabel.text = "You break record! \(score)!"
                }else{
                    gameOverLabel.fontSize = 56
                    gameOverLabel.text = "Best score is: \(bestScore). Try again~"
                }
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
                gameOverLabel.zPosition = 3
            
                self.addChild(gameOverLabel)
                
            }
            else {  // hit pipe, subtract lifeCount
                
                lifeCount -= 1;
                if lifeCount > 1 {
                    var heartStr = "❤️"
                    for _ in 1...lifeCount {
                        heartStr += "❤️"
                    }
                    heartLabel.text = heartStr
                }else if lifeCount == 1 {
                    heartLabel.text = "❤️"
                }
            }
            
        } // end of collion of pipe or ground
    }
    
    
    
    override func didMove(to view: SKView) { // only run once
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    
    func setupGame() {
        // set a timer to make pipes forever:
        let pipeTime = 2 - (Double(0.5))
        timer = Timer.scheduledTimer(timeInterval: pipeTime, target: self, selector: #selector(makePipes), userInfo: nil, repeats: true)
        
        // set game score info label ===============================================================
        scoreLabel.fontName = "Helvetica" // ? ??? ? ???? ??
        scoreLabel.fontSize = 200
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 206) // move down from top of screen
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        
        heartLabel.fontName = "Helvetica" // ????????????????????
        heartLabel.fontSize = 60
        heartLabel.text = "❤️"
        // heartLabel.position = CGPoint(x: self.frame.minX + CGFloat(65 * lifeCount) , y: self.frame.maxY - 65)
        heartLabel.position = CGPoint(x: self.frame.midX , y: self.frame.maxY - 62)
        heartLabel.zPosition = 3
        self.addChild(heartLabel)

        // build the background and add to scene ===================================================
        // let bgTesture = SKTexture(imageNamed: "bg.png")
        let bgTesture = SKTexture(imageNamed: "Stevens EAS.JPG")
        // let moveBGAnimation = SKAction.move(by: CGVector(dx: -10, dy:0), duration: 0.1) // one way to move.
        // the BG will move by: left x within every 0.1 s, then make it forever and apply to bg.
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTesture.size().width, dy:0), duration: 30) // anohter way to move.
        // the BG will move by entire width within 5 s.
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTesture.size().width, dy:0), duration: 0) // move it back to begin.
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i : CGFloat = 0
        while i < 3 {
            bg = SKSpriteNode(texture: bgTesture)
            // use 3 backgrounds, order one by one, each time set it follows eachother,
            bg.position = CGPoint(x: (bgTesture.size().width * i), y: self.frame.midY)
            bg.zPosition = 1 // background layout
            bg.size.height = self.frame.height // height of background equals to screen
            bg.run(moveBGForever)
        
            self.addChild(bg)
            
            i += 1
        }
        
        // then add bird in front of the background: ==============================================
        
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png") // flappy action img
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture1) // init bird to display
        bird.position = CGPoint(x: self.frame.midX - 270, y: self.frame.midY)
        bird.zPosition = 2 // bird layout
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height / 2) // if add this, bird will drop before you tap it.
        bird.physicsBody!.isDynamic = false; // so use this to make bird stop when init, change it in touchesBegan()
        bird.physicsBody!.contactTestBitMask = ColliderType.Pipe.rawValue // collide with with object.
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        bird.run(makeBirdFlap)
        
        self.addChild(bird)
        
        // add ground and sky so bird will not out screen: =======================================
        let ground = SKNode() // do not need to move
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.zPosition = 2
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 3) )
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Ground.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Ground.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Ground.rawValue
        
        self.addChild(ground)
        
        
        let sky = SKNode() // also do not fly out of screen
        sky.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2)
        sky.zPosition = 2
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 3))
        sky.physicsBody!.isDynamic = false
        
        self.addChild(sky)
        
        // background music setup ===============================================================
        let selectSong = arc4random() % UInt32(2)
        var selectName = "Axel_F" // as default
        if selectSong == 0 {
            selectName = "crazy frog - play the game"
        }
        let audioPath = Bundle.main.path(forResource: selectName, ofType: "mp3")
        do{
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))            
            player.volume = 0.8
            player.play() // start background music
        }catch{
            print("loading plyaer URL failer at line 230")
        }
        
        // load the best score in record ========================================================
        if let restoreScore = UserDefaults.standard.object(forKey: "bestScore") {
            bestScore = restoreScore as! Int
        }else{
            bestScore = 0
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == true {
            score = 0
            lifeCount = 1
            gameOver = false
            speed = 1
            
            self.removeAllChildren() // reset the seen as init
            self.setupGame()
        }
        else {
            let birdTexture1 = SKTexture(imageNamed: "flappy1.png") // flappy action img
        
            bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height / 2)
            bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
            bird.physicsBody!.isDynamic = true;
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 80)) // impulse oppsite direction and move distence of CGVector.
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
