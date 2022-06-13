import Foundation
import UIKit

public extension SnapshotContext.Key where Value == CGSize {
    static var targetSize: Self {
        SnapshotContext.Key(name: "targetSize")
    }
}
