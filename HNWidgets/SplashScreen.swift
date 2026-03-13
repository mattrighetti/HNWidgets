//
//  SplashScreen.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 22/10/23.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.openURL) var openURL
    @State private var showInfo: Bool = false

    var body: some View {
        NavigationStack {
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


            .toolbar {
                ToolbarItem(id: "settings", placement: .topBarTrailing) {
                    Button(action: {
                        showInfo.toggle()
                    }, label: {
                        Image(systemName: "info.circle").foregroundStyle(.gray)
                    })
                }
            }
        }
        .sheet(isPresented: $showInfo, content: {
            InfoView()
        })
        .onOpenURL { url in
            guard let urlComponents = URLComponents(string: url.absoluteString),
                  url.scheme == "hnwidgets",
                  url.host == "openlink",
                  let link = urlComponents.queryItems?.first(where: { $0.name == "link" })?.value,
                  let destination = URL(string: link)
            else { return }
            openURL(destination)
        }
    }
}

#Preview {
    SplashScreen()
}
