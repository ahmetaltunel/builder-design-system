import Foundation
import BuilderReferenceExamples

package struct ComponentSnippet {
    package let title: String
    package let summary: String
    package let code: String
}

package struct PatternSnippet {
    package let title: String
    package let summary: String
    package let code: String
}

package enum CatalogSnippetRegistry {
    package static func componentSnippet(for entry: ComponentCatalogEntry) -> ComponentSnippet {
        let example = BuilderReferenceExamples.componentExample(
            id: entry.canonicalExampleID,
            displayName: entry.name,
            family: entry.previewGroup.exampleFamily
        )
        return .init(title: example.title, summary: example.summary, code: example.code)
    }

    package static func patternSnippet(for entry: PatternCatalogEntry) -> PatternSnippet {
        let example = BuilderReferenceExamples.patternExample(
            id: entry.canonicalExampleID,
            displayName: entry.name,
            family: entry.previewGroup.exampleFamily
        )
        return .init(title: example.title, summary: example.summary, code: example.code)
    }
}
