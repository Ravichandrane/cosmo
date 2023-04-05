//
//  DeviceListViewModelTests.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import XCTest
@testable import Cosmo

@MainActor
final class DeviceListViewModelTests: XCTestCase {
    var viewModel: DeviceListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = .init(
            deviceService: MockDeviceService()
        )
    }
    
    func test_fetch_device_success() async {
        MockURLProtocol.stub = MockURLProtocol.Stub(
          jsonName: "DeviceSuccess",
          statusCode: 200
        )
        
        await viewModel.fetchDevices()
        
        XCTAssertTrue(!viewModel.devicesList.isEmpty, "It should success and return no empty array")
        XCTAssert(viewModel.state == .loaded, "It should be loaded as state")
    }
    
    func test_fetch_device_fail() async {
        MockURLProtocol.stub = MockURLProtocol.Stub(
          jsonName: "DeviceSuccess",
          statusCode: 400
        )
        
        await viewModel.fetchDevices()
        
        XCTAssertTrue(viewModel.devicesList.isEmpty, "It should fail and return an empty array")
        XCTAssert(viewModel.state == .error, "It should be error as state")
    }
}
