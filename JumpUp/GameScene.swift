//
//  GameScene.swift
//  JumpUp
//
//  Created by Andrea Epifani on 11/10/2014.
//  Copyright (c) 2014 Tear Design. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let circle = SKShapeNode(circleOfRadius: 40)
    let target = SKShapeNode(rectOfSize: CGSize(width: 50, height: 50))
    
    let circleCategory:UInt32 = 0x1 << 1;
    let targetCategory:UInt32 = 0x1 << 2;
    
    var totalPoints = 0
    var newSprites : Array<SKShapeNode>!
    
    var label:SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        self.physicsWorld.contactDelegate = self
        
        label = SKLabelNode()
        label.text = "0"
        label.fontName = "BrainFlower"
        label.fontColor = UIColor.blackColor()
        label.position = CGPoint(x:CGRectGetMidX(self.frame), y: (self.frame.height - 100))
        label.fontSize = 30
        addChild(label)
        
        let circlePhysics = SKPhysicsBody(circleOfRadius: 40)
        circlePhysics.mass = 10
        circlePhysics.contactTestBitMask = circleCategory
        circlePhysics.collisionBitMask = circleCategory
        circlePhysics.dynamic = true
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 100)
        circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: (self.frame.height - 100))
        circle.physicsBody = circlePhysics
        circle.name = "circle"
        addChild(circle);
        
        setupBounds()
        
        let randomPositionX:CGFloat = CGFloat(arc4random()) % 500
        let randomPositionY:CGFloat = CGFloat(arc4random()) % CGFloat(self.frame.height / 3)
        
        let targetPhysics = SKPhysicsBody(rectangleOfSize: CGSize(width: 50, height: 50))
        targetPhysics.contactTestBitMask = targetCategory
        targetPhysics.collisionBitMask = targetCategory
        targetPhysics.dynamic = false
        target.fillColor = UIColor(red: 0, green: 255, blue: 0, alpha: 100)
        target.position = CGPoint(x: randomPositionX, y: randomPositionY)
        target.physicsBody = targetPhysics
        target.name = "target"
        addChild(target)
        
        
    }
    
    func setupBounds() {
        
        let fillColor = UIColor(red: 0, green: 100, blue: 100, alpha: 100)
        
        let floor = SKShapeNode(rectOfSize: CGSize(width: 2000, height: 20))
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 2000, height: 20))
        floor.physicsBody.dynamic = false
        floor.fillColor = fillColor
        floor.position = CGPoint(x: CGRectGetMidX(self.frame), y: 0)
        addChild(floor)
        
        let ceiling = SKShapeNode(rectOfSize: CGSize(width: 2000, height: 20))
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 2000, height: 20))
        ceiling.physicsBody.dynamic = false
        ceiling.fillColor = fillColor
        ceiling.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height)
        addChild(ceiling)
        
        let leftWall = SKShapeNode(rectOfSize: CGSize(width: 20, height: 2000))
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 20, height: 2000))
        leftWall.physicsBody.dynamic = false
        leftWall.fillColor = fillColor
        leftWall.position = CGPoint(x: 300, y: CGRectGetMidY(self.frame))
        addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOfSize: CGSize(width: 20, height: 2000))
        rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 20, height: 2000))
        rightWall.physicsBody.dynamic = false
        rightWall.fillColor = fillColor
        rightWall.position = CGPoint(x: self.frame.maxX-300, y: CGRectGetMidY(self.frame))
        addChild(rightWall)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        
        if bodyA.node.name != nil && bodyB.node.name != nil {
            
            if ((bodyA.node.name == "target") && (bodyB.node.name == "circle")) {
                target.fillColor = getRandomColor()
                
                let randomX:CGFloat = CGFloat(arc4random()) * 8000
                let randomY:CGFloat = CGFloat(arc4random()) * 8000
                target.physicsBody.dynamic = true
                target.physicsBody.applyImpulse(CGVectorMake(randomX, randomY))
                target.physicsBody.dynamic = false
                
                var k = 0
                for child in children {
                    if child is SKShapeNode {
                        if (child as SKShapeNode).name != nil {
                            if (child as SKShapeNode).name == "newsprite" {
                                k++
                                child.removeFromParent()
                            }
                        }
                    }
                }
                
                if k > 0 {
                    totalPoints++
                    
                    label.text = (totalPoints as NSNumber).stringValue
                }
    
            }
        
        }
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {

            let location = touch.locationInNode(self)
            
            circle.physicsBody.velocity = CGVectorMake(0, 0)
            circle.physicsBody.applyImpulse(CGVectorMake(0, 9800))
            
            var randomSize:CGFloat = CGFloat(drand48()) * 100
            
            let newSprite = SKShapeNode(circleOfRadius: randomSize)
            newSprite.fillColor = getRandomColor()
            newSprite.physicsBody = SKPhysicsBody(circleOfRadius: randomSize)
            newSprite.position = CGPoint(x: location.x, y: location.y)
            newSprite.physicsBody.dynamic = false
            newSprite.name = "newsprite"
            
            //newSprites.append(newSprite)
            
            addChild(newSprite)
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
