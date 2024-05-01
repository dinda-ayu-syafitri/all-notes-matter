//
//  CharacterMenuToDean.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 02/05/24.
//
import SwiftUI
import SpriteKit

struct CharacterMenuToDean: View {

    let sceneWidth = UIScreen.main.bounds.width
    let sceneHeight = UIScreen.main.bounds.height

    var scene: SKScene {
        let scene = CharacterCustomScene()

        scene.size = CGSize(width: sceneWidth, height: sceneHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

        return scene
    }

    @State var isPlayerRed = true

    var body: some View {
        NavigationStack {
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
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                                Button(action: {isPlayerRed.toggle()}, label: {
                                    Image("back")
                                })
                                Spacer()
                                //                                SpriteView(scene: scene)
                                //                                     .frame(width: sceneWidth, height: sceneHeight, alignment: .center)
                                if isPlayerRed {
                                    Image("red-player").resizable().scaledToFit().frame(width: 100)
                                } else {
                                    Image("blue-player").resizable().scaledToFit().frame(width: 100)
                                }

                                Spacer()
                                Button(action: {isPlayerRed.toggle()}, label: {
                                    Image("next")
                                })
                            }.padding(.top,180).padding(.horizontal, 50)

                        )

                    Spacer()

                    NavigationLink(destination: DeanTownView(isPlayerRed: $isPlayerRed)) {
                        Image("play")
                    }


                    Spacer()

                }
                .padding(.bottom, 150)

                VStack {
                    HStack (alignment: .top) {
                        NavigationLink(destination: StartMenu(), label: {
                            Image("home-new")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                        })
                        Spacer()

                    }
                    .padding(.leading, 20)
                }
                .padding(.bottom, 650)
            }
            .background{
                Color.black
            }
        }
        .navigationBarBackButtonHidden()

    }
}

#Preview {
    CharacterMenu()
}
