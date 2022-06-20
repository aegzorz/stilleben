import Foundation
import UIKit

class TraitsViewController: UIViewController {
    let content: UIViewController

    var interfaceStyle: UIUserInterfaceStyle = .light
    var contentSizeCategory: UIContentSizeCategory = .large

    init(content: UIViewController) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(content)
        view.addSubview(content.view)

        content.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.view.topAnchor.constraint(equalTo: view.topAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        content.didMove(toParent: self)

        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: interfaceStyle),
            UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
        ])

        setOverrideTraitCollection(traits, forChild: content)
    }
}
