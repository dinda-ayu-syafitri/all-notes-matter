//
//  GameScene.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 27/04/24.
//

import SpriteKit
import GameController
import AVFoundation
import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
}

extension SKScene {
    func getAllAudioNodes() -> [SKAudioNode] {
        var audioNodes = [SKAudioNode]()

        func findAudioNodes(node: SKNode) {
            for childNode in node.children {
                if let audioNode = childNode as? SKAudioNode {
                    audioNodes.append(audioNode)
                }
                findAudioNodes(node: childNode)
            }
        }

        findAudioNodes(node: self)

        return audioNodes
    }
}

class GameScene: SKScene {
    @Environment(\.dismiss) var dismiss

    //    var updatePlayerRedState: ((Bool) -> Void)?
    var isPlayerRed: Bool!
    //    var isGamePaused: Bool!

    var bgNode: SKSpriteNode!

    //    Camera
    var playerCam = SKCameraNode()

    // UI Node
    var uiPanel: SKShapeNode!
    var backBtn: SKSpriteNode!
    var nextBtn: SKSpriteNode!
    //    var pauseBtn: SKSpriteNode!

    //    PlayerNode
    var playerNode: SKSpriteNode!
    var playerPosX: CGFloat = 0
    var playerPosY: CGFloat = 0
    var playerSpotlight: SKSpriteNode!
    var playerspotlightArrow: SKSpriteNode!
    var playerSpotlight2: SKSpriteNode!

    //    Player Controller
    var virtualController: GCVirtualController?
    var thumbstickNode: SKSpriteNode!
    var thumbstickTouch: UITouch?
    var touchTrackerNode: SKSpriteNode!


    // Instrument Group Node
    var bassGroup: SKSpriteNode!
    var percussionGroup: SKSpriteNode!
    var guitarGroup: SKSpriteNode!
    var pianoHarmonicaGroup: SKSpriteNode!
    var saxTrumpetGroup: SKSpriteNode!

    // Instrument Node
    var guitarNode: SKSpriteNode!
    var pianoSynthNode: SKSpriteNode!
    var drumNode: SKSpriteNode!
    var harmonicaNode: SKSpriteNode!
    var saxNode: SKSpriteNode!
    var trumpetNode: SKSpriteNode!
    var bassNode: SKSpriteNode!
    var bongoNode: SKSpriteNode!
    var centerAudioNode:SKSpriteNode!

    // Audio Node
    var allAudioNodes: Array<SKAudioNode>!
    var guitarAudio: SKAudioNode!
    var bassAudio: SKAudioNode!
    var percussionAudio: SKAudioNode!
    var SaxTrumpetAudio: SKAudioNode!
    var pianoHarmonicaAudio: SKAudioNode!
    var completeAudio: SKAudioNode!


    var bgAudioPlayer: AVAudioPlayer!

    var songPart = 0


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

    func createAudio(audioName: String, audioExtension: String, forNode: SKSpriteNode) -> SKAudioNode? {
        if let audioURL = Bundle.main.url(forResource: audioName, withExtension: audioExtension) {
            let audioNode = SKAudioNode(url: audioURL)
            audioNode.isPositional = true
            audioNode.position = forNode.position
            audioNode.run(SKAction.changeVolume(to: 1, duration: 0))
            forNode.addChild(audioNode)
            return audioNode
        } else {
            return nil
        }
    }

