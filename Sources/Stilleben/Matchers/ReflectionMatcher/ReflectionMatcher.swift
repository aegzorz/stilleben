import Foundation

/// Snapshot matcher for reflected values
public struct ReflectionMatcher {
    /// The strategy to use when recording and reading reference snapshots
    public var recording: RecordingStrategy = .localFile
    /// The strategy to use when performing text diffs for the snapshots
    public var diffing: TextDiffingStrategy = .text
    /// When `true` forces the ``RecordingStrategy`` to record a new snapshot reference.
    public var forceRecording = false

    public init() { }
}

extension ReflectionMatcher {
    public func match<Value>(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line,
        produce: @escaping Snapshot<Value>.Produce)
    async {
        await Snapshot(file: file, function: function, line: line) {
            try await produce()
        }
        .reflect()
        .record(using: recording)
        .diff(using: diffing)
        .forceRecording(force: forceRecording)
        .match(file: file, line: line)
    }
}

extension ReflectionMatcher {
    public func recording(_ value: RecordingStrategy) -> Self {
        Modifier(base: self).recording(value)
    }
    public func diffing(_ value: TextDiffingStrategy) -> Self {
        Modifier(base: self).diffing(value)
    }
    public func forceRecording(_ value: Bool) -> Self {
        Modifier(base: self).forceRecording(value)
    }
}
