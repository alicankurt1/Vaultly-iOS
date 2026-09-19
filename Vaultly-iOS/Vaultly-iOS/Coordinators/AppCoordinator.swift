//
//  AppCoordinator.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

// Composition root artık burası: hangi servisin hangi view model'e,
// hangi ekrana bağlandığı ve ekranlar arası geçişler tek yerde toplanıyor
final class AppCoordinator: Coordinator {

    private let navigationController: UINavigationController

    // Modal olarak açılan alt akışları (SettingsCoordinator gibi) burada tutmazsak deinit olurlar
    private var childCoordinators: [Coordinator] = []

    // "İşlem Detayı"ndan "Hesap Detayı"na dönebilmek (popToViewController) için referansı saklanıyor
    private weak var accountDetailViewController: AccountDetailViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showAccountList()
    }

    private func showAccountList() {
        let accountService = SampleAccountService()
        let viewModel = AccountListViewModel(service: accountService)
        let accountListViewController = AccountListViewController(viewModel: viewModel)

        accountListViewController.onAccountSelected = { [weak self] account in
            self?.showAccountDetail(account)
        }
        accountListViewController.onProfileTapped = { [weak self] in
            self?.showSettings()
        }

        navigationController.setViewControllers([accountListViewController], animated: false)
    }

    // ViewController push/present çağrısı yapmaz; ekran geçişi kararını Coordinator verir
    private func showAccountDetail(_ account: Account) {
        let detailViewController = AccountDetailViewController(account: account)
        detailViewController.onShowTransactions = { [weak self] account in
            self?.showTransactions(for: account)
        }

        accountDetailViewController = detailViewController
        navigationController.pushViewController(detailViewController, animated: true)
    }

    private func showTransactions(for account: Account) {
        let transactionListViewController = TransactionListViewController(account: account)
        transactionListViewController.onTransactionSelected = { [weak self] transaction in
            self?.showTransactionDetail(transaction)
        }

        navigationController.pushViewController(transactionListViewController, animated: true)
    }

    private func showTransactionDetail(_ transaction: Transaction) {
        let transactionDetailViewController = TransactionDetailViewController(transaction: transaction)

        // "Hesap Detayına Dön": stack'te zaten duran o ekrana kadar geri sarar (İşlem Listesi de bu arada kapanır)
        transactionDetailViewController.onReturnToAccountDetail = { [weak self] in
            guard let self, let accountDetailViewController = self.accountDetailViewController else { return }
            self.navigationController.popToViewController(accountDetailViewController, animated: true)
        }

        // "Ana Sayfaya Dön": tüm stack'i temizleyip köke (Hesap Listesi'ne) döner
        transactionDetailViewController.onReturnToHome = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }

        navigationController.pushViewController(transactionDetailViewController, animated: true)
    }

    // Profil ekranını modal + kendi navigation stack'iyle, ayrı bir Coordinator olarak açar
    private func showSettings() {
        let settingsNavigationController = UINavigationController()
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavigationController)

        settingsCoordinator.onFinish = { [weak self, weak settingsNavigationController] in
            settingsNavigationController?.dismiss(animated: true)
            self?.childCoordinators.removeAll { $0 === settingsCoordinator }
        }

        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()

        settingsNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(settingsNavigationController, animated: true)
    }
}
