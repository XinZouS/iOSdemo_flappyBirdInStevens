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
        b.alpha = 0.8
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
        pageNumLabel.text = "Hint \(currPage!)/\(totalPages!)"
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
        str.position = CGPoint(x: 0, y: 300)
        p.addChild(str)
        
        return p
    }()
    
    private var page03 : HintPageNode = {
        let p = HintPageNode(color: .black, size: .zero)
        p.alpha = 0.8

        return p
    }()
    
    private var page04 : HintPageNode = {
        let p = HintPageNode(color: .red, size: .zero)
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


