//
//  TransactionDetailViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class TransactionDetailViewController: UIViewController {

    private let transaction: Transaction

    // "Nereye dönmek istiyorum" kararını da Coordinator versin diye iki ayrı closure kullanılıyor;
    // VC hangi ekranın stack'te nerede durduğunu bilmiyor, sadece niyetini bildiriyor
    var onReturnToAccountDetail: (() -> Void)?
    var onReturnToHome: (() -> Void)?

    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "İşlem Detayı"
        view.backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = transaction.title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)

        let amountLabel = UILabel()
        amountLabel.text = transaction.formattedAmount
        amountLabel.font = .systemFont(ofSize: 28, weight: .heavy)

        let dateLabel = UILabel()
        dateLabel.text = transaction.formattedDate
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .secondaryLabel

        let accountDetailButton = UIButton(type: .system)
        accountDetailButton.setTitle("Hesap Detayına Dön", for: .normal)
        accountDetailButton.addTarget(self, action: #selector(accountDetailTapped), for: .touchUpInside)

        let homeButton = UIButton(type: .system)
        homeButton.setTitle("Ana Sayfaya Dön", for: .normal)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, amountLabel, dateLabel, accountDetailButton, homeButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }

    // Buton doğrudan navigationController'a dokunmuyor; pop kararını Coordinator veriyor
    @objc private func accountDetailTapped() {
        onReturnToAccountDetail?()
    }

    @objc private func homeTapped() {
        onReturnToHome?()
    }
}
