import Foundation

/// Protocol describing a matcher that will match values determined by the `associatedtype`
public protocol SnapshotMatcher {
    associatedtype Value

    /// Function that performs the matching based on the closure passed in.
    /// - Parameter produce: Closure for producing the value to match
    func match(file: StaticString, function: StaticString, line: UInt, produce: @escaping Snapshot<Value>.Produce) async
}
