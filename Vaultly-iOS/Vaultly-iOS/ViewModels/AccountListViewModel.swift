//
//  AccountListViewModel.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// Hesap listesinin iş mantığını taşır; ViewController sadece bu sınıfı dinler ve tetikler
final class AccountListViewModel {

    // Set edildiğinde ekranı bilgilendirmek için closure tabanlı binding kullanılıyor
    var onAccountsChanged: (([Account]) -> Void)?

    private(set) var accounts: [Account] = [] {
        didSet { onAccountsChanged?(accounts) }
    }

    // Mock veri kaynağından hesapları yükler (Faz 6'da gerçek servisle değişecek)
    func loadAccounts() {
        accounts = Account.mockAccounts
    }

    // Listeye rastgele bir mock hesap ekler
    func addRandomAccount() {
        accounts.append(.randomMockAccount())
    }

    // Verilen id'ye sahip hesabı listeden çıkarır
    func deleteAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
    }
}
