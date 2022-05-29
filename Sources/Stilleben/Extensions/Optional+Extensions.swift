import Foundation

extension Optional {
    struct UnexpectedNilError: Error { }

    func unwrap(error: Error? = nil) throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw error ?? UnexpectedNilError()
        }
    }
}
