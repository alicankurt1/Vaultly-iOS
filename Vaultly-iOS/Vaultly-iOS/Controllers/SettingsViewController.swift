//
//  SettingsViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class SettingsViewController: UIViewController {

    // Modal'ı kapatma kararını da Coordinator versin diye closure kullanılıyor
    var onClose: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profil"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )

        let label = UILabel()
        label.text = "Profil ekranı (örnek akış)"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func closeTapped() {
        onClose?()
    }
}
