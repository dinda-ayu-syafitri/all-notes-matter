//
//  CharacterCustomScene.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 30/04/24.
//

import SpriteKit

class CharacterCustomScene:SKScene {

    var redPlayerNode: SKSpriteNode!
    var bluePlayerNode: SKSpriteNode!
    
    func createSpriteNode(imageName:String, scale:CGFloat, position:CGPoint ) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageName)
        node.setScale(scale)
        node.position = position
        //        parent.addChild(node)

        return node
    }

    func createAnimation(atlasName: String) -> SKAction {

        let textureAtlas = SKTextureAtlas(named: atlasName)


        var textures:[SKTexture] = []

        for i in textureAtlas.textureNames {
            textures.append(textureAtlas.textureNamed(i))
        }

        let animations = SKAction.animate(with: textures, timePerFrame: 0.2)

        return animations
    }

    override func didMove(to view: SKView) {
        redPlayerNode = createSpriteNode(imageName: "red-player", scale: 0.8, position: CGPoint(x: size.width/2, y: 250))
        redPlayerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-idle")))
        addChild(redPlayerNode)
    }
}
