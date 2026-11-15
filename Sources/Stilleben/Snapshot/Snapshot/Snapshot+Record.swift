import Foundation
import SwiftUI
import XCTest

public extension Snapshot where Value == Data {
  /// Error used when there is no reference to compare to
  struct MissingReferenceError: LocalizedError {
    let recorded: Bool

    public var errorDescription: String? {
      recorded
        ? "No reference snapshot was found, so it was recorded. Review it and run the test again."
        : "No reference snapshot was found, and the record mode doesn't allow recording it."
    }
  }

  /// Error used when record mode ``RecordMode/all`` recorded a snapshot
  struct RecordedError: LocalizedError {
    public var errorDescription: String? {
      "Recorded the snapshot because the record mode is .all. Review it and switch back to another mode."
    }
  }

  /// Reads the reference recording to compare against, recording it according to the ``RecordMode``
  /// - Parameter using: Recording strategy
  func record(using strategy: RecordingStrategy) -> Snapshot<(Data, Data)> {
    map { actual in
      let mode = context.value(for: .recordMode) ?? .default
      context.set(value: actual, for: .actualRecording)
      context.set(value: strategy, for: .recordingStrategy)

      if mode == .all {
        try await strategy.write(data: actual, context: context)
        throw RecordedError()
      }

      guard let expected = try await strategy.read(context: context) else {
        let recorded = mode != .never
        if recorded {
          try await strategy.write(data: actual, context: context)
        }
        throw MissingReferenceError(recorded: recorded)
      }
      return (actual, expected)
    }
  }
}

public extension Snapshot {
  /// Sets the ``RecordMode`` for the snapshot, ``RecordMode/default`` unless set
  func recordMode(_ mode: RecordMode) -> Self {
    context.set(value: mode, for: .recordMode)
    return self
  }

  /// Adds an arbitrary recording name component
  /// - Parameter add: The name component to add
  func recordingNameComponent(add component: String) -> Self {
    var components = context.value(for: .recordingNameComponents) ?? []
    components.append(component)
    context.set(value: components, for: .recordingNameComponents)
    return self
  }

  /// Adds a name component based on the supplied color scheme
  func recordingNameComponent(add colorScheme: ColorScheme) -> Self {
    recordingNameComponent(add: String(describing: colorScheme))
  }

  /// Adds a name component based on the supplied dynamic type
  func recordingNameComponent(add dynamicTypeSize: DynamicTypeSize) -> Self {
    recordingNameComponent(add: String(describing: dynamicTypeSize))
  }

  /// Adds a name component based on the supplied locale
  func recordingNameComponent(add locale: Locale) -> Self {
    recordingNameComponent(add: locale.identifier)
  }
}
