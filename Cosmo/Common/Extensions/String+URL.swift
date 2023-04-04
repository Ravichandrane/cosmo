//
//  String+URL.swift.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

extension String {

  func asURL() throws -> URL {
    guard let url = URL(string: self) else { fatalError("Invalid URL \(self)") }
    return url
  }

}
