//
//  SceneDelegate.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Coordinator sınıf içinde tutulmazsa deinit olur; referansı burada saklıyoruz
    private var appCoordinator: Coordinator?

    // Storyboard yok: pencereyi kurar, dependency/navigasyon kurulumunu Coordinator'a bırakır
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator = coordinator
        coordinator.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    // Scene sistem tarafından serbest bırakılırken çağrılır
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    // Scene aktif hale geldiğinde çağrılır
    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    // Scene aktiflikten çıkmadan hemen önce çağrılır
    func sceneWillResignActive(_ scene: UIScene) {
    }

    // Scene arka plandan ön plana geçerken çağrılır
    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    // Scene arka plana geçerken çağrılır
    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

