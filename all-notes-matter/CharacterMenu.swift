//
//  CharacterMenu.swift
//  all-notes-matter
//
//  Created by Stanley Nicholas on 29/04/24.
//

import SwiftUI

struct CharacterMenu: View {
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
                                Image("orang").padding(.top, 240)
                                Spacer()
                                Image("next").padding(.top, 240)
                            }.padding(80)
                            
                        )
                    
                    Spacer()
                    
                    Image("play")
                    
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
