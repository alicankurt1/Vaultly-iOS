//
//  AccountServicing.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// ViewModel bu protokolü bilir, somut servis sınıfını bilmez;
// async throws olması sayesinde gerçek bir ağ servisi de aynı imzayla enjekte edilebilir
protocol AccountServicing {
    func fetchAccounts() async throws -> [Account]
}

enum AccountServiceError: Error, LocalizedError {
    case network

    var errorDescription: String? {
        switch self {
        case .network:
            return "Hesaplar yüklenemedi. İnternet bağlantınızı kontrol edip tekrar deneyin."
        }
    }
}

// Gerçek bir backend olmadığı için ağ gecikmesini ve olası hata durumunu simüle eder;
// ViewModel'in loading/error/empty state'lerini gerçekçi koşullarda göstermesini sağlar
struct SampleAccountService: AccountServicing {
    private let simulatedDelaySeconds: TimeInterval
    private let shouldSimulateFailure: () -> Bool

    init(
        simulatedDelaySeconds: TimeInterval = 1.2,
        shouldSimulateFailure: @escaping () -> Bool = { Int.random(in: 0..<4) == 0 }
    ) {
        self.simulatedDelaySeconds = simulatedDelaySeconds
        self.shouldSimulateFailure = shouldSimulateFailure
    }

    func fetchAccounts() async throws -> [Account] {
        try await Task.sleep(nanoseconds: UInt64(simulatedDelaySeconds * 1_000_000_000))
        if shouldSimulateFailure() {
            throw AccountServiceError.network
        }
        return Account.mockAccounts
    }
}
