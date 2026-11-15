import os

/// Mutable state that has to be read synchronously from any thread, where an actor can't be used.
nonisolated struct LockedValue<Value: Sendable>: Sendable {
  private let lock: OSAllocatedUnfairLock<Value>

  init(_ value: Value) {
    lock = OSAllocatedUnfairLock(initialState: value)
  }

  var value: Value {
    get { lock.withLock { $0 } }
    nonmutating set { lock.withLock { $0 = newValue } }
  }

  /// Reads and modifies the value while holding the lock, for updates that depend on the current value.
  func withValue<Result: Sendable>(_ body: @Sendable (inout Value) -> Result) -> Result {
    lock.withLock(body)
  }
}
