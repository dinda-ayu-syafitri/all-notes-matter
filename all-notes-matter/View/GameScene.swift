//
//  GameScene.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 27/04/24.
//

import SpriteKit

class GameScene:SKScene {
    var playerNode: SKSpriteNode!

    // Instrument Node
    var guitarNode: SKSpriteNode!
    var pianoSynthNode: SKSpriteNode!
    var drumNode: SKSpriteNode!
    var harmonicaNode: SKSpriteNode!
    var saxNode: SKSpriteNode!
    var bassNode: SKSpriteNode!
    var percussionNode: SKSpriteNode!

    //    Bass Audio -> Gambar Bass
    //    Guitar Audio -> Gambar Guitar
    //    Drum Audio -> Gambar Drum + ‘Gendang’ (?)
    //    Vocals Audio -> Gambar Sax + trumpet
    //    Other Audio -> Gambar Piano + Synth + Harmonica

    // Audio Node
    var guitarAudio: SKAudioNode!
    var bassAudio: SKAudioNode!
    var percussionAudio: SKAudioNode!
    var SaxTrumpetAudio: SKAudioNode!
    var pianoHarmonicaAudio: SKAudioNode!

    func createSpriteNode(imageName:String, scale:CGFloat, position:CGPoint ) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageName)
        node.setScale(scale)
        node.position = position
        addChild(node)

        return node
    }


    override func didMove(to view: SKView) {
        //        playerNode =

        guitarNode = createSpriteNode(imageName: "guitar", scale: 0.2, position: CGPoint(x: 200, y: 200))
        pianoSynthNode = createSpriteNode(imageName: "piano", scale: 0.2, position: CGPoint(x: 200, y: 300))
        //        guitarNode = SKSpriteNode(imageNamed: "guitar")
        //        guitarNode.setScale(0.2)
        //        guitarNode.position = CGPoint(x: 100, y: 200)
        //        addChild(guitarNode)
        //
        //        bassNode = SKSpriteNode(imageNamed: "bass")


        //        guitarNode
    }
}


