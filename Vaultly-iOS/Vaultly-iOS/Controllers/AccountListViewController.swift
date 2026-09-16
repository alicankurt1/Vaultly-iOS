//
//  AccountListViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class AccountListViewController: UIViewController {

    // Diffable data source tek bölüm kullandığı için enum ile temsil ediliyor
    private enum Section {
        case main
    }

    private var accounts = Account.mockAccounts

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        return collectionView
    }()

    private let cellRegistration = UICollectionView.CellRegistration<AccountCell, Account> { cell, _, account in
        cell.configure(with: account)
    }

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Account>(
        collectionView: collectionView
    ) { [cellRegistration] collectionView, indexPath, account in
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: account)
    }

    // Ekranı kurar, collection view'ı yerleştirir ve ilk snapshot'ı uygular
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesaplarım"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addMockAccountTapped)
        )

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        applySnapshot(animatingDifferences: false)
    }

    // Tek sütunlu, tahmini yükseklikli kartlardan oluşan compositional layout kurar
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(72)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(72)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // Mevcut accounts dizisini diffable snapshot'a çevirip uygular
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Account>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accounts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    // Listeye rastgele bir mock hesap ekleyip animasyonlu snapshot günceller
    @objc private func addMockAccountTapped() {
        accounts.append(.randomMockAccount())
        applySnapshot()
    }
}

extension AccountListViewController: UICollectionViewDelegate {
    // Seçimi görsel olarak temizler (detay ekranı Faz 5'te eklenecek)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    // Sola kaydırınca hesabı silip animasyonlu snapshot günceller
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self, let account = self.dataSource.itemIdentifier(for: indexPath) else {
                completion(false)
                return
            }
            self.accounts.removeAll { $0.id == account.id }
            self.applySnapshot()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
