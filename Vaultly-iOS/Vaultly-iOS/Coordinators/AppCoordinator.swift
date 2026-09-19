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

        navigationController.setViewControllers([accountListViewController], animated: false)
    }

    // ViewController push/present çağrısı yapmaz; ekran geçişi kararını Coordinator verir
    private func showAccountDetail(_ account: Account) {
        let detailViewController = AccountDetailViewController(account: account)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
