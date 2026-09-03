import SwiftUI
import UIKit

struct UILearningView: View {
    @State private var swiftUICounter = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                UILearningHeaderView()

                VStack(spacing: AppSpacing.medium) {
                    SwiftUIStateExample(count: $swiftUICounter)
                    UIKitProgrammaticExample()
                }
            }
            .padding(AppSpacing.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}

#Preview {
    UILearningView()
}

private struct UILearningHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Image(systemName: "rectangle.3.group")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(AppColor.primary)
                .frame(width: 56, height: 56)
                .background(AppColor.primary.opacity(0.12))
                .clipShape(Circle())

            Text("UI learning")
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            Text(
                "Tap each button and compare how SwiftUI state updates the view automatically while UIKit updates its labels manually."
            )
            .font(AppTypography.body)
            .foregroundStyle(AppColor.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct SwiftUIStateExample: View {
    @Binding var count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("SwiftUI")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColor.primary)

                Text("State changes update this text automatically.")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
            }

            HStack {
                Text("Count: \(count)")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppColor.textPrimary)

                Spacer()

                Button {
                    count += 1
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(AppTypography.body.weight(.semibold))
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColor.primary)
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct UIKitProgrammaticExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("UIKit Programmatic")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColor.primary)

                Text("The embedded UIKit view updates its label manually.")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
            }

            UIKitCounterViewRepresentable()
                .frame(height: 92)
        }
        .padding(AppSpacing.medium)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct UIKitCounterViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIKitCounterView {
        UIKitCounterView()
    }

    func updateUIView(_ uiView: UIKitCounterView, context: Context) {}
}

private final class UIKitCounterView: UIView {
    private let countLabel = UILabel()
    private let addButton = UIButton(type: .system)

    private var count = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateCountLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous

        countLabel.font = .preferredFont(forTextStyle: .title2)
        countLabel.adjustsFontForContentSizeCategory = true
        countLabel.textColor = .label

        addButton.configuration = .filled()
        addButton.configuration?.title = "Add"
        addButton.configuration?.image = UIImage(systemName: "plus")
        addButton.configuration?.imagePadding = 6
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [countLabel, addButton])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapAddButton() {
        count += 1
        updateCountLabel()
    }

    private func updateCountLabel() {
        countLabel.text = "Count: \(count)"
    }
}
