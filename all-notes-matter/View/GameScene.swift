//
//  GameScene.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 27/04/24.
//

import SpriteKit
import GameController
import AVFoundation

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
    //    var updatePlayerRedState: ((Bool) -> Void)?
    var isPlayerRed: Bool!
    
    var bgNode: SKSpriteNode!
    
    //    Camera
    var playerCam = SKCameraNode()
    
    // UI Node
    var uiPanel: SKShapeNode!
    var progressBar: SKShapeNode!
    var progressPlaceholder: SKShapeNode!
    var backBtn: SKSpriteNode!
    var nextBtn: SKSpriteNode!
    
    var progress: CGFloat = 0
    
    //    PlayerNode
    var playerNode: SKSpriteNode!
    var playerPosX: CGFloat = 0
    var playerPosY: CGFloat = 0
    
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
    
    // Audio Node
    var allAudioNodes: Array<SKAudioNode>!
    var guitarAudio: SKAudioNode!
    var bassAudio: SKAudioNode!
    var percussionAudio: SKAudioNode!
    var SaxTrumpetAudio: SKAudioNode!
    var pianoHarmonicaAudio: SKAudioNode!
    var completeAudio: SKAudioNode!
    
    
    var bgAudioPlayer: AVAudioPlayer!

    
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
    
    
    //    func back5Sec() {
    //        allAudioNodes = self.getAllAudioNodes()
    //
    //        for audioNode in allAudioNodes {
    //            audioNode.setCurrentTime(0.5)
    //
    //             // Start playing the audio node
    //             audioNode.run(SKAction.play())
    //        }
    //    }
    
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
            playerNode = createSpriteNode(imageName: "red-player", scale: 0.2, position: CGPoint(x: size.width / 2, y: 500))
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-idle")))
        } else {
            playerNode = createSpriteNode(imageName: "blue-player", scale: 0.2, position: CGPoint(x: size.width / 2, y: 500))
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-idle")))
        }

        
        addChild(playerNode)
        
        
        // UI Set Up
        uiPanel = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: 450))
        uiPanel.position = CGPoint(x: size.width / 2, y: 35)
        uiPanel.zPosition = 50
        uiPanel.fillColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        uiPanel.strokeColor = UIColor.clear
        addChild(uiPanel)
        
        backBtn = createSpriteNode(imageName: "back5", scale: 1, position: CGPoint(x: playerNode.position.x - 180, y: playerNode.position.y - 400))
        backBtn.zPosition = 55
        addChild(backBtn)
        
        nextBtn = createSpriteNode(imageName: "next5", scale: 1, position: CGPoint(x: playerNode.position.x + 180, y: playerNode.position.y - 400))
        nextBtn.zPosition = 55
        addChild(nextBtn)
        
        // Progress Bar
        progressBar = SKShapeNode(rectOf: CGSize(width: size.width - 50, height: 8))
        progressBar.fillColor = UIColor(red: 0.95, green: 0.57, blue: 0.02, alpha: 1)
        progressBar.strokeColor = UIColor.clear
        progressBar.zPosition = 100
        addChild(progressBar)
        
        progressPlaceholder = SKShapeNode(rectOf: CGSize(width: size.width + 50, height: 8))
        progressPlaceholder.fillColor = UIColor(.gray)
        progressPlaceholder.strokeColor = UIColor.clear
        progressPlaceholder.position = CGPoint(x: size.width/2 , y: 255)
        progressPlaceholder.zPosition = 99
        addChild(progressPlaceholder)
        
        // Controller Set up
        // Thumbstick
        thumbstickNode = createSpriteNode(imageName: "thumbpad", scale: 0.8, position: CGPoint(x: playerNode.position.x, y: playerNode.position.y - 400))
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
        percussionGroup = createSpriteNode(imageName: "Drum and bongo hitbox", scale: 1, position: CGPoint(x: -75, y: 830))
        addChild(percussionGroup)
        
        drumNode = createSpriteNode(imageName: "drum", scale: 0.15, position: CGPoint(x: -30, y: 80))
        drumNode.run(SKAction.repeatForever(createAnimation(atlasName:"drum-textures")))
        
        bongoNode = createSpriteNode(imageName: "gendang", scale: 0.08, position: CGPoint(x: 130, y: 80))
        bongoNode.run(SKAction.repeatForever(createAnimation(atlasName: "bongo-textures")))
        
        percussionGroup.addChild(drumNode)
        percussionGroup.addChild(bongoNode)
        
        
        pianoHarmonicaGroup = createSpriteNode(imageName: "Piano and harmonica hitbox", scale: 1, position: CGPoint(x: 465, y: 740))
        addChild(pianoHarmonicaGroup)
        
        pianoSynthNode = createSpriteNode(imageName: "piano", scale: 0.2, position: CGPoint(x: 30, y: 30))
        pianoSynthNode.run(SKAction.repeatForever(createAnimation(atlasName: "keyboard-textures")))
        
        harmonicaNode = createSpriteNode(imageName: "harmonica", scale: 0.08, position: CGPoint(x: -20, y: -40))
        harmonicaNode.zRotation = -0.15
        harmonicaNode.run(SKAction.repeatForever(createAnimation(atlasName: "harmonica-textures")))
        
        pianoHarmonicaGroup.addChild(pianoSynthNode)
        pianoHarmonicaGroup.addChild(harmonicaNode)
        
        
        
        saxTrumpetGroup = createSpriteNode(imageName: "sax hitbox", scale: 1, position: CGPoint(x: 580, y: 450))
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
        
        
        bassGroup = createSpriteNode(imageName: "Bass hitbox", scale: 1, position: CGPoint(x: -180, y: 555))
        addChild(bassGroup)
        
        bassNode = createSpriteNode(imageName: "bass", scale: 0.15, position: CGPoint(x: 70, y: 30))
        bassNode.run(SKAction.repeatForever(createAnimation(atlasName: "bass-textures")))
        
        bassGroup.addChild(bassNode)
        
        
        guitarGroup = createSpriteNode(imageName: "Guitar hitbox", scale: 1, position: CGPoint(x: 150, y: 280))
        addChild(guitarGroup)
        
        guitarNode = createSpriteNode(imageName: "guitar", scale: 0.15, position: CGPoint(x: 0, y: 30))
        //        guitarNode.zRotation = 0.15
        guitarNode.run(SKAction.repeatForever(createAnimation(atlasName: "guitar-textures")))
        guitarGroup.addChild(guitarNode)
        
        
        
        
        // Audio Set Up
        //        if let bgAudioURL = Bundle.main.url(forResource: "Stevie Wonder - Spain", withExtension: "mp3") {
        //            let bgAudioNode = SKAudioNode(url: bgAudioURL)
        //            bgAudioNode.run(SKAction.changeVolume(to: 1, duration: 0))
        //            addChild(bgAudioNode)
        //        }
        
        percussionAudio = createAudio(audioName: "drum", audioExtension: "m4a", forNode: percussionGroup)
        bassAudio = createAudio(audioName: "bass2", audioExtension: "m4a", forNode: bassGroup)
        guitarAudio = createAudio(audioName: "guitar", audioExtension: "m4a", forNode: guitarGroup)
        SaxTrumpetAudio = createAudio(audioName: "vocals", audioExtension: "m4a", forNode: saxTrumpetGroup)
        pianoHarmonicaAudio = createAudio(audioName: "other", audioExtension: "m4a", forNode: pianoHarmonicaGroup)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let increment = (0.1 / TimeInterval(7030.3731)) * 100.0
            self.progress += CGFloat(increment)
            
            if self.progress >= 100 {
                timer.invalidate()
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if thumbstickNode.contains(touch.location(in: self)) {
                thumbstickTouch = touch
                
                if isPlayerRed {
                    let playerWalking = SKSpriteNode(imageNamed: "red-player")
                    playerWalking.setScale(0.4)
                    playerWalking.position = playerNode.position
                    playerNode.removeFromParent()
                    playerNode = playerWalking
                    addChild(playerNode)
                    playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-walk")))
                } else {
                    let playerWalking = SKSpriteNode(imageNamed: "blue-player")
                    playerWalking.setScale(0.4)
                    playerWalking.position = playerNode.position
                    playerNode.removeFromParent()
                    playerNode = playerWalking
                    addChild(playerNode)
                    playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-walk")))
                }

            }
            
            if backBtn.contains(touch.location(in: self)) {
                print("Back Pressed")
            }
            if nextBtn.contains(touch.location(in: self)) {
                print("Next Pressed")
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
            playerIdle.setScale(0.2)
            playerIdle.position = playerNode.position
            playerNode.removeFromParent()
            playerNode = playerIdle
            addChild(playerNode)
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "red-idle")))
        } else {
            let playerIdle = SKSpriteNode(imageNamed: "blue-player")
            playerIdle.setScale(0.2)
            playerIdle.position = playerNode.position
            playerNode.removeFromParent()
            playerNode = playerIdle
            addChild(playerNode)
            playerNode.run(SKAction.repeatForever(createAnimation(atlasName: "blue-idle")))
        }

        
    }
    
    override func update(_ currentTime: TimeInterval) {
        playerNode.position.x += playerPosX * 1
        playerNode.position.y += playerPosY * 1
        
        playerCam.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y)
        
        //        UI Relative to Camera
        uiPanel.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 400)
        thumbstickNode.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y-400)
        progressBar.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 250)
        progressPlaceholder.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 245)
        nextBtn.position = CGPoint(x: playerNode.position.x + 180, y: playerNode.position.y - 400)
        backBtn.position = CGPoint(x: playerNode.position.x - 180, y: playerNode.position.y - 400)
        
        
        if playerPosX > 0 {
            playerNode.xScale = abs(playerNode.xScale)
        } else if playerPosX < 0 {
            playerNode.xScale = -abs(playerNode.xScale)
        }
        
        //        let progressBarWidth = min(progress * (size.width - 220 / 100), size.width + 50)
        //        progressBar.path = UIBezierPath(rect: CGRect(x: -220, y: 0, width: progressBarWidth, height: 8)).cgPath
        
        let progressBarWidth = min(progress * (size.width - 210 / 100), size.width + 35)
        
        let progressBarPath = UIBezierPath(rect: CGRect(x: -220, y: 0, width: progressBarWidth, height: 8))
        
        let circleX = progressBarWidth - 220 + 8
        let circleY = 4
        let circleRadius = 8
        
        let circleRect = CGRect(x: Int(circleX) - circleRadius, y: circleY - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        
        let circlePath = UIBezierPath(ovalIn: circleRect)
        
        progressBarPath.append(circlePath)
        
        progressBar.path = progressBarPath.cgPath
        
        //        print(progress)
        
        
        allAudioNodes = self.getAllAudioNodes()
        
        // Volume Control
        volumeController(allAudioNodes: allAudioNodes)
        
        
    }
}




