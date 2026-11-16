import Foundation
import SwiftUI

public extension Snapshot where Value: View {
  /// Wraps the SwiftUI view in a `UIHostingController`
  func inHostingController() -> Snapshot<UIHostingController<Value>> {
    map { @MainActor view in
      let viewController = UIHostingController(rootView: view)
      viewController.view.backgroundColor = .clear
      return viewController
    }
  }

  /// Convenience function for diffing `SwiftUI` views.
  func diffSwiftUI(
    file: StaticString = #filePath,
    line: UInt = #line,
    sizing: SizingStrategy = .device,
    rendering: RenderingStrategy = .default,
    diffing: ImageDiffingStrategy = .labDelta,
    recording: RecordingStrategy = .localFile,
    record: RecordMode = .default,
  ) -> Snapshot<Diff> {
    inHostingController()
      .inWindow()
      .size(using: sizing)
      .render(using: rendering)
      .record(using: recording)
      .diff(using: diffing)
      .recordMode(record)
  }
}
