import UIKit
import XCTest

extension DiffingStrategy where Self == ImageDiffingStrategy {
    /// Diffing strategy for comparing that the two images have the same PNG representation, i.e. are exactly the same.
    public static var sameImage: ImageDiffingStrategy {
        ImageDiffingStrategy { actual, expected in
            if actual.pngData() == expected.pngData() {
                return .same
            } else {
                return .different(
                    description: "Snapshots did not match",
                    attachments: [
                        XCTAttachment(image: actual).named("Actual"),
                        XCTAttachment(image: expected).named("Expected")
                    ]
                )
            }
        }
    }
}
