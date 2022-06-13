import XCTest
import SwiftUI
import Stilleben

final class UIKitTests: XCTestCase {
    func testSimpleLabel() async throws {
        await Snapshot { @MainActor () -> UIView in
            let label = UILabel()
            label.text = "Hello World!"
            label.backgroundColor = .systemBackground
            return label
        }
        .asViewController()
        .size(using: .intrinsic)
        .render(hosted: false)
        .record(using: .localFile)
        .diff(using: .labDelta)
        .match()
    }

    func testNavigation() async throws {
        await Snapshot { @MainActor () -> UIView in
            let label = UILabel()
            label.text = "Content View"
            label.textAlignment = .center
            label.backgroundColor = .systemBackground
            return label
        }
        .asViewController(title: "Title")
        .inNavigationController()
        .diffUIKit()
        .match()
    }

    func testShortScrollview() async throws {
        await Snapshot { @MainActor () -> UIViewController in
            ItemListViewController(count: 3)
        }
        .inKeyWindow()
        .diffUIKit(sizing: .dynamicHeight)
        .match()
    }

    func testLongScrollview() async throws {
        await Snapshot { @MainActor () -> UIViewController in
            ItemListViewController(count: 25)
        }
        .inKeyWindow()
        .diffUIKit(sizing: .dynamicHeight)
        .match()
    }

    func testLongScrollviewInNavigationController() async throws {
        await Snapshot { @MainActor () -> UIViewController in
            ItemListViewController(count: 25)
        }
        .inNavigationController()
        .diffUIKit(sizing: .dynamicHeight)
        .match()
    }

    func testLongScrollviewInTabView() async {
        await Snapshot { @MainActor () -> UIViewController in
            ItemListViewController(count: 25)
        }
        .inNavigationController()
        .inTabBarController()
        .diffUIKit(sizing: .dynamicHeight)
        .match()
    }
}

private class ItemListViewController: UIViewController {
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

        let label = UILabel(frame: .zero)
        label.text = "Item #\(index + 1)"
        label.textAlignment = .center
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
