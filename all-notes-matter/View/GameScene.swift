//
//  GameScene.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 27/04/24.
//

import SpriteKit
import GameController

class GameScene:SKScene {
    var bgNode: SKSpriteNode!

    // UI Node
    var uiPanel: SKShapeNode!

    //    Camera
    var playerCam = SKCameraNode()

    //    PlayerNode
    var playerNode: SKSpriteNode!
    var playerPosX: CGFloat = 0
    var playerPosY: CGFloat = 0
    var isGoRight: Bool = false
    var animationRun = false

    //    Player Controller
    var virtualController: GCVirtualController?
    var thumbstickNode: SKShapeNode!
    var thumbstickTouch: UITouch?
    var touchTrackerNode: SKShapeNode!

    // Instrument Node
    var guitarNode: SKSpriteNode!
    var pianoSynthNode: SKSpriteNode!
    var drumNode: SKSpriteNode!
    var harmonicaNode: SKSpriteNode!
    var saxNode: SKSpriteNode!
    var trumpetNode: SKSpriteNode!
    var bassNode: SKSpriteNode!
    var bongoNode: SKSpriteNode!

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
        bgNode = createSpriteNode(imageName: "bg-texture", scale: 1, position: CGPoint(x:size.width / 2 + 45, y: size.height / 2 + 70))


        playerCam.setScale(1)
        camera = playerCam

        // Player Set Up
        playerNode = createSpriteNode(imageName: "player", scale: 0.2, position: CGPoint(x: size.width / 2, y: 400))
        playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "player-idle")))


        // UI Set Up
        uiPanel = SKShapeNode(rectOf: CGSize(width: size.width, height: 270))
        uiPanel.position = CGPoint(x: size.width / 2, y: 115)
        uiPanel.zPosition = 50
        uiPanel.fillColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        uiPanel.strokeColor = UIColor.clear
        addChild(uiPanel)

        //Controller Set up
        //Thumbstick
        thumbstickNode = SKShapeNode(circleOfRadius: 80)
        thumbstickNode.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 300)
        thumbstickNode.zPosition = 60
        thumbstickNode.fillColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        thumbstickNode.strokeColor = UIColor.clear
        addChild(thumbstickNode)

        //Thumb Tracker
        touchTrackerNode = SKShapeNode(circleOfRadius: 20)
        touchTrackerNode.position = thumbstickNode.position
        touchTrackerNode.fillColor = UIColor(red: 0.95, green: 0.57, blue: 0.02, alpha: 1)
        touchTrackerNode.strokeColor = UIColor.clear
        touchTrackerNode.zPosition = 70
        addChild(touchTrackerNode)

        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick]

        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()

        virtualController = controller


        
        // Instrument Set Up
        drumNode = createSpriteNode(imageName: "drum", scale: 0.19, position: CGPoint(x: -85, y: 657))
        drumNode.run(SKAction.repeatForever(createAnimation(atlasName:"drum-textures")))

        bongoNode = createSpriteNode(imageName: "gendang", scale: 0.12, position: CGPoint(x: 130, y: 685))
        bongoNode.run(SKAction.repeatForever(createAnimation(atlasName: "bongo-textures")))

        pianoSynthNode = createSpriteNode(imageName: "piano", scale: 0.25, position: CGPoint(x: 475, y: 710))
        pianoSynthNode.run(SKAction.repeatForever(createAnimation(atlasName: "keyboard-textures")))

        harmonicaNode = createSpriteNode(imageName: "harmonica", scale: 0.1, position: CGPoint(x: 420, y: 600))
        //        harmonicaNode.zRotation = 27
        harmonicaNode.run(SKAction.repeatForever(createAnimation(atlasName: "harmonica-textures")))

        trumpetNode = createSpriteNode(imageName: "trumpet", scale: 0.25, position: CGPoint(x: -75, y: 440))
        trumpetNode.run(SKAction.repeatForever(createAnimation(atlasName: "trumpet-textures")))

        saxNode = createSpriteNode(imageName: "saxo", scale: 0.5, position: CGPoint(x: 430, y: 500))
        saxNode.xScale = -0.5
        saxNode.zRotation = -0.25
        saxNode.run(SKAction.repeatForever(createAnimation(atlasName: "sax-textures")))

        guitarNode = createSpriteNode(imageName: "guitar", scale: 0.22, position: CGPoint(x: -80, y: 315))
        guitarNode.zRotation = 0.25
        //        guitarNode.run(SKAction.repeatForever(createAnimation(atlasName: "guitar-textures")))

        bassNode = createSpriteNode(imageName: "bass", scale: 0.22, position: CGPoint(x: 510, y: 325))


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if thumbstickNode.contains(touch.location(in: self)) {
            thumbstickTouch = touch

            let playerWalking = SKSpriteNode(imageNamed: "player2")
            playerWalking.setScale(0.2)
            playerWalking.position = playerNode.position
            playerNode.removeFromParent()
            playerNode = playerWalking
            addChild(playerNode)
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "player-walking")))

            animationRun = true

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
            let trackerPositionX = thumbstickNode.position.x + (trackerDistance * cos(atan2(positionInThumbstick.y, positionInThumbstick.x)))
            let trackerPositionY = thumbstickNode.position.y + (trackerDistance * sin(atan2(positionInThumbstick.y, positionInThumbstick.x)))
            touchTrackerNode.position = CGPoint(x: trackerPositionX, y: trackerPositionY)

            if playerPosX > 1 {
                isGoRight = true
            }

            animationRun = false

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if thumbstickTouch == touch {
            playerPosX = 0
            playerPosY = 0
            thumbstickTouch = nil
            touchTrackerNode.position = thumbstickNode.position
        }

        let playerIdle = SKSpriteNode(imageNamed: "player")
        playerIdle.setScale(0.2)
        playerIdle.position = playerNode.position
        playerNode.removeFromParent()
        playerNode = playerIdle
        addChild(playerNode)
        playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "player-idle")))

        isGoRight = false

        animationRun = false

    }

    override func update(_ currentTime: TimeInterval) {
        playerNode.position.x += playerPosX * 1
        playerNode.position.y += playerPosY * 1

        playerCam.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y)


        uiPanel.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 300)
        thumbstickNode.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y-300)

        if animationRun {
            print("animation run")
        }

        if playerPosX > 0 {
            playerNode.xScale = abs(playerNode.xScale)
        } else if playerPosX < 0 {
            playerNode.xScale = -abs(playerNode.xScale)
        }
    }
}




