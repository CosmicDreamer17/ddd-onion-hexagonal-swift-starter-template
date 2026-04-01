import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            // Use the Composition Root to create the initial view.
            CompositionRoot.shared.makeProfileView()
        }
    }
}
