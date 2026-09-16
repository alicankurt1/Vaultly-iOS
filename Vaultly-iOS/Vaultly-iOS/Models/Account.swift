//
//  Account.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

struct Account: Hashable {
    let id: UUID
    let name: String
    let iban: String
    let balance: Decimal
    let currencyCode: String
}

extension Account {
    // Ekranı gerçek verisiz doğrulamak için statik mock liste
    static let mockAccounts: [Account] = [
        Account(id: UUID(), name: "Vadesiz Hesap", iban: "TR33 0006 1005 1978 6457 8413 26", balance: 24_580.75, currencyCode: "TRY"),
        Account(id: UUID(), name: "Birikim Hesabı", iban: "TR12 0004 6007 8888 8000 1234 56", balance: 112_340.00, currencyCode: "TRY"),
        Account(id: UUID(), name: "Dolar Hesabı", iban: "TR64 0001 2009 4520 0071 2345 67", balance: 3_250.40, currencyCode: "USD"),
        Account(id: UUID(), name: "Euro Hesabı", iban: "TR90 0010 3000 0000 0098 7654 32", balance: 980.10, currencyCode: "EUR")
    ]
}

extension Account {
    // Diffable snapshot'a yeni bir hesap ekleme senaryosunu göstermek için rastgele mock üretir
    static func randomMockAccount() -> Account {
        let names = ["Altın Hesabı", "Tatil Bütçesi", "Kira Hesabı", "Yatırım Hesabı"]
        let currencies = ["TRY", "USD", "EUR"]
        return Account(
            id: UUID(),
            name: names.randomElement()!,
            iban: "TR\(Int.random(in: 10...99)) 0000 0000 0000 0000 0000 00",
            balance: Decimal(Double.random(in: 100...50_000)),
            currencyCode: currencies.randomElement()!
        )
    }
}

extension Account {
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: balance as NSDecimalNumber) ?? "\(balance) \(currencyCode)"
    }
}
