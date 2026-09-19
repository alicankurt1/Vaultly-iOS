//
//  TransferViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class TransferViewController: UIViewController {

    private let account: Account

    // Geçerli bir tutar girildiğinde Coordinator'a bildirir; ekran geçişine VC karışmaz
    var onContinue: ((Decimal) -> Void)?

    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let amountField: UITextField = {
        let field = UITextField()
        field.placeholder = "Tutar girin"
        field.keyboardType = .decimalPad
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Para Transferi"
        view.backgroundColor = .systemBackground

        let accountLabel = UILabel()
        accountLabel.text = "\(account.name) hesabından gönderilecek"
        accountLabel.textColor = .secondaryLabel
        accountLabel.numberOfLines = 0

        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Devam Et", for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [accountLabel, amountField, continueButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }

    // Girilen tutarı doğrular; geçersizse sessizce hiçbir şey yapmaz
    @objc private func continueTapped() {
        let normalized = (amountField.text ?? "").replacingOccurrences(of: ",", with: ".")
        guard let amount = Decimal(string: normalized), amount > 0 else { return }
        onContinue?(amount)
    }
}
