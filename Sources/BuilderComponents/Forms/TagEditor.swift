import SwiftUI
import BuilderFoundation

public struct TagEditor: View {
    public let environment: DesignSystemEnvironment
    @Binding public var tags: [String]
    @State private var draft = ""

    public init(environment: DesignSystemEnvironment, tags: Binding<[String]>) {
        self.environment = environment
        self._tags = tags
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    HStack(spacing: 6) {
                        Text(tag)
                            .font(environment.theme.typography(.caption).font.weight(.medium))
                        Button {
                            tags.removeAll { $0 == tag }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .buttonStyle(.plain)
                    }
                    .foregroundStyle(environment.theme.color(.textPrimary))
                    .padding(.horizontal, 10)
                    .frame(height: 28)
                    .background(
                        Capsule(style: .continuous)
                            .fill(environment.theme.color(.inputSurface))
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
                    )
                }
            }

            HStack(spacing: 10) {
                TextField("Add tag", text: $draft)
                    .textFieldStyle(.plain)
                    .font(environment.theme.typography(.body).font)
                    .foregroundStyle(environment.theme.color(.textPrimary))
                    .onSubmit(addDraft)

                Button("Add", action: addDraft)
                    .buttonStyle(.plain)
                    .font(environment.theme.typography(.button).font)
                    .foregroundStyle(environment.theme.color(.accentPrimary))
            }
            .padding(.horizontal, 14)
            .frame(height: 38)
            .background(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .fill(environment.theme.color(.inputSurface))
            )
            .overlay(
                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                    .stroke(environment.theme.color(.subtleBorder), lineWidth: 1)
            )
        }
    }

    private func addDraft() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        if tags.contains(trimmed) == false {
            tags.append(trimmed)
        }
        draft = ""
    }
}

private struct FlowLayout<Content: View>: View {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let content: Content

    init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat, @ViewBuilder content: () -> Content) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content()
    }

    var body: some View {
        content
    }
}
