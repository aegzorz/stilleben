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

    func diffSwiftUI() -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .render()
            .record(using: .localFile)
            .diff(using: .labDelta)
    }
}
