import Foundation
import Testing

extension Snapshot where Value == Diff {
  /// Compares the `Diff` of the `Snapshot`, recording an issue with attachments in the current test if there's a diff.
  public func match(sourceLocation: SourceLocation = #_sourceLocation) async {
    do {
      try await map { diff in
        switch diff {
        case .same:
          return
        case let .different(description, attachments):
          for attachment in attachments {
            attachment.record(sourceLocation: sourceLocation)
          }

          let mode = context.value(for: .recordMode) ?? .default
          if mode == .failed, let actual = context.value(for: .actualRecording), let strategy = context.value(for: .recordingStrategy) {
            try await strategy.write(data: actual, context: context)
            Issue.record("\(description). The reference was re-recorded (record mode .failed): review the change and commit it.", sourceLocation: sourceLocation)
            return
          }
          Issue.record("\(description)", sourceLocation: sourceLocation)
        }
      }
      .produce()
    } catch {
      Issue.record("\(error.localizedDescription)", sourceLocation: sourceLocation)
    }
  }
}
