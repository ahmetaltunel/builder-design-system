import SwiftUI
import BuilderFoundation
import BuilderBehaviors

public struct PaginationControl: View {
    public let environment: DesignSystemEnvironment
    @Binding public var page: Int
    public let pageCount: Int

    public init(
        environment: DesignSystemEnvironment,
        page: Binding<Int>,
        pageCount: Int
    ) {
        self.environment = environment
        self._page = page
        self.pageCount = max(pageCount, 1)
    }

    public init<Item: Identifiable & Hashable>(
        environment: DesignSystemEnvironment,
        controller: CollectionController<Item>
    ) {
        self.environment = environment
        self._page = Binding(
            get: { controller.currentPage },
            set: { controller.setPage($0) }
        )
        self.pageCount = max(controller.pageCount, 1)
    }

    public var body: some View {
        HStack(spacing: 8) {
            ToolbarButton(environment: environment, title: "Previous", symbol: "chevron.left") {
                page = max(page - 1, 1)
            }

            HStack(spacing: 6) {
                ForEach(visiblePages, id: \.self) { item in
                    Button {
                        page = item
                    } label: {
                        Text("\(item)")
                            .font(environment.theme.typography(.bodyStrong).font)
                            .foregroundStyle(item == page ? environment.theme.color(.textOnAccent) : environment.theme.color(.textPrimary))
                            .frame(width: 32, height: 32)
                            .background(
                                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                    .fill(item == page ? environment.theme.color(.accentPrimary) : environment.theme.color(.inputSurface))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                                    .stroke(item == page ? .clear : environment.theme.color(.subtleBorder), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            ToolbarButton(environment: environment, title: "Next", symbol: "chevron.right") {
                page = min(page + 1, pageCount)
            }
        }
    }

    private var visiblePages: [Int] {
        let lower = max(1, page - 1)
        let upper = min(pageCount, page + 1)
        let pages = Array(lower...upper)

        if pages.count == 1 && pageCount > 1 {
            return [1, min(2, pageCount)]
        }

        return pages
    }
}
