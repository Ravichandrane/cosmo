//
//  JSONReader.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation
@testable import Cosmo

final class JSONReader {
  func loadFileData(from fileName: String) throws -> Data {
    guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json"),
            let jsonData = try String(contentsOfFile: filePath).data(using: .utf8)
    else { fatalError("Failed to locate \(fileName) in bundle.") }

    return jsonData
  }
  
  func decode<T: Decodable>(_ model: T.Type, from file: String) -> T {
    guard let path = Bundle(for: type(of: self)).path(forResource: file, ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    else { fatalError("Failed to locate \(file) in bundle.") }
       
    let decoder = JSONDecoder()
    guard let response = try? decoder.decode(T.self, from: data)
    else { fatalError("Failed to decode \(file)") }
       
    return response
  }
}
