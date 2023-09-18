import SwiftUI

@main
struct TestnetDemoProject: App {
    var body: some Scene {
        WindowGroup {
            MainCoordrinatorView(coordinator: .init())
        }
    }
}
