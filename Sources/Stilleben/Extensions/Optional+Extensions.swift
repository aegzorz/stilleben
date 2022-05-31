import Foundation

extension Optional {
    struct UnexpectedNilError: LocalizedError {
        var errorDescription: String? = "Unexpected nil value found during unwrapping"
    }

    func unwrap(error: Error? = nil) throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw error ?? UnexpectedNilError()
        }
    }
}
