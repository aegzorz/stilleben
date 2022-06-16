import Foundation

@dynamicMemberLookup
struct Modifier<Base> {
    let base: Base

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Base, T>) -> (T) -> Base {
        { [base] value in
            var modified = base
            modified[keyPath: keyPath] = value
            return modified
        }
    }
}
