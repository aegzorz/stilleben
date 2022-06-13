import Foundation
import UIKit

public extension Snapshot where Value: UIViewController {
    func diffUIKit(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .render()
            .record(using: .localFile)
            .diff(using: diffing)
    }

    func diffUIKitHosted(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .renderInHostApp()
            .record(using: .localFile)
            .diff(using: diffing)
    }
}
