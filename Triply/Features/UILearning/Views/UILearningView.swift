import SwiftUI
import UIKit

struct UILearningView: View {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    @State private var swiftUICounter = 0

    private var selectedLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .system
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                UILearningHeaderView()

                VStack(spacing: AppSpacing.medium) {
                    SwiftUIStateExample(count: $swiftUICounter)
                    UIKitProgrammaticExample(language: selectedLanguage)
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

            Text("ui_learning.title")
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            Text(
                "ui_learning.subtitle"
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
                Text("ui_learning.swiftui.title")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColor.primary)

                Text("ui_learning.swiftui.description")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
            }

            HStack {
                Text("ui_learning.counter.count \(count)")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppColor.textPrimary)

                Spacer()

                Button {
                    count += 1
                } label: {
                    Label("ui_learning.action.add", systemImage: "plus")
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
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("ui_learning.uikit.title")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColor.primary)

                Text("ui_learning.uikit.description")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
            }

            UIKitCounterViewRepresentable(
                addTitle: language.localizedString(forKey: "ui_learning.action.add"),
                countFormat: language.localizedString(forKey: "ui_learning.counter.count_format")
            )
            .frame(height: 92)
        }
        .padding(AppSpacing.medium)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct UIKitCounterViewRepresentable: UIViewRepresentable {
    let addTitle: String
    let countFormat: String

    func makeUIView(context: Context) -> UIKitCounterView {
        UIKitCounterView(addTitle: addTitle, countFormat: countFormat)
    }

    func updateUIView(_ uiView: UIKitCounterView, context: Context) {
        uiView.updateTexts(addTitle: addTitle, countFormat: countFormat)
    }
}

private final class UIKitCounterView: UIView {
    private let countLabel = UILabel()
    private let addButton = UIButton(type: .system)

    private var count = 0
    private var addTitle: String
    private var countFormat: String

    init(addTitle: String, countFormat: String) {
        self.addTitle = addTitle
        self.countFormat = countFormat
        super.init(frame: .zero)
        setupView()
        updateCountLabel()
    }

    override init(frame: CGRect) {
        addTitle = AppLanguage.system.localizedString(forKey: "ui_learning.action.add")
        countFormat = AppLanguage.system.localizedString(forKey: "ui_learning.counter.count_format")
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
        addButton.configuration?.title = addTitle
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

    func updateTexts(addTitle: String, countFormat: String) {
        self.addTitle = addTitle
        self.countFormat = countFormat
        addButton.configuration?.title = addTitle
        updateCountLabel()
    }

    private func updateCountLabel() {
        countLabel.text = String(format: countFormat, Int64(count))
    }
}
