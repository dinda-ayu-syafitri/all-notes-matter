//
//  ContentView.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 25/04/24.
//

import SwiftUI
import SpriteKit
import AVFoundation
//
struct ContentView: View {
    @Binding var isPlayerRed: Bool

    let sceneWidth = UIScreen.main.bounds.width
    let sceneHeight = UIScreen.main.bounds.height


    var scene: SKScene {
        let scene = GameScene()
        scene.isPlayerRed = isPlayerRed

        scene.size = CGSize(width: sceneWidth, height: sceneHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)

        return scene
    }

    @State private var isPresenting = false

    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene)
                    .frame(width: sceneWidth, height: sceneHeight, alignment: .center)
                    .ignoresSafeArea()
                HStack (alignment: .top){
                    VStack {
                        Button(action: { isPresenting.toggle()}, label: {
                            Image("pause")
                                .resizable()
                                .scaledToFit()
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        })
                        .fullScreenCover(isPresented: $isPresenting
                        ) {
                            VStack {
                                Image(systemName: "pause.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundStyle(Color(red: 0.95, green: 0.57, blue: 0.02))
                                HStack {
                                    Image("play 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .padding(.trailing, 40)
                                        .onTapGesture {
                                            isPresenting.toggle()
                                        }
                                    Image("home-new")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                }  
                                .padding(.top, 50)
                            }

                            .presentationBackground(Color(red: 0.22, green: 0.22, blue: 0.22).opacity(0.8))
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity)
                            .ignoresSafeArea(edges: .all)
                        }
                        Spacer()
                    }
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

            }
            .padding()
            .navigationBarBackButtonHidden()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isPlayerRed: .constant(true)) // You can set the initial value here
    }
}
