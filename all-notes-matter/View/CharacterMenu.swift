//
//  CharacterMenu.swift
//  all-notes-matter
//
//  Created by Stanley Nicholas on 29/04/24.
//

import SwiftUI
import SpriteKit

struct CharacterMenu: View {

    let sceneWidth = UIScreen.main.bounds.width
    let sceneHeight = UIScreen.main.bounds.height

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

//    var scene: SKScene {
//        let scene = GameScene()
//
//        scene.size = CGSize(width: sceneWidth, height: sceneHeight)
//        scene.scaleMode = .fill
//        scene.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
//
//        return scene
//    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("brick-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)

                VStack (spacing: 0) {
                    Image("spot")
                        .ignoresSafeArea()
                        .overlay(
                            HStack{
                                Image("back").padding(.top, 240)
                                Spacer()
//                                SpriteView(scene: scene)
//                                     .frame(width: sceneWidth, height: sceneHeight, alignment: .center)
//                                Image("orang").padding(.top, 240)
                                Spacer()
                                Image("next").padding(.top, 240)
                            }.padding(80)

                        )

                    Spacer()

                    NavigationLink(destination: ContentView()) {
                        Image("play")
                    }
                    .navigationBarBackButtonHidden()
                    //                    Image("play")

                    Spacer()

                    //                    NavigationLink(destination: StartMenu()) {
                    //                        Image("home")
                    //                    }
                }
                .padding(.bottom, 150)
            }
            .background{
                Color.black
            }
        }
    }
}

#Preview {
    CharacterMenu()
}
