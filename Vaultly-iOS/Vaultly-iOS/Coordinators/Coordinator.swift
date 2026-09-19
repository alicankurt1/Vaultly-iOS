//
//  Coordinator.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// Navigasyon akışlarını tek bir yerden yönetmek için ortak sözleşme;
// her ekran grubu kendi Coordinator'ını bu protokole uydurarak ekler
protocol Coordinator: AnyObject {
    func start()
}
