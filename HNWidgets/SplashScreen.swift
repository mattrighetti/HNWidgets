//
//  SplashScreen.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 22/10/23.
//

import SwiftUI

struct SplashScreen: View {
    @AppStorage(StoryOpeningPreference.openInAppKey) private var openInApp = false
    @State private var showInfo = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    hero
                    widgetGuide
                    openingSettings
                    features
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("HN Widgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("About HN Widgets")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            InfoView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 8) {
                Text("Hacker News, at a glance.")
                    .font(.largeTitle.weight(.bold))
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Keep the stories you care about close with a configurable Home Screen or Lock Screen widget.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top, 12)
    }

    private var widgetGuide: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Add a widget", systemImage: "plus.square.dashed")
                .font(.headline)
                .foregroundStyle(.orange)

            guideStep("Touch and hold your Home Screen, then tap Edit.", number: 1)
            guideStep("Choose Add Widget and search for HN Widgets.", number: 2)
            guideStep("Pick a size, then choose a story list and refresh interval.", number: 3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var features: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Make it yours")
                .font(.headline)

            featureRow("list.bullet", title: "Choose your feed", detail: "Top, Best, Show HN, or Ask HN")
            featureRow("arrow.up.right", title: "Choose where stories open", detail: "Read the original article or its HN discussion")
            featureRow("arrow.clockwise", title: "Set a refresh interval", detail: "Pick an update cadence from 5 to 60 minutes")
        }
    }

    private var openingSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Reading preferences", systemImage: "safari")
                .font(.headline)
                .foregroundStyle(.orange)

            Toggle("Open in app", isOn: $openInApp)
                .tint(.orange)

            Text("Read stories in the built-in browser. Turn this off to use your default browser.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func guideStep(_ title: String, number: Int) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.orange)
                .frame(width: 22, height: 22)
                .background(.orange.opacity(0.12), in: Circle())
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func featureRow(_ symbol: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(.orange)
                .frame(width: 24)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

}

#Preview {
    SplashScreen()
}
