import Foundation

/// Context that is used to pass values outside of the mapping of snapshots between values.
/// Useful when one of the strategies needs some context in order to function properly.
///
///  Used for passing for example `fileExtension` or `targetSize` to downstream snapshot transformations.
public final class SnapshotContext {
    internal var configuration: [String: Any] = [:]
    public init() { }
}

extension SnapshotContext {
    /// Used to get or set values in the context
    ///
    /// Example usage:
    /// ```
    /// extension SnapshotContext.Key where Value == String {
    ///     public static var customContextValue: Self {
    ///         SnapshotContext.Key(name: "customContextValue")
    ///     }
    /// }
    /// ```
    /// This allows gettting or setting context values like this:
    /// ```
    /// let stringValue = context.value(for: .customContextValue)
    ///
    /// context.set("Hello", for: .customContextValue)
    /// ```
    public struct Key<Value>: Hashable {
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }

    /// Sets (or overwrites) the value for a specific `Key`
    /// - Parameter value: Value to store
    /// - Parameter key: Unique key for writing the value
    public func set<T>(value: T, for key: Key<T>) {
        configuration[key.name] = value
    }

    /// Reads a value from context
    /// - Parameter key: Unique key for reading the value
    /// - Returns Value  or `nil`  if no value exists for `key`
    public func value<T>(for key: Key<T>) -> T? {
        configuration[key.name] as? T
    }

    /// Reads a boolean value from context
    /// - Parameter key: Unique key for reading the value
    /// - Returns Boolean value, defaults to `false` if no value exists for `key`
    public func value(for key: Key<Bool>) -> Bool {
        configuration[key.name] as? Bool ?? false
    }
}
