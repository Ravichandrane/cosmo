//
//  StringTests.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import XCTest
@testable import Cosmo

final class StringTests: XCTestCase {
  
  func test_string_as_url() {
    XCTAssertTrue((try AppConstant.baseUrl.asURL() as Any) is URL, "asURL should return type of URL")
  }
  
}
