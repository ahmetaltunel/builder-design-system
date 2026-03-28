import SwiftUI
import BuilderFoundation

public struct TreeView: View {
    public struct Node: Identifiable, Hashable {
        public let id: String
        public let title: String
        public let children: [Node]

        public init(id: String? = nil, title: String, children: [Node] = []) {
            self.id = id ?? title
            self.title = title
            self.children = children
        }
    }

    public let environment: DesignSystemEnvironment
    public let nodes: [Node]
    @Binding public var selection: String?

    public init(environment: DesignSystemEnvironment, nodes: [Node], selection: Binding<String?>) {
        self.environment = environment
        self.nodes = nodes
        self._selection = selection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(nodes) { node in
                TreeNodeRow(environment: environment, node: node, selection: $selection, depth: 0)
            }
        }
    }
}

private struct TreeNodeRow: View {
    let environment: DesignSystemEnvironment
    let node: TreeView.Node
    @Binding var selection: String?
    let depth: Int
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                if node.children.isEmpty {
                    selection = node.id
                } else {
                    isExpanded.toggle()
                    selection = node.id
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: node.children.isEmpty ? "doc" : (isExpanded ? "chevron.down" : "chevron.right"))
                        .font(.system(size: 10, weight: .semibold))
                    Text(node.title)
                    Spacer()
                }
                .font(environment.theme.typography(.body).font)
                .foregroundStyle(selection == node.id ? environment.theme.color(.textPrimary) : environment.theme.color(.textSecondary))
                .padding(.leading, CGFloat(depth) * 16)
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous)
                        .fill(selection == node.id ? environment.theme.color(.sidebarSelection) : .clear)
                )
                .contentShape(RoundedRectangle(cornerRadius: environment.theme.radius(.medium), style: .continuous))
            }
            .buttonStyle(.plain)

            if isExpanded {
                ForEach(node.children) { child in
                    TreeNodeRow(environment: environment, node: child, selection: $selection, depth: depth + 1)
                }
            }
        }
    }
}
