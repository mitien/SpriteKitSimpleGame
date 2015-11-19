//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Dmytro Usik on 11/19/15.
//  Copyright (c) 2015 Dmytro Usik. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left:CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y:left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x:point.x / scalar, y:point.y / scalar)
}



#if !(arch(x86_64) || arch(arm64))
    func sqrt(a:CGFloat) -> CGFLoat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif



extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}




//constants for physics categories
struct PhysicsCategory {
    static let None         :UInt32 = 0
    static let All          :UInt32 = UInt32.max
    static let Monster      :UInt32 = 0b1           //1
    static let Projectile   :UInt32 = 0b10          //2
    
}







class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
    
        //set up physics world to have no gravity, and sets the scene as the
        //delegate to be notified when two physics bodies colide
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
        
        /* Setup your scene here */
        backgroundColor = SKColor.whiteColor()
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
            ])
        ))

    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    
    
    func addMonster() {
        //create monster
        let monster = SKSpriteNode(imageNamed: "monster")
        
        //Determine where to spawn the monster alongg the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        //Position the monster slightly off-screen along the right edge
        //and along a random position along Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        
       //Add the monster to the scene
        addChild(monster)
        
        
        //Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        
        //vreate the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2 , y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.runAction(SKAction.sequence([actionMove,actionMoveDone]))
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        //1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        
        //2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        
        //3 - determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        
        //4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) {return}
        
        
        //5 - OK to add now - if you`ve double checked position
        addChild(projectile)
        
        
        //6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        
        //7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        
        //8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        
        //9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration:2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
       
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


























