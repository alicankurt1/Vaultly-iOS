//
//  Transaction.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// Account gibi diffable/Sendable sınırlarına takılmamak için nonisolated tutuluyor
nonisolated struct Transaction: Hashable, Sendable {
    let id: UUID
    let title: String
    let amount: Decimal
    let date: Date
}

extension Transaction {
    // Gerçek bir işlem servisi olmadığı için ekranı doldurmak amacıyla rastgele üretilir
    static func mockTransactions() -> [Transaction] {
        let titles = ["Market", "Kira Ödemesi", "Maaş", "Fatura", "Transfer", "Yemek"]
        return (0..<6).map { _ in
            Transaction(
                id: UUID(),
                title: titles.randomElement()!,
                amount: Decimal(Double.random(in: -2_000...5_000)),
                date: Date().addingTimeInterval(Double.random(in: -30 * 86_400...0))
            )
        }
    }
}

extension Transaction {
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.positivePrefix = "+"
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}
