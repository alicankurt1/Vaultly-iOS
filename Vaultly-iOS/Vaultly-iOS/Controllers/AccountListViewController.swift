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

    // Profil butonuna basıldığını Coordinator'a bildirir; ekranın nasıl açılacağına (modal/push) VC karışmaz
    var onProfileTapped: (() -> Void)?

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

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz hesabınız yok"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tekrar Dene", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var errorStateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [errorMessageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        view.addSubview(errorStateStack)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorStateStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorStateStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            errorStateStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
            errorStateStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        bindViewModel()
        viewModel.loadAccounts()
    }

    // View model'in hesap listesi ve durumu değiştikçe ekranı günceller
    private func bindViewModel() {
        viewModel.onAccountsChanged = { [weak self] accounts in
            self?.applySnapshot(with: accounts)
        }
        viewModel.onStateChanged = { [weak self] state in
            self?.render(state)
        }
    }

    // Loading/hata/boş/dolu durumlarından hangisi aktifse sadece onu gösterir
    private func render(_ state: AccountListViewModel.State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            collectionView.isHidden = true
            emptyStateLabel.isHidden = true
            errorStateStack.isHidden = true
        case .loaded:
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            emptyStateLabel.isHidden = true
            errorStateStack.isHidden = true
        case .empty:
            activityIndicator.stopAnimating()
            collectionView.isHidden = true
            emptyStateLabel.isHidden = false
            errorStateStack.isHidden = true
        case .error(let message):
            activityIndicator.stopAnimating()
            collectionView.isHidden = true
            emptyStateLabel.isHidden = true
            errorMessageLabel.text = message
            errorStateStack.isHidden = false
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

    // Profil ekranının nasıl açılacağı (modal + ayrı Coordinator) Coordinator'ın kararı
    @objc private func profileTapped() {
        onProfileTapped?()
    }

    // Hata durumunda kullanıcı isteğiyle yüklemeyi baştan dener
    @objc private func retryTapped() {
        viewModel.loadAccounts()
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
