#if DEBUG
import SwiftUI
import UIKit

struct DebugKeyboardShortcutView: UIViewControllerRepresentable {
    let input: String
    let modifierFlags: UIKeyModifierFlags
    let discoverabilityTitle: String
    let action: () -> Void

    func makeUIViewController(context: Context) -> DebugKeyboardShortcutViewController {
        DebugKeyboardShortcutViewController(
            input: input,
            modifierFlags: modifierFlags,
            discoverabilityTitle: discoverabilityTitle,
            action: action
        )
    }

    func updateUIViewController(_ viewController: DebugKeyboardShortcutViewController, context: Context) {
        viewController.input = input
        viewController.modifierFlags = modifierFlags
        viewController.discoverabilityTitle = discoverabilityTitle
        viewController.action = action
    }
}

final class DebugKeyboardShortcutViewController: UIViewController {
    var input: String
    var modifierFlags: UIKeyModifierFlags
    var discoverabilityTitle: String
    var action: () -> Void

    init(
        input: String,
        modifierFlags: UIKeyModifierFlags,
        discoverabilityTitle: String,
        action: @escaping () -> Void
    ) {
        self.input = input
        self.modifierFlags = modifierFlags
        self.discoverabilityTitle = discoverabilityTitle
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(
                title: discoverabilityTitle,
                image: nil,
                action: #selector(handleCommand),
                input: input,
                modifierFlags: modifierFlags,
                propertyList: nil
            )
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        becomeFirstResponder()
    }

    @objc private func handleCommand() {
        action()
    }
}
#endif
