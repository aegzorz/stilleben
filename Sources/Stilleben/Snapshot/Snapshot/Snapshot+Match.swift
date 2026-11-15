import Foundation
import XCTest

extension Snapshot where Value == Diff {
  /// Compares the `Diff` of the `Snapshot` and adds attachements if there's a diff.
  public func match(file: StaticString = #filePath, line: UInt = #line) async {
    do {
      try await map { diff in
        switch diff {
        case .same:
          return
        case let .different(description, attachments):
          let callsite = try context.value(for: .callsite).unwrap()

          XCTContext.runActivity(named: callsite.functionName) { activity in
            attachments.forEach(activity.add)
          }

          let mode = context.value(for: .recordMode) ?? .default
          if mode == .failed, let actual = context.value(for: .actualRecording), let strategy = context.value(for: .recordingStrategy) {
            try await strategy.write(data: actual, context: context)
            return XCTFail("\(description). The reference was re-recorded (record mode .failed): review the change and commit it.", file: file, line: line)
          }
          return XCTFail(description, file: file, line: line)
        }
      }
      .produce()
    } catch {
      XCTFail(error.localizedDescription, file: file, line: line)
    }
  }
}
