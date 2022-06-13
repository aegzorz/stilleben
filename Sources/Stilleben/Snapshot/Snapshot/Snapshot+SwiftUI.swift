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

    func diffSwiftUI(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta) -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .render()
            .record(using: .localFile)
            .diff(using: diffing)
    }

    func diffSwiftUIHosted(sizing: SizingStrategy = .screen, diffing: ImageDiffingStrategy = .labDelta) -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .renderInHostApp()
            .record(using: .localFile)
            .diff(using: diffing)
    }
}
