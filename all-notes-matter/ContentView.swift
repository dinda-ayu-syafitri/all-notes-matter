//
//  ContentView.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 25/04/24.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct ContentView: View {


    let sceneWidth = UIScreen.main.bounds.width
    let sceneHeight = UIScreen.main.bounds.height


    var scene: SKScene {
        let scene = GameScene()

        scene.size = CGSize(width: sceneWidth, height: sceneHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = .gray


        return scene
    }

    var body: some View {
        VStack {
            SpriteView(scene: scene)
                 .frame(width: sceneWidth, height: sceneHeight, alignment: .center)
                 .ignoresSafeArea()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
