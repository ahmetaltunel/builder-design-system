import SwiftUI
import BuilderFoundation

private struct AnnotationAnchorPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

public struct AnnotationAnchor<Content: View>: View {
    public let id: String
    public let content: Content

    public init(id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        self.content = content()
    }

    public var body: some View {
        content.anchorPreference(key: AnnotationAnchorPreferenceKey.self, value: .bounds) {
            [id: $0]
        }
    }
}

public struct CoachmarkStep: Identifiable, Hashable, Sendable {
    public let id: String
    public let anchorID: String
    public let title: String
    public let message: String
    public let primaryActionTitle: String?
    public let secondaryActionTitle: String?

    public init(
        id: String? = nil,
        anchorID: String,
        title: String,
        message: String,
        primaryActionTitle: String? = nil,
        secondaryActionTitle: String? = nil
    ) {
        self.id = id ?? anchorID
        self.anchorID = anchorID
        self.title = title
        self.message = message
        self.primaryActionTitle = primaryActionTitle
        self.secondaryActionTitle = secondaryActionTitle
    }
}

public struct CoachmarkHost<Content: View>: View {
    public let environment: DesignSystemEnvironment
    public let step: CoachmarkStep?
    public let onPrimaryAction: (() -> Void)?
    public let onSecondaryAction: (() -> Void)?
    public let content: Content

    public init(
        environment: DesignSystemEnvironment,
        step: CoachmarkStep?,
        onPrimaryAction: (() -> Void)? = nil,
        onSecondaryAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.environment = environment
        self.step = step
        self.onPrimaryAction = onPrimaryAction
        self.onSecondaryAction = onSecondaryAction
        self.content = content()
    }

    public var body: some View {
        content.overlayPreferenceValue(AnnotationAnchorPreferenceKey.self) { anchors in
            GeometryReader { geometry in
                if
                    let step,
                    let anchor = anchors[step.anchorID]
                {
                    SpotlightOverlay(
                        environment: environment,
                        frame: geometry[anchor],
                        title: step.title,
                        message: step.message,
                        primaryActionTitle: step.primaryActionTitle,
                        secondaryActionTitle: step.secondaryActionTitle,
                        onPrimaryAction: onPrimaryAction,
                        onSecondaryAction: onSecondaryAction
                    )
                    .allowsHitTesting(true)
                }
            }
        }
    }
}

public struct SpotlightOverlay: View {
    public let environment: DesignSystemEnvironment
    public let frame: CGRect
    public let title: String
    public let message: String
    public let primaryActionTitle: String?
    public let secondaryActionTitle: String?
    public let onPrimaryAction: (() -> Void)?
    public let onSecondaryAction: (() -> Void)?

    public init(
        environment: DesignSystemEnvironment,
        frame: CGRect,
        title: String,
        message: String,
        primaryActionTitle: String? = nil,
        secondaryActionTitle: String? = nil,
        onPrimaryAction: (() -> Void)? = nil,
        onSecondaryAction: (() -> Void)? = nil
    ) {
        self.environment = environment
        self.frame = frame
        self.title = title
        self.message = message
        self.primaryActionTitle = primaryActionTitle
        self.secondaryActionTitle = secondaryActionTitle
        self.onPrimaryAction = onPrimaryAction
        self.onSecondaryAction = onSecondaryAction
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.black.opacity(environment.reduceMotion ? 0.32 : 0.4))
                    .overlay {
                        RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                            .stroke(environment.theme.color(.focusRing), lineWidth: 2)
                            .frame(width: frame.width + 12, height: frame.height + 12)
                            .position(x: frame.midX, y: frame.midY)
                    }

                overlayCard
                    .frame(width: 280)
                    .position(cardPosition(in: geometry.size))
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .onExitCommand {
            onSecondaryAction?()
        }
    }

    private var overlayCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(environment.theme.typography(.bodyStrong).font)
                .foregroundStyle(environment.theme.color(.textPrimary))

            Text(message)
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(environment.theme.color(.textSecondary))

            if primaryActionTitle != nil || secondaryActionTitle != nil {
                HStack(spacing: 8) {
                    if let secondaryActionTitle, let onSecondaryAction {
                        SystemButton(
                            environment: environment,
                            title: secondaryActionTitle,
                            tone: .secondary,
                            size: .small,
                            action: onSecondaryAction
                        )
                    }

                    Spacer(minLength: 0)

                    if let primaryActionTitle, let onPrimaryAction {
                        SystemButton(
                            environment: environment,
                            title: primaryActionTitle,
                            tone: .primary,
                            size: .small,
                            action: onPrimaryAction
                        )
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .fill(environment.theme.color(.groupedSurface))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(.large), style: .continuous)
                .stroke(environment.theme.color(.strongBorder), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(environment.mode == .dark ? 0.35 : 0.18), radius: 18, y: 10)
    }

    private func cardPosition(in size: CGSize) -> CGPoint {
        let proposedX = min(max(frame.maxX + 160, 160), size.width - 160)
        let proposedY = min(max(frame.maxY + 70, 110), size.height - 110)
        return CGPoint(x: proposedX, y: proposedY)
    }
}
