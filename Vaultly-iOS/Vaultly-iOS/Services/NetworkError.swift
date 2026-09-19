//
//  NetworkError.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import Foundation

// HTTP status code'unu kendi tipimize çevirir; gerçek bir backend'e geçildiğinde
// HTTPURLResponse.statusCode buradan geçirilerek aynı hata mesajları üretilebilir
enum NetworkError: Error, LocalizedError, Equatable {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case unexpectedStatus(Int)

    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500...599:
            self = .serverError(statusCode)
        default:
            self = .unexpectedStatus(statusCode)
        }
    }

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "İstek hatalı. Lütfen tekrar deneyin."
        case .unauthorized:
            return "Oturumunuzun süresi dolmuş. Lütfen tekrar giriş yapın."
        case .forbidden:
            return "Bu işlem için yetkiniz yok."
        case .notFound:
            return "İstenen veri bulunamadı."
        case .serverError(let statusCode):
            return "Sunucu hatası (\(statusCode)). Lütfen daha sonra tekrar deneyin."
        case .unexpectedStatus(let statusCode):
            return "Beklenmeyen bir hata oluştu (\(statusCode))."
        }
    }
}
