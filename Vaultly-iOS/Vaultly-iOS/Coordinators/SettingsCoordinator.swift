//
//  SettingsCoordinator.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

// Modal olarak açılan, kendi navigation stack'ine sahip bağımsız bir akış;
// bittiğinde parent'a (AppCoordinator) haber vermek için onFinish kullanılıyor
final class SettingsCoordinator: Coordinator {

    private let navigationController: UINavigationController
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.onClose = { [weak self] in
            self?.onFinish?()
        }
        navigationController.setViewControllers([settingsViewController], animated: false)
    }
}