    func skipPart(type:String) {
        let songParts = [
            [
                ["theme1-bass", bassGroup!],
                ["theme1-drums", percussionGroup!],
                ["theme1-full", centerAudioNode!],
                ["theme1-guitar", guitarNode!],
                ["theme1-other", pianoHarmonicaGroup!],
                ["theme1-vocals", saxTrumpetGroup!]
            ],[
                ["solos-bass", bassGroup!],
                ["solos-drums", percussionGroup!],
                ["solos-full", centerAudioNode!],
                ["solos-guitar", guitarNode!],
                ["solos-other", pianoHarmonicaGroup!],
                ["solos-vocals", saxTrumpetGroup!]
            ],
            [
                ["theme2-bass", bassGroup!],
                ["theme2-drums", percussionGroup!],
                ["theme2-full", centerAudioNode!],
                ["theme2-guitar", guitarNode!],
                ["theme2-other", pianoHarmonicaGroup!],
                ["theme2-vocals", saxTrumpetGroup!]
            ]
        ]

        if type == "next" {
            let audioNodes = getAllAudioNodes()
            for audioNode in audioNodes {
                audioNode.removeAllActions()
                audioNode.removeFromParent()
            }

            if songPart < 2 {
                songPart += 1

                for audio in songParts[songPart] {
                  _ = createAudio(audioName: audio[0] as! String, audioExtension: "mp3", forNode: audio[1] as! SKSpriteNode)
                }
            }

        } else {
            let audioNodes = getAllAudioNodes()
            for audioNode in audioNodes {
                audioNode.removeAllActions()
                audioNode.removeFromParent()
            }

            if songPart > 0 {
                songPart -= 1

                for audio in songParts[songPart] {
                  _ = createAudio(audioName: audio[0] as! String, audioExtension: "mp3", forNode: audio[1] as! SKSpriteNode)
                }
            }

        }
    }

    func volumeController(allAudioNodes: [SKAudioNode]) {

        for audioNode in allAudioNodes {
            let distanceToAudio = playerNode.position.distance(to: audioNode.position)

            let maxDistance: CGFloat = 300
            let minDistance: CGFloat = 50

            let maxVolume: Float = 5
            let minVolume: Float = 0.3

            var volumeLevel = maxVolume

            let distanceRange = maxDistance - minDistance
            let volumeRange = maxVolume - minVolume
            let distanceRatio = (distanceToAudio - minDistance) / distanceRange

            if distanceToAudio > minDistance && distanceToAudio < maxDistance {
                //                volumeLevel = maxVolume
                volumeLevel = maxVolume - (Float(distanceRatio) * volumeRange)
            } else if distanceToAudio >= maxDistance {
                volumeLevel = maxVolume - (Float(distanceRatio) * volumeRange)

                if volumeLevel < minVolume {
                    volumeLevel = minVolume
                }
            }

            //            print("Volume of \(audioNode.parent?.name ?? "no audio") = \(volumeLevel)")
            audioNode.run(SKAction.changeVolume(to: volumeLevel, duration: 0.1))
        }
    }


