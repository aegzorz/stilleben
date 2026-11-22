import Testing
import UIKit
@testable import Stilleben

/// Image diffing strategies report identical images as the same, and attach the images when they differ
@MainActor
@Suite
struct ImageDiffingTests {
  private let red = image(.red)
  private let blue = image(.blue)

  @Test
  func sameImageMatchesIdenticalImages() async throws {
    let diff = try await ImageDiffingStrategy.sameImage.diff(actual: red, expected: image(.red))

    #expect(attachmentNames(diff) == [])
  }

  @Test
  func sameImageReportsDifferentImages() async throws {
    let diff = try await ImageDiffingStrategy.sameImage.diff(actual: red, expected: blue)

    #expect(attachmentNames(diff) == ["Actual", "Expected"])
  }

  @Test
  func labDeltaMatchesIdenticalImages() async throws {
    let diff = try await ImageDiffingStrategy.labDelta.diff(actual: red, expected: image(.red))

    #expect(attachmentNames(diff) == [])
  }

  @Test
  func labDeltaReportsDifferentImages() async throws {
    let diff = try await ImageDiffingStrategy.labDelta.diff(actual: red, expected: blue)

    #expect(attachmentNames(diff) == ["Actual", "Expected", "LabDelta"])
    if case let .different(description, _) = diff {
      #expect(description.contains("delta value"), "\(description)")
    }
  }

  @Test
  func labDeltaIgnoresDifferencesBelowItsThreshold() async throws {
    let almostRed = image(UIColor(red: 0.99, green: 0, blue: 0, alpha: 1))
    let diff = try await ImageDiffingStrategy.labDelta(threshold: 10).diff(actual: red, expected: almostRed)

    #expect(attachmentNames(diff) == [])
  }

  /// Names of the attachments of a difference, or none when the images are the same
  private func attachmentNames(_ diff: Diff) -> [String] {
    switch diff {
    case .same: []
    case let .different(_, attachments): attachments.map(\.name)
    }
  }
}

private func image(_ color: UIColor) -> UIImage {
  let format = UIGraphicsImageRendererFormat()
  format.scale = 1
  return UIGraphicsImageRenderer(size: CGSize(width: 10, height: 10), format: format).image { context in
    color.setFill()
    context.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
  }
}
