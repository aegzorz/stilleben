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
        forceRecording: Bool = false,
        delay: SnapshotDelay = .none
    ) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .delay(delay)
            .render(using: rendering)
            .record(using: recording)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
    }
}
