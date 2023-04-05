//
//  MockAPIRequestable.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation
@testable import Cosmo

class MockAPIRequestable: APIRequestable {
  private lazy var sessionManager: URLSession = {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [MockURLProtocol.self]
      
      return URLSession(configuration: configuration)
    }()
  
  func request<T: Decodable>(_ route: APIRouteable) async throws -> T {
    let (data, _) = try await sessionManager.data(for: route.asURLRequest())
    
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  }
}
