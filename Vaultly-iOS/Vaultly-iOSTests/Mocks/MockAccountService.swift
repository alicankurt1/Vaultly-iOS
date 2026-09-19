//
//  MockAccountService.swift
//  Vaultly-iOSTests
//
//  Created by Alicank on 19.09.2026.
//

import Foundation
@testable import Vaultly_iOS

// ViewModel gerçek servis yerine AccountServicing protokolünü bildiği için test tarafında
// aynı protokole uyan, gecikmesiz ve sonucu önceden belirlenmiş bu double enjekte edilebiliyor
final class MockAccountService: AccountServicing {
    enum Outcome {
        case success([Account])
        case failure(Error)
    }

    private let outcome: Outcome

    init(outcome: Outcome) {
        self.outcome = outcome
    }

    func fetchAccounts() async throws -> [Account] {
        switch outcome {
        case .success(let accounts):
            return accounts
        case .failure(let error):
            throw error
        }
    }
}
