//
//  AccountDetailViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class AccountDetailViewController: UIViewController {

    private let account: Account

    // "İşlemler" butonuna basıldığında Coordinator'a hangi hesap için gidileceğini bildirir
    var onShowTransactions: ((Account) -> Void)?

    // Coordinator dışında oluşturulmasın diye init'te doğrudan veri isteniyor
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ibanLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesap Detayı"
        view.backgroundColor = .systemBackground

        nameLabel.text = account.name
        ibanLabel.text = account.iban
        balanceLabel.text = account.formattedBalance

        let transactionsButton = UIButton(type: .system)
        transactionsButton.setTitle("İşlemler", for: .normal)
        transactionsButton.addTarget(self, action: #selector(transactionsTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameLabel, ibanLabel, balanceLabel, transactionsButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }

    // Buton doğrudan push çağırmaz; hangi hesap için gidileceğini Coordinator'a bildirir
    @objc private func transactionsTapped() {
        onShowTransactions?(account)
    }
}
