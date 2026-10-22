import SafariServices
import SwiftUI

enum StoryOpeningPreference {
    static let openInAppKey = "openStoriesInApp"
}

struct StoryDestination: Identifiable {
    let id = UUID()
    let url: URL

    init?(incomingURL: URL) {
        let candidate: URL
        if incomingURL.scheme?.lowercased() == "hnwidgets" {
            guard incomingURL.host == "openlink",
                  let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: false),
                  let value = components.queryItems?.first(where: { $0.name == "link" })?.value,
                  let url = URL(string: value) else { return nil }
            candidate = url
        } else {
            candidate = incomingURL
        }

        guard ["http", "https"].contains(candidate.scheme?.lowercased() ?? ""),
              let host = candidate.host, !host.isEmpty else { return nil }
        url = candidate
    }
}

struct StoryLinkHost: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(StoryOpeningPreference.openInAppKey) private var openInApp = false
    @State private var destination: StoryDestination?
    @State private var browserDestination: StoryDestination?
    @State private var didOpenBrowser = false
    @State private var openingFailed = false

    var body: some View {
        Group {
            if let destination {
                StoryRedirectView(
                    url: destination.url,
                    openInApp: openInApp,
                    didOpenBrowser: didOpenBrowser,
                    openingFailed: openingFailed,
                    retry: { receive(destination.url) },
                    close: { self.destination = nil }
                )
            } else {
                SplashScreen()
            }
        }
        .onOpenURL(perform: receive)
        .fullScreenCover(item: $browserDestination, onDismiss: {
            destination = nil
        }) { destination in
            StoryBrowser(url: destination.url)
                .id(destination.id)
                .ignoresSafeArea()
        }
        .task(id: scenePhase == .active ? destination?.id : nil) {
            guard let destination, scenePhase == .active,
                  browserDestination == nil, !didOpenBrowser, !openingFailed else { return }
            do {
                // Give the redirect screen a brief moment to explain the handoff.
                try await Task.sleep(for: .milliseconds(400))
            } catch {
                return
            }
            guard !Task.isCancelled, self.destination?.id == destination.id else { return }

            if openInApp {
                browserDestination = destination
            } else {
                openURL(destination.url) { accepted in
                    guard self.destination?.id == destination.id else { return }
                    didOpenBrowser = accepted
                    openingFailed = !accepted
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active, didOpenBrowser {
                destination = nil
            }
        }
    }

    private func receive(_ url: URL) {
        guard let incoming = StoryDestination(incomingURL: url) else { return }
        didOpenBrowser = false
        openingFailed = false
        destination = incoming
        // A second widget tap can arrive while the in-app browser is still open.
        if browserDestination != nil {
            browserDestination = incoming
        }
    }
}

private struct StoryBrowser: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredControlTintColor = .systemOrange
        controller.dismissButtonStyle = .done
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }

    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        private let dismiss: DismissAction

        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            Task { @MainActor [dismiss] in
                dismiss()
            }
        }
    }
}

private struct StoryRedirectView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false
    let url: URL
    let openInApp: Bool
    let didOpenBrowser: Bool
    let openingFailed: Bool
    let retry: () -> Void
    let close: () -> Void

    private var isOpening: Bool { !didOpenBrowser && !openingFailed }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()

            RadialGradient(
                colors: [.orange.opacity(0.18), .clear],
                center: .center,
                startRadius: 20,
                endRadius: 280
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .stroke(.orange.opacity(0.12), lineWidth: 1)
                        .frame(width: 156, height: 156)

                    Circle()
                        .trim(from: 0, to: 0.72)
                        .stroke(
                            AngularGradient(colors: [.orange.opacity(0), .orange], center: .center),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 156, height: 156)
                        .rotationEffect(.degrees(isAnimating && !reduceMotion && isOpening ? 360 : 0))
                        .animation(
                            reduceMotion || !isOpening ? nil : .linear(duration: 1.8).repeatForever(autoreverses: false),
                            value: isAnimating && !reduceMotion && isOpening
                        )

                    Circle()
                        .fill(.orange.opacity(0.1))
                        .frame(width: 112, height: 112)

                    Image(systemName: openingFailed ? "exclamationmark.triangle" : didOpenBrowser ? "checkmark" : "arrow.up.right")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(.orange)
                        .symbolEffect(.pulse, options: .repeating, isActive: isOpening && !reduceMotion)
                }
                .accessibilityHidden(true)

                VStack(spacing: 12) {
                    Text(openingFailed ? "Couldn't open this link" : didOpenBrowser ? "Opened in your browser" : openInApp ? "Opening story" : "Redirecting you")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(openingFailed ? "Try again to continue to the story." : didOpenBrowser ? "Your story is ready to read." : openInApp ? "Opening your story in the app…" : "Taking you to your default browser…")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text(url.host() ?? url.absoluteString)
                        .font(.callout.monospaced())
                        .foregroundStyle(.orange)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.orange.opacity(0.08), in: Capsule())
                }
                .accessibilityElement(children: .combine)

                VStack(spacing: 12) {
                    if openingFailed {
                        Button("Try again", action: retry)
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                    }
                    Button(isOpening ? "Cancel" : "Back to HN Widgets", action: close)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(32)
            .frame(maxWidth: 480)
        }
        .onAppear { isAnimating = true }
    }
}

#Preview("Redirecting you · Default browser") {
    StoryRedirectView(
        url: URL(string: "https://news.ycombinator.com/item?id=1")!,
        openInApp: false,
        didOpenBrowser: false,
        openingFailed: false,
        retry: {},
        close: {}
    )
    .preferredColorScheme(.dark)
}

#Preview("Opening story · In app") {
    StoryRedirectView(
        url: URL(string: "https://news.ycombinator.com/item?id=1")!,
        openInApp: true,
        didOpenBrowser: false,
        openingFailed: false,
        retry: {},
        close: {}
    )
    .preferredColorScheme(.dark)
}
