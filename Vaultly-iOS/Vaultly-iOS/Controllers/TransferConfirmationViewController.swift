//
//  TransferConfirmationViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class TransferConfirmationViewController: UIViewController {

    private let account: Account
    private let amount: Decimal

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    // transitioningDelegate weak tutulduğu için özel geçişin hayatta kalması için burada güçlü referans şart
    private let transitionController = TransferConfirmationTransitioningDelegate()

    init(account: Account, amount: Decimal) {
        self.account = account
        self.amount = amount
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionController
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let handleView = UIView()
        handleView.backgroundColor = .tertiaryLabel
        handleView.layer.cornerRadius = 2.5
        handleView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Transferi Onayla"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        let summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.text = "\(account.name) hesabından \(formattedAmount) gönderilecek."

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Onayla", for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Vazgeç", for: .normal)
        cancelButton.setTitleColor(.secondaryLabel, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, summaryLabel, confirmButton, cancelButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(handleView)
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 36),
            handleView.heightAnchor.constraint(equalToConstant: 5),

            stack.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = account.currencyCode
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    @objc private func confirmTapped() {
        onConfirm?()
    }

    @objc private func cancelTapped() {
        onCancel?()
    }
}
