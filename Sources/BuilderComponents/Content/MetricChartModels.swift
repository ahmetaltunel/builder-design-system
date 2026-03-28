import SwiftUI

public struct MetricPoint: Identifiable {
    public let id: String
    public let label: String
    public let value: Double

    public init(id: String? = nil, label: String, value: Double) {
        self.id = id ?? label
        self.label = label
        self.value = value
    }
}

public struct MetricSeries: Identifiable {
    public let id: String
    public let title: String
    public let color: Color
    public let points: [MetricPoint]

    public init(id: String? = nil, title: String, color: Color, points: [MetricPoint]) {
        self.id = id ?? title
        self.title = title
        self.color = color
        self.points = points
    }
}

public struct MetricSlice: Identifiable {
    public let id: String
    public let title: String
    public let value: Double
    public let color: Color

    public init(id: String? = nil, title: String, value: Double, color: Color) {
        self.id = id ?? title
        self.title = title
        self.value = value
        self.color = color
    }
}

public struct MetricSelection: Identifiable, Hashable {
    public enum Kind: String, Hashable {
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
