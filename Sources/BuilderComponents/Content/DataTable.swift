import SwiftUI
import BuilderFoundation

public struct DataTable: View {
    public struct Column {
        public let title: String
        public let width: CGFloat?
        public let alignment: Alignment

        public init(title: String, width: CGFloat? = nil, alignment: Alignment = .leading) {
            self.title = title
            self.width = width
            self.alignment = alignment
        }
    }

    public struct Row: Identifiable {
        public let id: String
        public let cells: [String]

        public init(id: String, cells: [String]) {
            self.id = id
            self.cells = cells
        }
    }

    public let environment: DesignSystemEnvironment
    public let columns: [Column]
    public let rows: [Row]
    @Binding public var selectedRowID: String?

    public init(
        environment: DesignSystemEnvironment,
        columns: [Column],
        rows: [Row],
        selectedRowID: Binding<String?>
    ) {
        self.environment = environment
        self.columns = columns
        self.rows = rows
        self._selectedRowID = selectedRowID
    }

    public var body: some View {
        let headerMaterial = environment.theme.material(.tableHeader)
        let rowMaterial = environment.theme.material(.tableRow)
        let selectedMaterial = environment.theme.material(.selected)
        let containerMaterial = environment.theme.material(.panel)

        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(columns.enumerated()), id: \.offset) { index, column in
                    Text(column.title)
                        .font(environment.theme.typography(.label).font)
                        .foregroundStyle(environment.theme.color(.textSecondary))
                        .frame(maxWidth: .infinity, alignment: column.alignment)
                        .frame(width: column.width, alignment: column.alignment)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)

                    if index < columns.count - 1 {
                        verticalDivider
                    }
                }
            }
            .background(headerMaterial.fill.opacity(headerMaterial.fillOpacity))

            horizontalDivider

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                Button {
                    selectedRowID = row.id
                } label: {
                    HStack(spacing: 0) {
                        ForEach(Array(columns.enumerated()), id: \.offset) { columnIndex, column in
                            Text(row.cells.indices.contains(columnIndex) ? row.cells[columnIndex] : "")
                                .font(environment.theme.typography(.body).font)
                                .foregroundStyle(environment.theme.color(.textPrimary))
                                .frame(maxWidth: .infinity, alignment: column.alignment)
                                .frame(width: column.width, alignment: column.alignment)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 11)

                            if columnIndex < columns.count - 1 {
                                verticalDivider
                            }
                        }
                    }
                    .background(
                        selectedRowID == row.id
                        ? selectedMaterial.fill.opacity(selectedMaterial.fillOpacity)
                        : ((index.isMultiple(of: 2) ? rowMaterial.fill : environment.theme.material(.card).fill)
                            .opacity(index.isMultiple(of: 2) ? rowMaterial.fillOpacity : environment.theme.material(.card).fillOpacity))
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < rows.count - 1 {
                    horizontalDivider
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: environment.theme.radius(containerMaterial.radius), style: .continuous)
                .fill(containerMaterial.fill.opacity(containerMaterial.fillOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: environment.theme.radius(containerMaterial.radius), style: .continuous)
                .stroke(containerMaterial.border, lineWidth: containerMaterial.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: environment.theme.radius(containerMaterial.radius), style: .continuous))
    }

    private var verticalDivider: some View {
        Rectangle()
            .fill(environment.theme.color(.subtleBorder))
            .frame(width: 1)
    }

    private var horizontalDivider: some View {
        Rectangle()
            .fill(environment.theme.color(.subtleBorder))
            .frame(height: 1)
    }
}
