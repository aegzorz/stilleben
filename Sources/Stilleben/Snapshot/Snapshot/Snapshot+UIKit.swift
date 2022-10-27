import Foundation
import UIKit

public extension Snapshot where Value: UIViewController {
    /// Convenience function for diffing `UIViewController`
    func diffUIKit(
        file: StaticString = #file,
        line: UInt = #line,
        sizing: SizingStrategy = .screen,
        rendering: RenderingStrategy = .default(hosted: false),
        diffing: ImageDiffingStrategy = .labDelta,
        recording: RecordingStrategy = .localFile,
        forceRecording: Bool = false
    ) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .render(using: rendering)
            .record(using: recording)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
    }
}
