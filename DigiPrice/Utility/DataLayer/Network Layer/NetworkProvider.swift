//
//  NetworkProvider.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation
import CryptoSwift

protocol NetworkProvidable {
    func request<T: Decodable>(_ target: NetworkTarget) async throws -> T
}

/**
 - Network Provider that can be used for making HTTP network requests.
 - This class conforms to the `NetworkProvidable` protocol and provides an implementation for the `request` method.
 - This class can be used to make a `GET` request to the specified endpoint with the required authorization headers.
 - Note: The `request` method throws an error of type `APIError` if the HTTP request fails or if the response cannot be parsed.
 - Since it is not needed at the moment, it only throws a **GET** request due to the primitive version of the test project.
 - It must be renewed for comprehensive needs.
 */
public final class NetworkProvider: NetworkProvidable {
    private let session: URLSession
    
    /**
     Initializes a new instance of `NetworkProvider`.
     
     - Parameter session: The `URLSession` object to use for making network requests. Default value is `URLSession.shared`.
     - It can be change another session needs, like test, like different session config
     */
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /**
     Makes a network request to the specified endpoint.
     
     - Parameter target: The `NetworkTarget` object that specifies the endpoint to request and its query parameters.
     - Returns: An instance of the specified `Decodable` type that is decoded from the response data.
     - Throws: An error of type `APIError` if the HTTP request fails or if the response cannot be parsed.
     */
    public func request<T: Decodable>(_ target: NetworkTarget) async throws -> T {
        let targetURL = URL(string: target.baseURL + target.path + target.query)!
        let request = createRequestItem(targetURL)
        let result = try await session.data(for: request)
        return try map(result.0)
    }
    
    /**
     Maps the response data to the specified `Decodable` type.
     
     - Parameter data: The `Data` object that contains the response data.
     - Returns: An instance of the specified `Decodable` type that is decoded from the response data.
     - Throws: An error of type `APIError.parseFail` if the response data cannot be parsed.
     */
    private func map<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.parseFail
        }
    }
    
    /**
     Creates an `URLRequest` object for the specified URL with the required authorization headers.
     
     - Parameter url: The `URL` object that specifies the endpoint to request.
     - Returns: An instance of `URLRequest` with the required authorization headers for making a `GET` request.
     - Since it is not needed at the moment, it only throws a **GET** request due to the primitive version of the test project.
     */
    private func createRequestItem(_ url: URL) -> URLRequest {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        let apiKey: String = "8ddc0870-dab2-4d4a-aecc-7f1e3024c6b6"
        let apiSecret: String = "Bfo88H+fvNEMKu/KOLTC3TwyNJlgcML+"
        let nonce = String(Int(Date().timeIntervalSince1970 * 1000))
        let message: String = apiKey + nonce
        let result = try! HMAC(key: apiSecret, variant: .sha2(.sha256)).authenticate(message.bytes)
        let signature = result.toBase64()
        
        request.addValue(apiKey, forHTTPHeaderField: "X-PCK")
        request.addValue(nonce, forHTTPHeaderField: "X-Stamp")
        request.addValue(signature, forHTTPHeaderField: "X-Signature")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

enum APIError: Error {
    case parseFail
}
