//
//  APIRequestable.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

enum APIError: Error {
  case invalidRequest
  case invalidResponse
  case serverError
  case unknown
}

protocol APIRequestable: AnyObject {
  func request<T: Decodable>(_ route: APIRouteable) async throws -> T
}

extension APIRequestable {
  
  func request<T: Decodable>(_ route: APIRouteable) async throws -> T {
    guard let request = try? route.asURLRequest() else {
      throw APIError.invalidRequest
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    switch httpResponse.statusCode {
      case 200...299:
        let decoder = JSONDecoder()      
        return try decoder.decode(T.self, from: data)
      case 400...499:
        throw APIError.invalidRequest
      case 500...599:
        throw APIError.serverError
      default:
        throw APIError.unknown
    }
  }
  
}
