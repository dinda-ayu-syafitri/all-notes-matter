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



    override func didMove(to view: SKView) {
        //        playerNode =

        guitarNode = SKSpriteNode(imageNamed: "guitar")
        guitarNode.setScale(0.5)
        guitarNode.position = CGPoint(x: 100, y: 200)
        addChild(guitarNode)

//        guitarNode
    }
}


