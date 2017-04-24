//
//  HintPage.swift
//  FlappyChicken
//
//  Created by Xin Zou on 4/23/17.
//  Copyright © 2017 Stevens. All rights reserved.
//

import SpriteKit
import GameplayKit

class HintPageNode : SKSpriteNode {
    
    var totalPages: Int?
    var currPage: Int?
    
    var backgroundNode : SKSpriteNode = {
        let b = SKSpriteNode()
        b.color = .black
        b.alpha = 0.7
        return b
    }()
    
    var pageNumLabel : SKLabelNode = {
        let pg = SKLabelNode()
        pg.text = "page 1/4"
        pg.fontName = fontAmericanTypewriterB
        pg.fontSize = 56
        pg.fontColor = .cyan
        pg.position = CGPoint(x: 0, y: -560)
        return pg
    }()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        let screenSize = UIScreen.main.bounds.size
        addChild(backgroundNode)
        backgroundNode.size = CGSize(width: screenSize.width * 2, height: screenSize.height * 2)
        
        addChild(pageNumLabel)
    }
    
    func setCurrPage(num:Int, total:Int){
        currPage = num
        totalPages = total
        pageNumLabel.text = "💡 \(currPage!)/\(totalPages!)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class HintPages : SKSpriteNode {
    
    var screenWidth = UIScreen.main.bounds.width * 2
    
    var currPage: Int = 0
    
    private var page01 : HintPageNode = {
        let p = HintPageNode()

        let upArrow = SKSpriteNode(imageNamed: "arrow_upWhite")
        upArrow.position = CGPoint(x: -200, y: 260)
        p.addChild(upArrow)
        
        let squrral = SKSpriteNode(imageNamed: "squrral")
        squrral.position = CGPoint(x: -200, y: 30)
        p.addChild(squrral)
        
        let str = SKLabelNode(text: "Tap to fly UP")
        str.fontName = fontAmericanTypewriterB
        str.fontSize = 70
        str.fontColor = .yellow
        str.position = CGPoint(x: 100, y: 100)
        p.addChild(str)
        
        let hand = SKSpriteNode(imageNamed: "tapping")
        hand.position = CGPoint(x: 30, y: -300)
        p.addChild(hand)
        
        return p
    }()
    
    private var page02 : HintPageNode = {
        let p = HintPageNode()

        let img = SKSpriteNode(imageNamed: "squrralPass")
        p.addChild(img)
        
        let str = SKLabelNode(text: "Go Between Bars")
        str.fontName = fontAmericanTypewriterB
        str.fontSize = 70
        str.fontColor = .yellow
        str.position = CGPoint(x: 0, y: 360)
        p.addChild(str)
        
        return p
    }()
    
    private var page03 : HintPageNode = {
        let p = HintPageNode()
        let scrW = UIScreen.main.bounds.width // 0.5 of real size
        let scrH = UIScreen.main.bounds.height
        
        let ptrHeart = SKSpriteNode(imageNamed: "pointer_upRight")
        ptrHeart.position = CGPoint(x: -122, y: scrH - 150)
        p.addChild(ptrHeart)
        
        let healthLabel = SKLabelNode(text: "❤️Health")
        healthLabel.position = CGPoint(x: -150, y: scrH - 330)
        healthLabel.fontName = fontAmericanTypewriterB
        healthLabel.fontSize = 70
        healthLabel.fontColor = .orange
        p.addChild(healthLabel)
        
        let ptrScore = SKSpriteNode(imageNamed: "pointer_upLeft")
        ptrScore.position = CGPoint(x: 160, y: scrH - 280)
        p.addChild(ptrScore)

        let scoreLabel = SKLabelNode(text: "Your Score")
        scoreLabel.position = CGPoint(x: 160, y: scrH - 460)
        scoreLabel.fontName = fontAmericanTypewriterB
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = .yellow
        p.addChild(scoreLabel)
        
        let eatLabel = SKLabelNode(text: "Food for more score:")
        eatLabel.position = CGPoint(x: 0, y: scrH - 600)
        eatLabel.fontName = fontAmericanTypewriterB
        eatLabel.fontSize = 60
        eatLabel.fontColor = .green
        p.addChild(eatLabel)
        
        let squrrNode = SKSpriteNode(imageNamed: "squrral")
        squrrNode.position = CGPoint(x: -260, y: scrH - 800)
        p.addChild(squrrNode)
        
        let foodSize: CGFloat = 100
        let food1 = SKLabelNode(text: "🌰")
        food1.fontSize = foodSize
        food1.position = CGPoint(x: -100, y: scrH - 750)
        p.addChild(food1)
        
        let food2 = SKLabelNode(text: "🍖")
        food2.fontSize = foodSize
        food2.position = CGPoint(x: -40, y: scrH - 920)
        p.addChild(food2)
        
        let food3 = SKLabelNode(text: "🍕")
        food3.fontSize = foodSize
        food3.position = CGPoint(x: 60, y: scrH - 730)
        p.addChild(food3)
        
        let food4 = SKLabelNode(text: "🌭")
        food4.fontSize = foodSize
        food4.position = CGPoint(x: 120, y: scrH - 900)
        p.addChild(food4)
        
        let lightingLabel = SKLabelNode(text: "[⚡️] = Speed up 🚀")
        lightingLabel.fontSize = 70
        lightingLabel.fontColor = .yellow
        lightingLabel.fontName = fontAmericanTypewriterB
        lightingLabel.position = CGPoint(x: 0, y: scrH - 1050)
        p.addChild(lightingLabel)

        return p
    }()
    
    private var page04 : HintPageNode = {
        let p = HintPageNode()
        let scrW = UIScreen.main.bounds.width // 0.5 of real size
        let scrH = UIScreen.main.bounds.height
        
        let beatRecord = SKLabelNode(text: "Break your record🥇")
        beatRecord.fontColor = .white
        beatRecord.fontSize = 60
        beatRecord.fontName = fontAmericanTypewriterB
        beatRecord.position = CGPoint(x: 0, y: 200)
        p.addChild(beatRecord)
        
        let ptrMusic = SKSpriteNode(imageNamed: "pointer_downLeft")
        ptrMusic.position = CGPoint(x: -scrW + 180, y: -scrH + 230)
        p.addChild(ptrMusic)
        
        let ptrLab = SKLabelNode(text: "Music On/Off")
        ptrLab.fontName = fontAmericanTypewriterB
        ptrLab.fontColor = .yellow
        ptrLab.fontSize = 70
        ptrLab.position = CGPoint(x: -60, y: -scrH + 360)
        p.addChild(ptrLab)
        
        let squrrNode = SKSpriteNode(imageNamed: "squrral")
        squrrNode.position = CGPoint(x: 0, y: 0)
        p.addChild(squrrNode)
        
        for _ in (1...6) {
            let start1 = SKLabelNode(text: "⭐️")
            start1.fontSize = 60 + CGFloat(drand48() * 40)
            start1.position = CGPoint(x: drand48() * 500 - 200, y: drand48() * 600 - 200)
            p.addChild(start1)
        }
        
        return p
    }()
    
    private var pages : [HintPageNode]?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        pages = [page01, page02, page03, page04]
        
        let dx: CGFloat = screenWidth
        var i = 0
        for p in pages! {
            p.setCurrPage(num: i + 1, total: (pages?.count)!)
            p.size = CGSize(width: dx, height: UIScreen.main.bounds.height * 2)
            p.position = CGPoint(x: dx * CGFloat(i), y: 0)
            p.zPosition = 2
            i += 1
            
            addChild(p)
        }
        
        
    }
    
    func moveTopage(isToNext: Bool){
        guard pages != nil, (pages?.count)! > 0 else { return }
        UIApplication.shared.beginIgnoringInteractionEvents()
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(defrozenScreen), userInfo: nil, repeats: false)

        let dir = isToNext ? -1 : 1
        let movePage = SKAction.moveBy(x: CGFloat(dir) * screenWidth, y: 0, duration: 0.3)
        
        if isToNext, currPage < ((pages?.count)! - 1) {
            currPage += 1
            for p in pages! {
                p.run(movePage)
            }
        }else if !isToNext, currPage > 0 {
            currPage -= 1
            for p in pages! {
                p.run(movePage)
            }
        }
    }
    
    func defrozenScreen(){
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


