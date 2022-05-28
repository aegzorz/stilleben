import Foundation

extension Snapshot where Value: Encodable {
    func diffJson() -> Snapshot<Diff> {
        encodeJson().record(using: .json).diff(using: .text)
    }

    public func encodeJson() -> Snapshot<Data> {
        map { value in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            return try encoder.encode(value)
        }
    }
}

extension RecordingStrategy where Self == LocalFileRecordingStrategy {
    public static var json: LocalFileRecordingStrategy {
        localFile(fileExtension: "json")
    }
}
