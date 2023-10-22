//
//  SplashScreen.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 22/10/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color(red: 22/255, green: 22/255, blue: 22/255)
            VStack(alignment: .leading) {
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                Text("Hacker News\nWidgets")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen()
}
