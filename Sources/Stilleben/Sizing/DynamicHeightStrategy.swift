import UIKit

public extension SizingStrategy where Self == DynamicHeightStrategy {
    static var dynamicHeight: Self {
        DynamicHeightStrategy()
    }
}

/// Sizing strategy that dynamically calculates the required size to fit vertically scrolling content
/// in the snapshot.
public struct DynamicHeightStrategy: SizingStrategy {
    public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
        let view = try viewController.view.unwrap()

        if let scrollView = view.findScrollView() {
            return CGSize(
                width: view.bounds.width,
                height: view.bounds.height + scrollView.contentSize.height + scrollView.adjustedContentInset.top + scrollView.adjustedContentInset.bottom - scrollView.frame.height
            )
        } else {
            let height = view.systemLayoutSizeFitting(view.bounds.size).height
            let safeAreaHeight = view.safeAreaInsets.top + view.safeAreaInsets.bottom

            if height > 0 {
                return CGSize(
                    width: view.bounds.width,
                    height: height + safeAreaHeight
                )
            } else {
                return CGSize(
                    width: view.bounds.width,
                    height: view.bounds.height + safeAreaHeight
                )

            }
        }
    }
}
