import SwiftUI
import XCTest
@testable import Stilleben

/// The matchers' modifiers set the strategies and record mode they're given
@MainActor
final class MatcherModifierTests: XCTestCase {
  func testUIMatcherModifiers() async throws {
    let matcher = UIMatcher()
      .rendering(MarkerRenderingStrategy())
      .recording(MarkerRecordingStrategy())
      .diffing(.sameImage)
      .record(.never)

    XCTAssertTrue(matcher.rendering is MarkerRenderingStrategy)
    XCTAssertTrue(matcher.recording is MarkerRecordingStrategy)
    XCTAssertEqual(matcher.record, .never)
    // `.sameImage` attaches two images where `.labDelta` (the default) attaches three
    let diff = try await matcher.diffing.diff(actual: UIImage(systemName: "circle")!, expected: UIImage(systemName: "square")!)
    if case let .different(_, attachments) = diff {
      XCTAssertEqual(attachments.count, 2)
    } else {
      XCTFail("Expected the images to differ")
    }
  }

  func testReflectionMatcherModifiers() {
    let matcher = ReflectionMatcher()
      .recording(MarkerRecordingStrategy())
      .diffing(.text)
      .record(.all)

    XCTAssertTrue(matcher.recording is MarkerRecordingStrategy)
    XCTAssertEqual(matcher.record, .all)
  }

  func testEncodableMatcherModifiers() {
    let matcher = EncodableMatcher()
      .recording(MarkerRecordingStrategy())
      .diffing(.text)
      .record(.missing)

    XCTAssertTrue(matcher.recording is MarkerRecordingStrategy)
    XCTAssertEqual(matcher.record, .missing)
  }
}

private struct MarkerRenderingStrategy: RenderingStrategy {
  func render(viewController: UIViewController, context: SnapshotContext) async throws -> UIImage {
    UIImage()
  }
}

private struct MarkerRecordingStrategy: RecordingStrategy {
  func read(context: SnapshotContext) async throws -> Data? { nil }
  func write(data: Data, context: SnapshotContext) async throws {}
}
