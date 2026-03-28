import Foundation

public struct MetricSelection: Identifiable, Hashable, Sendable {
    public enum Kind: String, Hashable, Sendable {
        case point
        case slice
    }

    public let id: String
    public let kind: Kind
    public let seriesID: String
    public let seriesTitle: String
    public let datumID: String
    public let label: String
    public let value: Double
    public let formattedValue: String

    public init(
        id: String? = nil,
        kind: Kind,
        seriesID: String,
        seriesTitle: String,
        datumID: String,
        label: String,
        value: Double,
        formattedValue: String
    ) {
        self.id = id ?? "\(seriesID)::\(datumID)"
        self.kind = kind
        self.seriesID = seriesID
        self.seriesTitle = seriesTitle
        self.datumID = datumID
        self.label = label
        self.value = value
        self.formattedValue = formattedValue
    }
}

