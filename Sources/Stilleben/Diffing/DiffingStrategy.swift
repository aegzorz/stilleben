import Foundation

public protocol DiffingStrategy {
    associatedtype Value

    func diff(actual: Value, expected: Value) async throws -> Diff<Value>
}

public enum Diff<Value> {
    case same
    case different(artifacts: [Artifact])

    public struct Artifact {
        public let value: Value
        public let description: String

        public init(value: Value, description: String) {
            self.value = value
            self.description = description
        }
    }
}
