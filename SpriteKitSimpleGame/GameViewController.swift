//
//  GameViewController.swift
//  SpriteKitSimpleGame
//
//  Created by Dmytro Usik on 11/19/15.
//  Copyright (c) 2015 Dmytro Usik. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Configure the view.
        let scene = GameScene(size: view.bounds.size)
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
            
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
