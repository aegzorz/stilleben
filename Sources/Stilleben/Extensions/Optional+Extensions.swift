import Foundation

extension Optional {
    struct UnexpectedNilError: Error { }

    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw UnexpectedNilError()
        }
    }
}
