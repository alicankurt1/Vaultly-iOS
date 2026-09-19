//
//  AccountListViewController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

final class AccountListViewController: UIViewController {

    // Diffable data source tek bölüm kullandığı için enum ile temsil ediliyor;
    // nonisolated olması Sendable şartını sağlıyor (bkz. Account.swift)
    private nonisolated enum Section: Hashable, Sendable {
        case main
    }

    private let viewModel: AccountListViewModel

    // Hücre seçimini Coordinator'a bildirir; VC kendi push/present çağırmaz
    var onAccountSelected: ((Account) -> Void)?

    // Composition root (AppCoordinator) view model'i buradan enjekte eder;
    // default değer sadece hızlı deneme/önizleme için var
    init(viewModel: AccountListViewModel = AccountListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // Storyboard/xib üzerinden init desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    // Ekranı kurar, view model'e bağlanır ve ilk veriyi yükletir
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesaplarım"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAccountTapped)
        )

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        bindViewModel()
        viewModel.loadAccounts()
    }

    // View model'in hesap listesi değiştikçe ekranı günceller
    private func bindViewModel() {
        viewModel.onAccountsChanged = { [weak self] accounts in
            self?.applySnapshot(with: accounts)
        }
    }

    // Tek sütunlu, tahmini yükseklikli kartlardan oluşan compositional layout kurar.
    // Sola kaydırma aksiyonları yalnızca list-tabanlı section'larda otomatik çalıştığı
    // için NSCollectionLayoutSection.list(using:) kullanılıyor, kart boşlukları/inset'leri
    // üzerine yeniden uygulanıyor.
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.backgroundColor = .clear
            configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
                self?.trailingSwipeActionsConfiguration(at: indexPath)
            }

            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
    }

    // Sola kaydırınca çıkacak "Sil" aksiyonunu kurar; silme kararını view model verir
    private func trailingSwipeActionsConfiguration(at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self, let account = self.dataSource.itemIdentifier(for: indexPath) else {
                completion(false)
                return
            }
            self.viewModel.deleteAccount(id: account.id)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // Verilen hesap listesini diffable snapshot'a çevirip uygular
    private func applySnapshot(with accounts: [Account]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Account>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accounts, toSection: .main)
        let isInitialLoad = dataSource.snapshot().numberOfSections == 0
        dataSource.apply(snapshot, animatingDifferences: !isInitialLoad)
    }

    // Rastgele bir mock hesap eklenmesini view model'den ister
    @objc private func addAccountTapped() {
        viewModel.addRandomAccount()
    }
}

extension AccountListViewController: UICollectionViewDelegate {
    // Seçimi görsel olarak temizler ve hangi hesabın seçildiğini Coordinator'a iletir
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let account = dataSource.itemIdentifier(for: indexPath) else { return }
        onAccountSelected?(account)
    }
}
