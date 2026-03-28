import SwiftUI
import BuilderFoundation

public struct LoadingBar: View {
    public let environment: DesignSystemEnvironment
    public let label: String?
    public let detail: String?
    public let height: CGFloat

    @State private var phase: CGFloat = 0

    public init(
        environment: DesignSystemEnvironment,
        label: String? = nil,
        detail: String? = nil,
        height: CGFloat = 10
    ) {
        self.environment = environment
        self.label = label
        self.detail = detail
        self.height = height
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if label != nil || detail != nil {
                VStack(alignment: .leading, spacing: 2) {
                    if let label {
                        Text(label)
                            .font(environment.theme.typography(.label).font)
                            .foregroundStyle(environment.theme.color(.textSecondary))
                    }

                    if let detail {
                        Text(detail)
                            .font(environment.theme.typography(.caption).font)
                            .foregroundStyle(environment.theme.color(.textMuted))
                    }
                }
            }

            GeometryReader { proxy in
                let resolvedHeight = max(8, height)
                let barWidth = max(proxy.size.width * 0.28, 56)
                let travel = max(proxy.size.width - barWidth, 0)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .fill(environment.theme.color(.inputSurface))

                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .fill(environment.theme.color(.accentPrimary))
                        .frame(width: barWidth)
                        .offset(x: environment.reduceMotion ? travel / 2 : phase * travel)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                )
                .onAppear {
                    guard !environment.reduceMotion else { return }
                    phase = 0
                    withAnimation(
                        .easeInOut(duration: environment.theme.motion(.regular, reduceMotion: environment.reduceMotion) * 6)
                        .repeatForever(autoreverses: true)
                    ) {
                        phase = 1
                    }
                }
                .frame(height: resolvedHeight)
            }
            .frame(height: max(8, height))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Loading")
        .accessibilityHint(detail ?? "Indeterminate progress")
    }
}
