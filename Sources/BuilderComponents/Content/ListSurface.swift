import SwiftUI
import BuilderFoundation

public struct ListSurface: View {
    public let environment: DesignSystemEnvironment
    public let items: [String]

    public init(environment: DesignSystemEnvironment, items: [String]) {
        self.environment = environment
        self.items = items
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack {
                    Text(item)
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textPrimary))
                    Spacer()
                }
                .padding(.horizontal, 14)
                .frame(height: 40)

                if index < items.count - 1 {
                    Rectangle()
                        .fill(environment.theme.color(.subtleBorder))
                        .frame(height: 1)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
        )
    }
}
