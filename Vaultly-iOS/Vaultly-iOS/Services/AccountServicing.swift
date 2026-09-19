//
//  AccountServicing.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// ViewModel bu protokolü bilir, somut servis sınıfını bilmez;
// Faz 6'da gerçek ağ servisi de bu protokole uyarak enjekte edilecek
protocol AccountServicing {
    func fetchAccounts() -> [Account]
}

// Şimdilik mock veriyle çalışan, gerçek servisin yerini tutan implementasyon
struct MockAccountService: AccountServicing {
    func fetchAccounts() -> [Account] {
        Account.mockAccounts
    }
}
