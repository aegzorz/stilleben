import Foundation
import UIKit

public extension Snapshot where Value: UIViewController {
    func diffUIKit(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta, hosted: Bool = false) -> Snapshot<Diff> {
        inKeyWindow()
            .size(using: sizing)
            .render(hosted: hosted)
            .record(using: .localFile)
            .diff(using: diffing)
    }
}
