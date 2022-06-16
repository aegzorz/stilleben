import Foundation
import XCTest

public struct Snapshot<Value> {
    public typealias Produce = () async throws -> Value

    public let produce: Produce
    public let context: SnapshotContext

    public init(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Produce) {
        self.produce = produce
        context = SnapshotContext()

        let callsite = Callsite(file: file, function: function, line: line)
        context.set(value: callsite, for: .callsite)

        let testName = callsite.functionName
            .removingPrefix("test")
            .removingSuffix("()")
            .lowercaseFirstLetter()
        
        context.set(value: [testName], for: .recordingNameComponents)
    }

    internal init(context: SnapshotContext, produce: @escaping Produce) {
        self.context = context
        self.produce = produce
    }

    public func map<T>(_ transform: @MainActor @escaping (Value) async throws -> T) -> Snapshot<T> {
        Snapshot<T>(context: context) {
            try await transform(produce())
        }
    }
}
