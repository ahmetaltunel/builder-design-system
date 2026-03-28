import SwiftUI
import BuilderFoundation

public struct SystemButton: View {
    public let environment: DesignSystemEnvironment
    public let title: String
    public let tone: ButtonTone
    public let size: ButtonSize
    public let leadingSymbol: String?
    public let isEnabled: Bool
    public let isLoading: Bool
    public let action: () -> Void

    @State private var isHovered = false

    public init(
        environment: DesignSystemEnvironment,
        title: String,
        tone: ButtonTone = .primary,
        size: ButtonSize = .medium,
        leadingSymbol: String? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.environment = environment
        self.title = title
        self.tone = tone
        self.size = size
        self.leadingSymbol = leadingSymbol
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button {
            guard isEnabled, !isLoading else { return }
            action()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(foreground)
                } else if let leadingSymbol {
                    Image(systemName: leadingSymbol)
                        .font(.system(size: 13, weight: .medium))
                }

                Text(title)
                    .font(environment.theme.typography(.button).font)
            }
            .foregroundStyle(foreground)
            .padding(.horizontal, horizontalPadding)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(border, lineWidth: tone == .ghost ? 0 : 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
            .opacity(isEnabled ? 1 : 0.55)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
        .accessibilityLabel(title)
        .accessibilityHint(isLoading ? "Action in progress" : "Button")
        .accessibilityAddTraits(.isButton)
    }

    private var foreground: Color {
        guard isEnabled else { return environment.theme.color(.textDisabled) }

        switch tone {
        case .primary:
            return environment.theme.color(.textOnAccent)
        case .secondary, .ghost:
            return environment.theme.color(.textPrimary)
        }
    }

    private var background: Color {
        guard isEnabled else {
            return tone == .primary ? environment.theme.color(.pressedSurface) : environment.theme.color(.inputSurface)
        }

        switch tone {
        case .primary:
            return isHovered ? environment.theme.color(.accentHover) : environment.theme.color(.accentPrimary)
        case .secondary:
            return isHovered ? environment.theme.color(.hoverSurface) : environment.theme.color(.inputSurface)
        case .ghost:
            return isHovered ? environment.theme.color(.hoverSurface) : .clear
        }
    }

    private var border: Color {
        guard isEnabled else { return environment.theme.color(.subtleBorder) }

        switch tone {
        case .primary:
            return .clear
        case .secondary:
            return isHovered ? environment.theme.color(.strongBorder) : environment.theme.color(.subtleBorder)
        case .ghost:
            return .clear
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small: 12
        case .medium: 16
        case .large: 18
        }
    }

    private var height: CGFloat {
        let base: CGFloat = switch size {
        case .small: 32
        case .medium: 38
        case .large: 44
        }

        return max(28, base + environment.density.controlHeightOffset)
    }
}
