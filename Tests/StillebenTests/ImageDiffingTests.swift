import UIKit
import XCTest
@testable import Stilleben

/// Image diffing strategies report identical images as the same, and attach the images when they differ
@MainActor
final class ImageDiffingTests: XCTestCase {
  private let red = image(.red)
  private let blue = image(.blue)

  func testSameImageMatchesIdenticalImages() async throws {
    let diff = try await ImageDiffingStrategy.sameImage.diff(actual: red, expected: image(.red))

    XCTAssertEqual(attachmentNames(diff), [])
  }

  func testSameImageReportsDifferentImages() async throws {
    let diff = try await ImageDiffingStrategy.sameImage.diff(actual: red, expected: blue)

    XCTAssertEqual(attachmentNames(diff), ["Actual", "Expected"])
  }

  func testLabDeltaMatchesIdenticalImages() async throws {
    let diff = try await ImageDiffingStrategy.labDelta.diff(actual: red, expected: image(.red))

    XCTAssertEqual(attachmentNames(diff), [])
  }

  func testLabDeltaReportsDifferentImages() async throws {
    let diff = try await ImageDiffingStrategy.labDelta.diff(actual: red, expected: blue)

    XCTAssertEqual(attachmentNames(diff), ["Actual", "Expected", "LabDelta"])
    if case let .different(description, _) = diff {
      XCTAssertTrue(description.contains("delta value"), description)
    }
  }

  func testLabDeltaIgnoresDifferencesBelowItsThreshold() async throws {
    let almostRed = image(UIColor(red: 0.99, green: 0, blue: 0, alpha: 1))
    let diff = try await ImageDiffingStrategy.labDelta(threshold: 10).diff(actual: red, expected: almostRed)

    XCTAssertEqual(attachmentNames(diff), [])
  }

  /// Names of the attachments of a difference, or none when the images are the same
  private func attachmentNames(_ diff: Diff) -> [String] {
    switch diff {
    case .same: []
    case let .different(_, attachments): attachments.compactMap(\.name)
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
