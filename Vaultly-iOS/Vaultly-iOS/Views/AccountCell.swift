//
//  AccountCell.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class AccountCell: UICollectionViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ibanLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Hücre kod ile oluşturulduğunda layout'u kurar
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Hücredeki etiketleri verilen hesaba göre doldurur
    func configure(with account: Account) {
        nameLabel.text = account.name
        ibanLabel.text = account.iban
        balanceLabel.text = account.formattedBalance
    }

    // Etiketleri NSLayoutConstraint ile contentView'a yerleştirir
    private func setUpLayout() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous

        let textStack = UIStackView(arrangedSubviews: [nameLabel, ibanLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStack)
        contentView.addSubview(balanceLabel)

        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            balanceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textStack.trailingAnchor, constant: 8),
            balanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            balanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
