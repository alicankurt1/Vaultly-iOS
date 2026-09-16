//
//  SceneDelegate.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    // Storyboard yok: pencereyi ve root controller'ı kod ile kurup gösterir
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = AccountListViewController()
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
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

