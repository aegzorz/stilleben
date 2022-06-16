import UIKit
import SwiftUI

public extension Snapshot where Value: UIView {
    func asViewController(title: String? = nil) -> Snapshot<UIViewController> {
        map { view in
            let viewController = ViewController(view: view)
            viewController.title = title
            return viewController
        }
    }

    private class ViewController: UIViewController {
        init(view: UIView) {
            super.init(nibName: nil, bundle: nil)
            self.view = view
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
