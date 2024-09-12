import SwiftUI
import SwiftData


@main
struct RealAcronymApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
        .modelContainer(for: [Player.self])
    }
}
