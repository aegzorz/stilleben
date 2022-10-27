import Foundation
import UIKit

public extension SnapshotContext.Key where Value == CGSize {
    static var targetSize: Self {
        SnapshotContext.Key(name: "targetSize")
    }
}

public extension SnapshotContext.Key where Value == Bool {
    static var ignoresSafeArea: Self {
        SnapshotContext.Key(name: "ignoresSafeArea")
    }
}

