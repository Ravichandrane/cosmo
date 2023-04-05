//
//  DeviceTests.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import XCTest
@testable import Cosmo

final class DeviceTests: XCTestCase {

    private var jsonReader: JSONReader!
    
    override func setUp() {
      super.setUp()
      jsonReader = JSONReader()
    }
    
    func test_decode_device_model() {
        let response = jsonReader.decode([String: [Device]].self, from: "DeviceSuccess")
      
        XCTAssertTrue((response[Device.rootKey]?[0].macAddress as Any) is String, "Mac address should be type of String")
        XCTAssertTrue((response[Device.rootKey]?[0].model as Any) is String, "Model should be type of String")
        XCTAssertTrue((response[Device.rootKey]?[0].product as Any) is String, "Product should be type of String")
        XCTAssertTrue((response[Device.rootKey]?[0].firmwareVersion as Any) is String, "firmwareVersion should be type of String")
        XCTAssertTrue((response[Device.rootKey]?[0].serial as Any) is String, "serial should be type of String")
        XCTAssertTrue((response[Device.rootKey]?[0].installationMode as Any) is Device.InstallationMode, "installationMode should be type of InstallationMode")
        XCTAssertTrue((response[Device.rootKey]?[0].brakeLight as Any) is Bool, "brakeLight should be type of Bool")
        XCTAssertTrue((response[Device.rootKey]?[0].lightMode as Any) is Device.LightMode, "lightMode should be type of LightMode")
        XCTAssertTrue((response[Device.rootKey]?[0].lightAuto as Any) is Bool, "lightAuto should be type of Bool")
        XCTAssertTrue((response[Device.rootKey]?[0].lightValue as Any) is Int, "lightValue should be type of Int")
    }
    
}
