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

    func diffSwiftUI(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta, hosted: Bool = false) -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .render(hosted: hosted)
            .record(using: .localFile)
            .diff(using: diffing)
    }
}
