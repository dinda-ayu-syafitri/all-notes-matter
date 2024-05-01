//
//  StartMenu.swift
//  all-notes-matter
//
//  Created by Stanley Nicholas on 29/04/24.
//

import SwiftUI

struct StartMenu: View {
    var body: some View {

        NavigationStack {
            ZStack {
                Image("brick-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)

                ScrollView ([.vertical]) {
                    VStack {
                        Image("si-orang")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .edgesIgnoringSafeArea(.top)

                        VStack(alignment: .leading, spacing: 23) {
                            HStack(alignment: .top, spacing: 23) {
                                Rectangle()
                                    .padding(.top, 50.0)
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("spain")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .shadow(
                                        color: Color(red: 0.95, green: 0.57, blue: 0.02, opacity: 0.22), radius: 10.60
                                    )
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0).opacity(0), .black]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .overlay(
                                        NavigationLink(destination: CharacterMenu()) {
                                            Image("play")
                                        }

                                    )

                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("vulf")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .overlay(
                                        Color.black.opacity(0.7)
                                    )
                                    .overlay(
                                        Image("lock")
                                    )
                            }
                            HStack(alignment: .top, spacing: 23) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("cory-henry")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .overlay(
                                        Color.black.opacity(0.7)
                                    )
                                    .overlay(
                                        Image("lock")
                                    )

                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("cory-wong")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .overlay(
                                        Color.black.opacity(0.7)
                                    )
                                    .overlay(
                                        Image("lock")
                                    )

                            }
                            HStack(alignment: .top, spacing: 23) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("casio")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .overlay(
                                        Color.black.opacity(0.7)
                                    )
                                    .overlay(
                                        Image("lock")
                                    )

                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 161, height: 214)
                                    .background(
                                        Image("jacob")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    )
                                    .cornerRadius(17)
                                    .overlay(
                                        Color.black.opacity(0.7)
                                    )
                                    .overlay(
                                        Image("lock")
                                    )

                            }
                        }
                        .padding(.top, 100.0)
                        .frame(width: 345, height: 688)
                    }
                }
                .padding(.bottom, 300.0)
            }
            .padding(.top, 200.0)
            .background{
                Color.black


            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StartMenu()
}
