//
//  AccountListViewModel.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// Hesap listesinin iş mantığını taşır; ViewController sadece bu sınıfı dinler ve tetikler
final class AccountListViewModel {

    // Ekranın hangi durumu göstereceğine (loading/hata/boş/dolu) VC değil ViewModel karar verir
    enum State: Equatable {
        case loading
        case loaded
        case empty
        case error(String)
    }

    // Set edildiğinde ekranı bilgilendirmek için closure tabanlı binding kullanılıyor
    var onAccountsChanged: (([Account]) -> Void)?
    var onStateChanged: ((State) -> Void)?

    private(set) var accounts: [Account] = [] {
        didSet { onAccountsChanged?(accounts) }
    }

    private(set) var state: State = .loading {
        didSet { onStateChanged?(state) }
    }

    // Somut servis sınıfı yerine protokol tutuluyor; test ve gerçek ağ servisi bu sayede enjekte edilebilir
    private let service: AccountServicing

    init(service: AccountServicing = SampleAccountService()) {
        self.service = service
    }

    // Hesapları enjekte edilen servisten async olarak yükler; sonucuna göre state günceller
    func loadAccounts() {
        state = .loading
        Task {
            do {
                let fetchedAccounts = try await service.fetchAccounts()
                accounts = fetchedAccounts
                state = fetchedAccounts.isEmpty ? .empty : .loaded
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    // Listeye rastgele bir mock hesap ekler
    func addRandomAccount() {
        accounts.append(.randomMockAccount())
        state = .loaded
    }

    // Verilen id'ye sahip hesabı listeden çıkarır; liste boşalırsa empty state'e geçer
    func deleteAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
        state = accounts.isEmpty ? .empty : .loaded
    }
}
