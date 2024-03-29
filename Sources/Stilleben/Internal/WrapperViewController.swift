import Foundation
import UIKit

class WrapperViewController: UIViewController {
    private let content: UIView

    init(view: UIView) {
        self.content = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(content)
        content.constrainToEdges(of: view)
    }
}
