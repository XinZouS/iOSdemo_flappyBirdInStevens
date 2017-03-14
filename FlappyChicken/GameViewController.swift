//
//  GameViewController.swift
//  FlappyChicken
//
//  Created by Xin Zou on 8/21/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                var scaleRatio:CGFloat = 0
                if UIDevice.current.userInterfaceIdiom == .pad {
                    scaleRatio = 1.2
                }
                if UIDevice.current.userInterfaceIdiom == .phone {
                    scaleRatio = 2
                }
                scene.size = CGSize(width: view.bounds.width * scaleRatio, height: view.bounds.height * scaleRatio)
//                scene.scaleMode = .aspectFill
                scene.scaleMode = .aspectFit
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
