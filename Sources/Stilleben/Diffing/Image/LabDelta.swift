import UIKit
import CoreImage.CIFilterBuiltins
import XCTest

extension DiffingStrategy where Self == ImageDiffingStrategy {
    /// Image diffiing strategy that creates a delta image using `CILabDeltaE` filter from `CoreImage`.
    /// The delta image will contain ∆E 1994 values between 0.0 and 100.0 where 2.0 is considered a just noticeable difference.
    /// Delta image is then passed through `CIAreaMaximum` to determine the maximum pixel difference in a single pixel.
    /// This is then compared to the `threshold` to determine if the images are the same or different.
    /// - Parameter threshold: Value between 0 and 100, where larger than 2 is considered a just noticeable difference.
    public static func labDelta(threshold: Float32) -> ImageDiffingStrategy {
        ImageDiffingStrategy { actual, expected in
            let actualData = try actual.pngData().unwrap()
            let expectedData = try expected.pngData().unwrap()

            let actualImage = try CIImage(data: actualData).unwrap()
            let expectedImage = try CIImage(data: expectedData).unwrap()

            let labDelta = LabDeltaFilter(actual: actualImage, expected: expectedImage)
            let deltaImage = try labDelta.output()

            let maxArea = MaxAreaFilter(image: deltaImage)
            let diff = try maxArea.difference()

            if diff > threshold {
                return .different(
                    description: "Snapshots did not match, delta value: \(diff)",
                    attachments: [
                        XCTAttachment(image: actual).named("Actual"),
                        XCTAttachment(image: expected).named("Expected"),
                        XCTAttachment(image: UIImage(ciImage: deltaImage)).named("LabDelta")
                    ]
                )
            } else {
                return .same
            }
        }
    }

    /// Default LabDeltaE diffing, using a `threshold` of `2`
    public static var labDelta: ImageDiffingStrategy {
        labDelta(threshold: 2)
    }
}

private struct LabDeltaFilter {
    let actual: CIImage
    let expected: CIImage

    func output() throws -> CIImage {
        let filter = CIFilter.labDeltaE()
        filter.inputImage = actual
        filter.image2 = expected
        return try filter.outputImage.unwrap()
    }
}

private struct MaxAreaFilter {
    let image: CIImage

    func difference() throws -> Float32 {
        let filter = CIFilter.areaMaximum()
        filter.extent = image.extent
        filter.inputImage = image

        let maxImage = try filter.outputImage.unwrap()

        var delta: Float32 = .nan

        let context = CIContext()
        context.render(maxImage, toBitmap: &delta, rowBytes: MemoryLayout<Float32>.size, bounds: maxImage.extent, format: .Af, colorSpace: maxImage.colorSpace)

        return delta
    }
}
