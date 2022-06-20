import Foundation
import UIKit

@testable import Stilleben

class ItemListViewController: UIViewController {
    private let count: Int

    init(count: Int) {
        self.count = count
        super.init(nibName: nil, bundle: nil)
        title = "List of items"
        tabBarItem = UITabBarItem(
            title: "Items",
            image: UIImage(systemName: "list.number"),
            selectedImage: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical

        scrollView.embedContent(view: stackView)

        for index in 0..<count {
            stackView.addArrangedSubview(ItemView(index: index))
        }

        view.addSubview(scrollView)
        scrollView.constrainToEdges(of: view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

private class ItemView: UIView {
    init(index: Int) {
        super.init(frame: .zero)

        let label = TestLabel()
        label.text = "Item #\(index + 1)"
        label.backgroundColor = colors[index % colors.count].withAlphaComponent(0.6)
        addSubview(label)

        label.constrainToEdges(of: self)
        label.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
}
