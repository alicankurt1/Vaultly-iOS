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

// Gerçek bir backend olmadığı için ağ gecikmesini ve HTTP status code'unu simüle eder;
// ViewModel'in loading/error/empty state'lerini gerçekçi koşullarda göstermesini sağlar
struct SampleAccountService: AccountServicing {
    private let simulatedDelaySeconds: TimeInterval
    private let simulateStatusCode: () -> Int

    init(
        simulatedDelaySeconds: TimeInterval = 1.2,
        simulateStatusCode: @escaping () -> Int = SampleAccountService.randomStatusCode
    ) {
        self.simulatedDelaySeconds = simulatedDelaySeconds
        self.simulateStatusCode = simulateStatusCode
    }

    func fetchAccounts() async throws -> [Account] {
        try await Task.sleep(nanoseconds: UInt64(simulatedDelaySeconds * 1_000_000_000))

        // Gerçek bir servette bu değer HTTPURLResponse.statusCode'dan gelir;
        // burada aynı doğrulamayı çalıştırmak için status code'u kendimiz üretiyoruz
        let statusCode = simulateStatusCode()
        guard (200...299).contains(statusCode) else {
            throw NetworkError(statusCode: statusCode)
        }
        return Account.mockAccounts
    }

    // %75 başarı (200), kalan %25 üç farklı hata koduna eşit dağıtılıyor
    private static func randomStatusCode() -> Int {
        switch Int.random(in: 0..<12) {
        case 0..<9: return 200
        case 9: return 401
        case 10: return 404
        default: return 500
        }
    }
}
