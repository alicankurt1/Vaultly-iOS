//
//  AccountListViewModelTests.swift
//  Vaultly-iOSTests
//
//  Created by Alicank on 19.09.2026.
//

import Testing
@testable import Vaultly_iOS

// ViewModel MainActor izolasyonuna tabi olduğu için (bkz. SWIFT_DEFAULT_ACTOR_ISOLATION)
// testler de aynı actor üzerinde çalışıyor; async Task içindeki state güncellemesini
// beklemek için loadAccounts sonrası koşullu bir polling kullanılıyor
@MainActor
@Suite
struct AccountListViewModelTests {

    @Test("Hesaplar başarıyla döndüğünde state .loading'den .loaded'a geçer")
    func loadAccounts_success_setsLoadedState() async throws {
        let mockAccounts = Account.mockAccounts
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .success(mockAccounts)))

        var observedStates: [AccountListViewModel.State] = []
        viewModel.onStateChanged = { observedStates.append($0) }

        viewModel.loadAccounts()
        try await waitUntil { viewModel.state == .loaded }

        #expect(observedStates.first == .loading)
        #expect(viewModel.state == .loaded)
        #expect(viewModel.accounts == mockAccounts)
    }

    @Test("Servis boş liste döndürdüğünde state .empty olur")
    func loadAccounts_emptyResult_setsEmptyState() async throws {
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .success([])))

        viewModel.loadAccounts()
        try await waitUntil { viewModel.state == .empty }

        #expect(viewModel.accounts.isEmpty)
    }

    @Test("Servis hata fırlattığında state .error mesajıyla dolar")
    func loadAccounts_failure_setsErrorState() async throws {
        let expectedError = NetworkError(statusCode: 401)
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .failure(expectedError)))

        viewModel.loadAccounts()
        try await waitUntil {
            if case .error = viewModel.state { return true }
            return false
        }

        guard case .error(let message) = viewModel.state else {
            Issue.record("State .error olmalıydı ama \(viewModel.state) geldi")
            return
        }
        #expect(message == expectedError.localizedDescription)
    }

    @Test("Rastgele hesap eklendiğinde listeye eklenir ve state .loaded olur")
    func addRandomAccount_appendsAccountAndSetsLoadedState() {
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .success([])))

        viewModel.addRandomAccount()

        #expect(viewModel.accounts.count == 1)
        #expect(viewModel.state == .loaded)
    }

    @Test("Son hesap silindiğinde state .empty olur")
    func deleteAccount_removingLastAccount_setsEmptyState() async throws {
        let account = Account.mockAccounts[0]
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .success([account])))

        viewModel.loadAccounts()
        try await waitUntil { viewModel.state == .loaded }

        viewModel.deleteAccount(id: account.id)

        #expect(viewModel.accounts.isEmpty)
        #expect(viewModel.state == .empty)
    }

    @Test("Birden çok hesaptan biri silindiğinde state .loaded kalır")
    func deleteAccount_removingOneOfMany_keepsLoadedState() async throws {
        let accounts = Account.mockAccounts
        let viewModel = AccountListViewModel(service: MockAccountService(outcome: .success(accounts)))

        viewModel.loadAccounts()
        try await waitUntil { viewModel.state == .loaded }

        viewModel.deleteAccount(id: accounts[0].id)

        #expect(viewModel.accounts.count == accounts.count - 1)
        #expect(viewModel.state == .loaded)
    }
}

// loadAccounts() içindeki Task { } fire-and-forget çalıştığı için testin onu senkronize bir
// şekilde bekleyebilmesi gerekiyor; kısa aralıklarla state'i kontrol edip zaman aşımında
// testi anlamlı bir hatayla başarısız kılan küçük bir yardımcı
@MainActor
private func waitUntil(
    timeout: Duration = .seconds(2),
    _ condition: () -> Bool
) async throws {
    let deadline = ContinuousClock.now + timeout
    while !condition() {
        if ContinuousClock.now >= deadline {
            Issue.record("Beklenen koşul \(timeout) içinde gerçekleşmedi")
            return
        }
        try await Task.sleep(for: .milliseconds(10))
    }
}
