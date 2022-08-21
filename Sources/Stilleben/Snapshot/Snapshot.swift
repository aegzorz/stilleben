import Foundation
import XCTest

/// Generic type that describes a `Snapshot` of a `Value`
public struct Snapshot<Value> {
    public typealias Produce = () async throws -> Value

    /// Closure to produce `Value` which will be used for snapshotting
    public let produce: Produce
    /// Context of the current snapshot
    public let context: SnapshotContext

    public init(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Produce) {
        self.produce = produce
        // Create a context that can be used to pass values when mapping into other snapshots
        context = SnapshotContext()

        // Store the callsite in the context
        let callsite = Callsite(file: file, function: function, line: line)
        context.set(value: callsite, for: .callsite)

        let testName = callsite.functionName
            .removingPrefix("test")
            .removingSuffix("()")
            .lowercaseFirstLetter()

        // Add the current test name as the first recording name component
        context.set(value: [testName], for: .recordingNameComponents)
    }

    internal init(context: SnapshotContext, produce: @escaping Produce) {
        self.context = context
        self.produce = produce
    }

    /// Maps the `Value` of the current `Snapshot` into a new value
    public func map<T>(_ transform: @MainActor @escaping (Value) async throws -> T) -> Snapshot<T> {
        Snapshot<T>(context: context) {
            try await transform(produce())
        }
    }
}
