import UIKit

extension UIView {
    func findScrollView(where condition: (UIScrollView) -> Bool = { _ in true }) -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }

        let scrollViews = subviews.compactMap {
            $0 as? UIScrollView
        }

        if let matching = scrollViews.first(where: condition) {
            return matching
        } else {
            for view in subviews {
                if let matching = view.findScrollView(where: condition) {
                    return matching
                }
            }
        }

        return nil
    }
}
