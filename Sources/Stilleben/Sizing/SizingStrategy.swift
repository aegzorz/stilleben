import Foundation
import UIKit

public protocol SizingStrategy {
    func size(viewController: UIViewController) async throws -> CGSize
}
