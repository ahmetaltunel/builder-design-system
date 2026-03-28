import SwiftUI
import BuilderFoundation

public struct BulletList: View {
    public let environment: DesignSystemEnvironment
    public let items: [String]

    public init(environment: DesignSystemEnvironment, items: [String]) {
        self.environment = environment
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: environment.theme.spacing(.xs, density: environment.density)) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(environment.theme.color(.accentPrimary))
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)

                    Text(item)
                        .font(environment.theme.typography(.body).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
