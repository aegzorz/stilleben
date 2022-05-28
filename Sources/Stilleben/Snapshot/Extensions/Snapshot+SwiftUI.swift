import Foundation
import SwiftUI

public extension Snapshot where Value: View {
    func inHostingController() -> Snapshot<UIHostingController<Value>> {
        map { @MainActor view in
            UIHostingController(rootView: view)
        }
    }

    func diffSwiftUI() -> Snapshot<Diff> {
        inHostingController()
            .inKeyWindow()
            .render()
            .record(using: .png)
            .diff(using: .labDelta)
    }
}
