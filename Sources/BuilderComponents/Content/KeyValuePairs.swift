import SwiftUI
import BuilderFoundation

public struct KeyValuePairs: View {
    public struct Pair: Identifiable, Hashable {
        public let id: String
        public let key: String
        public let value: String

        public init(id: String? = nil, key: String, value: String) {
            self.id = id ?? key
            self.key = key
            self.value = value
        }
    }

    public let environment: DesignSystemEnvironment
    public let pairs: [Pair]

    public init(environment: DesignSystemEnvironment, pairs: [Pair]) {
        self.environment = environment
        self.pairs = pairs
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(pairs.enumerated()), id: \.element.id) { index, pair in
                HStack(alignment: .top, spacing: 18) {
                    Text(pair.key)
                        .font(environment.theme.typography(.label).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                        .frame(width: 140, alignment: .leading)

                    Text(pair.value)
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))

                    Spacer(minLength: 0)
                }
                .padding(.vertical, 12)

                if index < pairs.count - 1 {
                    Rectangle()
                        .fill(environment.theme.color(.subtleBorder))
                        .frame(height: 1)
                }
            }
        }
    }
}
