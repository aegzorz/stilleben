import Foundation
import SwiftUI

public extension Snapshot where Value: View {
    func inHostingController() -> Snapshot<UIHostingController<Value>> {
        map { @MainActor view in
            let viewController = UIHostingController(rootView: view)
            viewController.view.backgroundColor = .clear
            return viewController
        }
    }

    func diffSwiftUI(
        file: StaticString = #file,
        line: UInt = #line,
        sizing: SizingStrategy = .screen,
        diffing: ImageDiffingStrategy = .labDelta,
        recording: RecordingStrategy = .localFile,
        hosted: Bool = false,
        forceRecording: Bool = false
    ) -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .render(hosted: hosted)
            .record(using: .localFile)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
    }
}
