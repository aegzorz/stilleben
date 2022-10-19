import Foundation

extension Snapshot {
    public func reflect() -> Snapshot<Data> {
        context.set(value: "txt", for: .fileExtension)

        return map { value in
            var description = ""
            dump(value, to: &description, indent: 2)
            // Replace unknown context and memory address
            description = description.replacingOccurrences(of: "\\([\\w ]+\\$[a-f0-9]+\\)", with: "?", options: .regularExpression)
            return try description.data(using: .utf8).unwrap()
        }
    }
}
