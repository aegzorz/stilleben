import Foundation
import UIKit

public extension Snapshot where Value == UIImage {
    func record(using strategy: RecordingStrategy) -> Snapshot<(UIImage, UIImage)> {
        map { image in
            try image.pngData().unwrap()
        }
        .record(using: strategy)
        .map { (actual, expected) in
            (try UIImage(data: actual).unwrap(), try UIImage(data: expected).unwrap())
        }
    }
}

extension RecordingStrategy where Self == LocalFileRecordingStrategy {
    public static var png: LocalFileRecordingStrategy {
        localFile(fileExtension: "png")
    }
}
