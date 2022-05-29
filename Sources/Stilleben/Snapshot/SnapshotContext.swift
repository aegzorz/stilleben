import Foundation

public final class SnapshotContext {
    public let callsite: Callsite
    internal var configuration: [String: Any] = [:]

    public init(callsite: Callsite) {
        self.callsite = callsite
    }
}

extension SnapshotContext {
    public struct Key<Value>: Hashable {
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }

    public func set<T>(value: T, for key: Key<T>) {
        configuration[key.name] = value
    }

    public func value<T>(for key: Key<T>) -> T? {
        configuration[key.name] as? T
    }
}
