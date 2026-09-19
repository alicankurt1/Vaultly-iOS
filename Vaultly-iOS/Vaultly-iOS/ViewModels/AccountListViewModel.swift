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

    // Somut servis sınıfı yerine protokol tutuluyor; test ve Faz 6'daki gerçek servis bu sayede enjekte edilebilir
    private let service: AccountServicing

    init(service: AccountServicing = SampleAccountService()) {
        self.service = service
    }

    // Hesapları enjekte edilen servisten yükler
    func loadAccounts() {
        accounts = service.fetchAccounts()
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
