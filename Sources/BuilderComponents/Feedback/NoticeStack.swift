import SwiftUI
import BuilderFoundation

public struct NoticeStack: View {
    public struct Notice {
        public let title: String
        public let message: String
        public let tone: AlertBanner.Tone

        public init(title: String, message: String, tone: AlertBanner.Tone = .info) {
            self.title = title
            self.message = message
            self.tone = tone
        }
    }

    public let environment: DesignSystemEnvironment
    public let notices: [Notice]

    public init(environment: DesignSystemEnvironment, notices: [Notice]) {
        self.environment = environment
        self.notices = notices
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(notices.enumerated()), id: \.offset) { _, notice in
                AlertBanner(
                    environment: environment,
                    title: notice.title,
                    message: notice.message,
                    tone: notice.tone
                )
            }
        }
    }
}
