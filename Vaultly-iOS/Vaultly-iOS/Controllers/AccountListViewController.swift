//
//  AccountListViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class AccountListViewController: UIViewController {

    private let accounts = Account.mockAccounts

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountCell.self, forCellReuseIdentifier: AccountCell.reuseIdentifier)
        return tableView
    }()

    // Tablo görünümünü kurar ve mock hesap verisiyle ekranı hazırlar
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesaplarım"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AccountListViewController: UITableViewDataSource {
    // Listelenecek hesap sayısını döner
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }

    // İlgili satır için hücreyi hesap verisiyle doldurup döner
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {
            return UITableViewCell()
        }
        cell.configure(with: accounts[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension AccountListViewController: UITableViewDelegate {
    // Satır seçimini görsel olarak temizler (detay ekranı Faz 5'te eklenecek)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
