import Foundation
import UIKit

public extension Snapshot where Value: UIViewController {
  /// Convenience function for diffing `UIViewController`
  func diffUIKit(
    sizing: SizingStrategy = .device,
    rendering: RenderingStrategy = .default,
    diffing: ImageDiffingStrategy = .labDelta,
    recording: RecordingStrategy = .localFile,
    record: RecordMode = .default,
  ) -> Snapshot<Diff> {
    inWindow()
      .size(using: sizing)
      .render(using: rendering)
      .record(using: recording)
      .diff(using: diffing)
      .recordMode(record)
  }
}
