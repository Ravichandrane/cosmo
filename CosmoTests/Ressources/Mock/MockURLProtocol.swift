//
//  MockURLProtocol.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation

final class MockURLProtocol: URLProtocol {

  struct Stub {
    let jsonName: String
    let error: NSError? = nil
    let statusCode: Int
  }

  static var stub: MockURLProtocol.Stub!
  
  private lazy var session: URLSession = {
    let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()

  private var activeTask: URLSessionTask?
  
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    return false
  }
  
  override func startLoading() {
    activeTask = session.dataTask(with: request)
    activeTask?.cancel()
  }
  
  override func stopLoading() {
    activeTask?.cancel()
  }

}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    switch MockURLProtocol.stub.statusCode {
    case 200...299:
      guard let data = try? JSONReader().loadFileData(from: MockURLProtocol.stub.jsonName),
            let response = HTTPURLResponse(
              url: request.url!,
              statusCode: MockURLProtocol.stub.statusCode,
              httpVersion: nil,
              headerFields: nil
            )
      else {
        client?.urlProtocolDidFinishLoading(self)
        return
      }
      
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
    case 400...499:
      client?.urlProtocol(self, didFailWithError: error!)
    case 500...599:
      client?.urlProtocol(self, didFailWithError: error!)
    default:
      break
    }
    
    client?.urlProtocolDidFinishLoading(self)
  }

}
