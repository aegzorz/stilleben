import Foundation
import UIKit

public extension Snapshot where Value == UIImage {
    /// Sets the file extension to `.png` in the `SnapshotContext` and records snapshots if needed.
    /// - Parameter using: The recording strategy to use
    func record(using strategy: RecordingStrategy) -> Snapshot<(UIImage, UIImage)> {
        context.set(value: "png", for: .fileExtension)

        return map { image in
            try image.pngData().unwrap()
        }
        .record(using: strategy)
        .map { (actual, expected) in
            (try UIImage(data: actual).unwrap(), try UIImage(data: expected).unwrap())
        }
    }
}
