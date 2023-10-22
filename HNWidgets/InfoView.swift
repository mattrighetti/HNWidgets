//
//  InfoView.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 22/10/23.
//

import SwiftUI

struct InfoView: View {
    var appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image("icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    Spacer()
                }.listRowSeparator(.hidden)
                HStack {
                    Spacer()
                    Text("HNWidgets v" + appVersion)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                }
            }.listRowBackground(Color.clear)
            
            Section {
                Link(destination: URL(string: "https://github.com/mattrighetti/HNWidgets.git")!, label: {
                    HStack {
                        Text("View on GitHub")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }.foregroundStyle(.primary)
                })
            }
        }
    }
}

#Preview {
    InfoView()
}
