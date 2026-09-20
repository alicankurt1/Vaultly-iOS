//
//  NetworkErrorTests.swift
//  Vaultly-iOSTests
//
//  Created by Alicank on 19.09.2026.
//

import Testing
@testable import Vaultly_iOS

// HTTP status code -> NetworkError eşlemesi ağdan bağımsız saf bir fonksiyon;
// mock'a gerek kalmadan doğrudan test edilebiliyor
struct NetworkErrorTests {

    @Test(
        "Bilinen status code'lar doğru case'e eşlenir",
        arguments: [
            (400, NetworkError.badRequest),
            (401, NetworkError.unauthorized),
            (403, NetworkError.forbidden),
            (404, NetworkError.notFound)
        ]
    )
    func init_knownStatusCode_mapsToExpectedCase(statusCode: Int, expected: NetworkError) {
        #expect(NetworkError(statusCode: statusCode) == expected)
    }

    @Test(
        "5xx aralığındaki status code'lar serverError'a eşlenir",
        arguments: [500, 502, 503, 599]
    )
    func init_serverErrorRange_mapsToServerError(statusCode: Int) {
        #expect(NetworkError(statusCode: statusCode) == .serverError(statusCode))
    }

    @Test(
        "Tanınmayan status code'lar unexpectedStatus'a eşlenir",
        arguments: [200, 301, 999]
    )
    func init_unknownStatusCode_mapsToUnexpectedStatus(statusCode: Int) {
        #expect(NetworkError(statusCode: statusCode) == .unexpectedStatus(statusCode))
    }

    @Test("Her case için kullanıcıya gösterilecek bir hata mesajı vardır")
    func errorDescription_isNeverEmpty() {
        let allCases: [NetworkError] = [.badRequest, .unauthorized, .forbidden, .notFound, .serverError(500), .unexpectedStatus(999)]
        for error in allCases {
            #expect(!(error.errorDescription ?? "").isEmpty)
        }
    }
}