    override func didMove(to view: SKView) {

        bgNode = createSpriteNode(imageName: "bg-big", scale: 1, position: CGPoint(x:size.width / 2, y: size.height / 2))

        playerCam.setScale(1.3)
        camera = playerCam

        // Player Set Up
        if isPlayerRed {
            playerNode = createSpriteNode(imageName: "red-player", scale: 0.25, position: CGPoint(x: size.width / 2, y: 500))
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-idle")))
        } else {
            playerNode = createSpriteNode(imageName: "blue-player", scale: 0.25, position: CGPoint(x: size.width / 2, y: 500))
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-idle")))
        }

        addChild(playerNode)

        playerSpotlight = createSpriteNode(imageName: "player-shadow", scale: 2.5, position: CGPoint(x: 0, y: -290))
        playerSpotlight.zPosition = -1
        playerNode.addChild(playerSpotlight)

        playerspotlightArrow = createSpriteNode(imageName: "player-arrow", scale: 2.3, position: CGPoint(x: 0, y: -400))
        playerNode.addChild(playerspotlightArrow)

        playerSpotlight2 = createSpriteNode(imageName: "Spotlight", scale: 5, position:CGPoint(x: 0, y: 600) )
        playerSpotlight2.zPosition = -2
        playerNode.addChild(playerSpotlight2)


        // UI Set Up
        uiPanel = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: 350))
        uiPanel.position = CGPoint(x: size.width / 2, y: -630)
        uiPanel.zPosition = 50
        uiPanel.fillColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        uiPanel.strokeColor = UIColor.clear
        addChild(uiPanel)

        backBtn = createSpriteNode(imageName: "Rewind", scale: 1.5, position: CGPoint(x: playerNode.position.x - 170, y: playerNode.position.y - 600))
        backBtn.zPosition = 55
        addChild(backBtn)

        nextBtn = createSpriteNode(imageName: "Fastforward", scale: 1.5, position: CGPoint(x: playerNode.position.x + 170, y: playerNode.position.y - 600))
        nextBtn.zPosition = 55
        addChild(nextBtn)

        //        pauseBtn = createSpriteNode(imageName: "pause", scale: 0.5, position: CGPoint(x:playerCam.position.x, y: playerCam.position.y + 750))
        //        pauseBtn.zPosition = 100
        //        addChild(pauseBtn)

        // Controller Set up
        // Thumbstick
        thumbstickNode = createSpriteNode(imageName: "thumbpad", scale: 0.8, position: CGPoint(x: playerNode.position.x, y: playerNode.position.y - 600))
        thumbstickNode.zPosition = 60
        //        thumbstickNode.fillColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        //        thumbstickNode.strokeColor = UIColor.clear
        addChild(thumbstickNode)

        //Thumb Tracker
        touchTrackerNode = createSpriteNode(imageName: "touch tracker", scale: 1.8, position: CGPoint(x: thumbstickNode.position.x - 5, y: thumbstickNode.position.y + 5))
        //        touchTrackerNode.fillColor = UIColor(red: 0.95, green: 0.57, blue: 0.02, alpha: 1)
        //        touchTrackerNode.strokeColor = UIColor.clear
        touchTrackerNode.zPosition = 70
        addChild(touchTrackerNode)

        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick]

        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()

        virtualController = controller


        // Instrument Set Up
        percussionGroup = createSpriteNode(imageName: "Drum and bongo hitbox", scale: 1.3, position: CGPoint(x: -155, y: 580))
        addChild(percussionGroup)

        drumNode = createSpriteNode(imageName: "drum", scale: 0.15, position: CGPoint(x: 10, y: 50))
        drumNode.run(SKAction.repeatForever(createAnimation(atlasName:"drum-textures")))

        bongoNode = createSpriteNode(imageName: "gendang", scale: 0.08, position: CGPoint(x: 170, y: 50))
        bongoNode.run(SKAction.repeatForever(createAnimation(atlasName: "bongo-textures")))

        percussionGroup.addChild(drumNode)
        percussionGroup.addChild(bongoNode)


        pianoHarmonicaGroup = createSpriteNode(imageName: "Piano and harmonica hitbox", scale: 1.5, position: CGPoint(x: 605, y: 580))
        addChild(pianoHarmonicaGroup)

        pianoSynthNode = createSpriteNode(imageName: "piano", scale: 0.2, position: CGPoint(x: -50, y: 10))
        pianoSynthNode.run(SKAction.repeatForever(createAnimation(atlasName: "keyboard-textures")))

        harmonicaNode = createSpriteNode(imageName: "harmonica", scale: 0.08, position: CGPoint(x: -80, y: -70))
        harmonicaNode.zRotation = -0.15
        harmonicaNode.run(SKAction.repeatForever(createAnimation(atlasName: "harmonica-textures")))

        pianoHarmonicaGroup.addChild(pianoSynthNode)
        pianoHarmonicaGroup.addChild(harmonicaNode)



        saxTrumpetGroup = createSpriteNode(imageName: "sax hitbox", scale: 1.5, position: CGPoint(x: 680, y: 250))
        addChild(saxTrumpetGroup)

        saxNode = createSpriteNode(imageName: "sax", scale: 0.3, position: CGPoint(x: -50, y: 50))
        saxNode.xScale = -0.3
        saxNode.zRotation = -0.6
        saxNode.run(SKAction.repeatForever(createAnimation(atlasName: "sax-textures")))

        trumpetNode = createSpriteNode(imageName: "trumpet", scale: 0.15, position: CGPoint(x: 40, y: -50))
        trumpetNode.zRotation = 0.2
        trumpetNode.run(SKAction.repeatForever(createAnimation(atlasName: "trumpet-textures")))

        saxTrumpetGroup.addChild(saxNode)
        saxTrumpetGroup.addChild(trumpetNode)


        bassGroup = createSpriteNode(imageName: "Bass hitbox", scale: 1.3, position: CGPoint(x: -300, y: 255))
        addChild(bassGroup)

        bassNode = createSpriteNode(imageName: "bass", scale: 0.15, position: CGPoint(x: 30, y: 30))
        bassNode.run(SKAction.repeatForever(createAnimation(atlasName: "bass-textures")))

        bassGroup.addChild(bassNode)


        guitarGroup = createSpriteNode(imageName: "Guitar hitbox", scale: 1.3, position: CGPoint(x: 150, y: 0))
        addChild(guitarGroup)

        guitarNode = createSpriteNode(imageName: "guitar", scale: 0.15, position: CGPoint(x: 0, y: 30))
        //        guitarNode.zRotation = 0.15
        guitarNode.run(SKAction.repeatForever(createAnimation(atlasName: "guitar-textures")))
        guitarGroup.addChild(guitarNode)




        // Audio Set Up
        //                if let bgAudioURL = Bundle.main.url(forResource: "Stevie Wonder - Spain", withExtension: "mp3") {
        //                    let bgAudioNode = SKAudioNode(url: bgAudioURL)
        //                    bgAudioNode.position = CGPoint(x:size.width, y: 500)
        //                    bgAudioNode.run(SKAction.changeVolume(to: 1, duration: 0))
        //                    addChild(bgAudioNode)
        //                }

        centerAudioNode = createSpriteNode(imageName: "player-shadow", scale: 0.7, position: CGPoint(x: size.width - 200, y: 350))
        //        centerAudioNode.fillColor = UIColor(.clear)
        centerAudioNode.alpha = 0
        addChild(centerAudioNode)

        completeAudio = createAudio(audioName: "theme1-full", audioExtension: "mp3", forNode: centerAudioNode)

        percussionAudio = createAudio(audioName: "theme1-drums", audioExtension: "mp3", forNode: percussionGroup)
        bassAudio = createAudio(audioName: "theme1-bass", audioExtension: "mp3", forNode: bassGroup)
        guitarAudio = createAudio(audioName: "theme1-guitar", audioExtension: "mp3", forNode: guitarGroup)
        SaxTrumpetAudio = createAudio(audioName: "theme1-vocals", audioExtension: "mp3", forNode: saxTrumpetGroup)
        pianoHarmonicaAudio = createAudio(audioName: "theme1-other", audioExtension: "mp3", forNode: pianoHarmonicaGroup)


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            if thumbstickNode.contains(touch.location(in: self)) {
                thumbstickTouch = touch

                if isPlayerRed {
                    let playerWalking = SKSpriteNode(imageNamed: "red-player")
                    playerWalking.setScale(0.45)
                    playerWalking.position = playerNode.position
                    playerNode.removeFromParent()
                    playerNode = playerWalking
                    addChild(playerNode)
                    playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-walk")))
                } else {
                    let playerWalking = SKSpriteNode(imageNamed: "blue-player")
                    playerWalking.setScale(0.45)
                    playerWalking.position = playerNode.position
                    playerNode.removeFromParent()
                    playerNode = playerWalking
                    addChild(playerNode)
                    playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-walk")))
                }

                playerspotlightArrow.removeFromParent()

                playerSpotlight = createSpriteNode(imageName: "player-shadow", scale: 1.4, position: CGPoint(x: 0, y: -200))
                playerSpotlight.zPosition = -1
                playerNode.addChild(playerSpotlight)

                playerSpotlight2 = createSpriteNode(imageName: "Spotlight", scale: 3, position:CGPoint(x: 0, y: 330) )
                playerSpotlight2.zPosition = -2
                playerNode.addChild(playerSpotlight2)

            }

            if backBtn.contains(touch.location(in: self)) {
                skipPart(type: "back")
            }

            if nextBtn.contains(touch.location(in: self)) {
                skipPart(type: "next")
            }

        }




    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if thumbstickTouch == touch {
            let positionInThumbstick = touch.location(in: thumbstickNode)
            let distance = hypot(positionInThumbstick.x, positionInThumbstick.y)
            let maxDistance = thumbstickNode.frame.width / 2

            playerPosX = positionInThumbstick.x / maxDistance
            playerPosY = positionInThumbstick.y / maxDistance

            if distance > maxDistance {
                let angle = atan2(positionInThumbstick.y, positionInThumbstick.x)
                playerPosX = cos(angle)
                playerPosY = sin(angle)
            }

            let trackerDistance = min(distance, maxDistance - touchTrackerNode.frame.width / 2)
            let trackerPositionX = thumbstickNode.position.x - 5 + (trackerDistance * cos(atan2(positionInThumbstick.y, positionInThumbstick.x)))
            let trackerPositionY = thumbstickNode.position.y + 5 + (trackerDistance * sin(atan2(positionInThumbstick.y, positionInThumbstick.x)))
            touchTrackerNode.position = CGPoint(x: trackerPositionX, y: trackerPositionY)

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if thumbstickTouch == touch {
            playerPosX = 0
            playerPosY = 0
            thumbstickTouch = nil
            touchTrackerNode.position = CGPoint(x: thumbstickNode.position.x - 5, y: thumbstickNode.position.y + 5)
        }

        if isPlayerRed {
            let playerIdle = SKSpriteNode(imageNamed: "red-player")
            playerIdle.setScale(0.25)
            playerIdle.position = playerNode.position
            playerNode.removeFromParent()
            playerNode = playerIdle
            addChild(playerNode)
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-idle")))
        } else {
            let playerIdle = SKSpriteNode(imageNamed: "blue-player")
            playerIdle.setScale(0.25)
            playerIdle.position = playerNode.position
            playerNode.removeFromParent()
            playerNode = playerIdle
            addChild(playerNode)
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-idle")))
        }

        playerSpotlight = createSpriteNode(imageName: "player-shadow", scale: 2.5, position: CGPoint(x: 0, y: -290))
        playerSpotlight.zPosition = -1
        playerNode.addChild(playerSpotlight)

        playerSpotlight2 = createSpriteNode(imageName: "Spotlight", scale: 5, position:CGPoint(x: 0, y: 600) )
        playerSpotlight2.zPosition = -2
        playerNode.addChild(playerSpotlight2)

    }

    override func update(_ currentTime: TimeInterval) {
        playerNode.position.x += playerPosX * 3
        playerNode.position.y += playerPosY * 3

        playerCam.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 200)

        //        UI Relative to Camera
        uiPanel.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 630)
        thumbstickNode.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 600)
        nextBtn.position = CGPoint(x: playerNode.position.x + 170, y: thumbstickNode.position.y - 10)
        backBtn.position = CGPoint(x: playerNode.position.x - 170, y: thumbstickNode.position.y - 10)
        //        homeBtn.position = CGPoint(x: playerNode.position.x - 150, y: playerNode.position.y + 400)


        if playerPosX > 0 {
            playerNode.xScale = abs(playerNode.xScale)
        } else if playerPosX < 0 {
            playerNode.xScale = -abs(playerNode.xScale)
        }


        allAudioNodes = self.getAllAudioNodes()

        // Volume Control
        volumeController(allAudioNodes: allAudioNodes)

        if isPaused {
            for audioNode in allAudioNodes {
                audioNode.run(SKAction.pause())
            }
            print("game paused")
        }


    }


}




