import SwiftUI
import Testing
@testable import Stilleben

extension SerialTests {
  /// The matchers' modifiers set the strategies and record mode they're given
  @MainActor
  @Suite
  struct MatcherModifierTests {
    @Test
    func uiMatcherModifiers() async throws {
      let matcher = UIMatcher()
        .rendering(MarkerRenderingStrategy())
        .recording(MarkerRecordingStrategy())
        .diffing(.sameImage)
        .record(.never)

      #expect(matcher.rendering is MarkerRenderingStrategy)
      #expect(matcher.recording is MarkerRecordingStrategy)
      #expect(matcher.record == .never)
      // `.sameImage` attaches two images where `.labDelta` (the default) attaches three
      let circle = try #require(UIImage(systemName: "circle"))
      let square = try #require(UIImage(systemName: "square"))
      let diff = try await matcher.diffing.diff(actual: circle, expected: square)
      guard case let .different(_, attachments) = diff else {
        Issue.record("Expected the images to differ")
        return
      }
      #expect(attachments.count == 2)
    }

    @Test
    func reflectionMatcherModifiers() {
      let matcher = ReflectionMatcher()
        .recording(MarkerRecordingStrategy())
        .diffing(.text)
        .record(.all)

      #expect(matcher.recording is MarkerRecordingStrategy)
      #expect(matcher.record == .all)
    }

    @Test
    func encodableMatcherModifiers() {
      let matcher = EncodableMatcher()
        .recording(MarkerRecordingStrategy())
        .diffing(.text)
        .record(.missing)

      #expect(matcher.recording is MarkerRecordingStrategy)
      #expect(matcher.record == .missing)
    }
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
