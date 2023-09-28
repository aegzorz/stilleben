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
        file: StaticString = #file,
        line: UInt = #line,
        sizing: SizingStrategy = .screen,
        rendering: RenderingStrategy = .default(hosted: false),
        diffing: ImageDiffingStrategy = .labDelta,
        recording: RecordingStrategy = .localFile,
        forceRecording: Bool = false,
        delay: SnapshotDelay = .none
    ) -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .delay(delay)
            .render(using: rendering)
            .record(using: recording)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
    }
}
