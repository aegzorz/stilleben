import SwiftUI

/// Empty app that hosts Stilleben's tests, so snapshots have a window scene to render in
@main
struct StillebenTestHostApp: App {
  var body: some Scene {
    WindowGroup {
      Color.clear
    }
  }
}
