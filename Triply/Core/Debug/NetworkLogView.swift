#if DEBUG
import SwiftUI

struct NetworkLogView: View {
    @ObservedObject var store: NetworkLogStore
    let dismiss: () -> Void

    var body: some View {
        NavigationStack {
            List {
                if store.entries.isEmpty {
                    ContentUnavailableView(
                        "No Network Logs",
                        systemImage: "network.slash",
                        description: Text("Run a request, then press Ctrl + Cmd + Z again.")
                    )
                } else {
                    ForEach(store.entries) { entry in
                        NetworkLogRow(entry: entry)
                    }
                }
            }
            .navigationTitle("Network Log")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        store.clear()
                    }
                    .disabled(store.entries.isEmpty)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss)
                }
            }
        }
    }
}

private struct NetworkLogRow: View {
    let entry: NetworkLogEntry

    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                detail("URL", entry.url?.absoluteString ?? "-")
                detail("Duration", "\(entry.durationMilliseconds) ms")

                if !entry.requestHeaders.isEmpty {
                    detail("Request Headers", formattedHeaders)
                }

                if let errorMessage = entry.errorMessage {
                    detail("Error", errorMessage)
                }

                if let responsePreview = entry.responsePreview {
                    detail("Response", responsePreview)
                }
            }
            .padding(.vertical, AppSpacing.small)
        } label: {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                HStack(spacing: AppSpacing.small) {
                    Text(verbatim: entry.method)
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundStyle(AppColor.iconPrimary)

                    Text(verbatim: entry.statusText)
                        .font(AppTypography.caption)
                        .foregroundStyle(statusColor)

                    Spacer()

                    Text(verbatim: "\(entry.durationMilliseconds) ms")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }

                Text(verbatim: entry.url?.absoluteString ?? "-")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(2)
            }
        }
    }

    private var statusColor: Color {
        guard let statusCode = entry.statusCode else {
            return AppColor.textSecondary
        }

        return (200...299).contains(statusCode) ? .green : .red
    }

    private var formattedHeaders: String {
        entry.requestHeaders
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")
    }

    private func detail(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
            Text(verbatim: title)
                .font(AppTypography.caption.weight(.semibold))
                .foregroundStyle(AppColor.textPrimary)

            Text(verbatim: value)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(AppColor.textSecondary)
                .textSelection(.enabled)
        }
    }
}
#endif
