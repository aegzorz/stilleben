import Foundation
import SwiftUI

struct EnvironmentModifier<Value>: ViewModifier {
    typealias Key = WritableKeyPath<EnvironmentValues, Value>

    let key: Key
    let value: Value?

    func body(content: Content) -> some View {
        if let value = value {
            content.environment(key, value)
        } else {
            content
        }
    }
}

extension View {
    func deferredEnvironment<T>(_ key: EnvironmentModifier<T>.Key, _ value: T) -> some View {
        modifier(EnvironmentModifier(key: key, value: value))
    }
}
