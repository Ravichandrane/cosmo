//
//  APIRouteable.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

enum Params {
  case body(_:[String: Any])
  case url(_:[String: Any])
}

protocol APIRouteable: Any {
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Params { get }
}

extension APIRouteable {
  
  var parameters: Params {
    return .url([:])
  }
  
  var method: HTTPMethod {
    return .get
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try AppConstant.baseUrl.asURL()
    var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    var defaultParams: [URLQueryItem] = []
    
    urlRequest.httpMethod = method.rawValue
    
    switch parameters {
    case .body(let params):
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
    case .url(let params):
        let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        defaultParams += queryParams
    }
      
    components?.queryItems = defaultParams
    urlRequest.url = components?.url
    
    return urlRequest
  }
  
}
