import Foundation
import UniformTypeIdentifiers
import AppKit

@MainActor
public enum ItemProviderURLBridge {
    public static func resolveURLs(providers: [NSItemProvider]) async -> [URL] {
        let candidateProviders = providers.filter {
            $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier)
        }

        var urls: [URL] = []

        for provider in candidateProviders {
            if let url = await resolveURL(provider: provider) {
                urls.append(url)
            }
        }

        return uniqueURLs(urls)
    }

    private static func resolveURL(provider: NSItemProvider) async -> URL? {
        await withCheckedContinuation { continuation in
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                continuation.resume(returning: resolvedURL(from: item))
            }
        }
    }
}

public func resolvedURL(from item: NSSecureCoding?) -> URL? {
    if let url = item as? URL {
        return url
    }

    if let data = item as? Data {
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    if let string = item as? String {
        return URL(string: string)
    }

    return nil
}

public func fileContentType(for url: URL) -> UTType? {
    if let resolvedType = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType {
        return resolvedType
    }

    return UTType(filenameExtension: url.pathExtension)
}

public func matchesAcceptedContentType(_ url: URL, acceptedContentTypes: [UTType]) -> Bool {
    let constrainedTypes = acceptedContentTypes.filter { $0 != .fileURL }
    guard !constrainedTypes.isEmpty else { return true }

    let resolvedType = fileContentType(for: url)
    return constrainedTypes.contains { acceptedType in
        resolvedType?.conforms(to: acceptedType) == true
    }
}

public func uniqueURLs(_ urls: [URL]) -> [URL] {
    var seen: Set<URL> = []
    var uniqueURLs: [URL] = []

    for url in urls where !seen.contains(url) {
        seen.insert(url)
        uniqueURLs.append(url)
    }

    return uniqueURLs
}
