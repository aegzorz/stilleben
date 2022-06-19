import Foundation
import UIKit

public extension Snapshot where Value: UIViewController {
    func diffUIKit(
        file: StaticString = #file,
        line: UInt = #line,
        sizing: SizingStrategy = .screen,
        diffing: ImageDiffingStrategy = .labDelta,
        recording: RecordingStrategy = .localFile,
        hosted: Bool = false,
        forceRecording: Bool = false
    ) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .render(hosted: hosted)
            .record(using: recording)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
    }
}
