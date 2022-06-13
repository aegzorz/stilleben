import Foundation
import UIKit

public extension Snapshot where Value == UIImage {
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
