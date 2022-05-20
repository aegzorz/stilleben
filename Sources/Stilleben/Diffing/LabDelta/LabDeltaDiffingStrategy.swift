import UIKit
import CoreImage.CIFilterBuiltins

public extension DiffingStrategy where Self == LabDeltaDiffingStrategy {
    static var labDelta: LabDeltaDiffingStrategy {
        labDelta(threshold: 2)
    }
    static func labDelta(threshold: Float32) -> LabDeltaDiffingStrategy {
        LabDeltaDiffingStrategy(threshold: threshold)
    }
}

public struct LabDeltaDiffingStrategy: DiffingStrategy {
    public typealias Value = UIImage

    public let threshold: Float32

    public init(threshold: Float32) {
        self.threshold = threshold
    }

    public func diff(actual: UIImage, expected: UIImage) async throws -> Diff<UIImage> {
        let actual = try CIImage(data: try actual.pngData().unwrap()).unwrap()
        let expected = try CIImage(data: try expected.pngData().unwrap()).unwrap()

        let labDelta = LabDeltaFilter(actual: actual, expected: expected)
        let deltaImage = try labDelta.output()

        let maxArea = MaxAreaFilter(image: deltaImage)
        let diff = try maxArea.difference()

        if diff > threshold {
            return .different(artifacts: [
                .init(value: UIImage(ciImage: actual), description: "Actual"),
                .init(value: UIImage(ciImage: expected), description: "Expected"),
                .init(value: UIImage(ciImage: deltaImage), description: "LabDelta")
            ])
        } else {
            return .same
        }
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
        filter.inputImage = image

        let maxImage = try filter.outputImage.unwrap()

        var delta: Float32 = .nan

        let context = CIContext()
        context.render(maxImage, toBitmap: &delta, rowBytes: MemoryLayout<Float32>.size, bounds: maxImage.extent, format: .Af, colorSpace: maxImage.colorSpace)

        return delta
    }
}
