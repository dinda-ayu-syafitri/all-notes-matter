//
//  SplashScreen.swift
//  all-notes-matter
//
//  Created by Dinda Ayu Syafitri on 30/04/24.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false
        var body: some View {
            ZStack {
                if self.isActive {
                    StartMenu()
//                        .transition(.move(edge: .top))
                } else {
                    VStack {
                        Image("anm-logo")
                            .resizable()
                            .scaledToFit()

    //                        .frame(width: 300, height: 300)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }

}

#Preview {
    SplashScreen()
}
