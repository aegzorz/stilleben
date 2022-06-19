import UIKit

extension UIView {
    func constrainToScrollView(_ scrollView: UIScrollView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    func constrainToEdges(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UIScrollView {
    func embedContent(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.constrainToScrollView(self)
    }
}
