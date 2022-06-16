import Foundation

public protocol SnapshotMatcher {
    associatedtype Value

    func match(file: StaticString, function: StaticString, line: UInt, produce: @escaping Snapshot<Value>.Produce) async
}
