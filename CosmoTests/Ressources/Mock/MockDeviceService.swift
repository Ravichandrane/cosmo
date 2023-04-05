//
//  MockDeviceService.swift
//  CosmoTests
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation
@testable import Cosmo

class MockDeviceService: MockAPIRequestable {
    enum Endpoint: APIRouteable {
        case devices
        
        var path: String {
            switch self {
            case .devices:
                return "/devices"
            }
        }
    }
}

extension MockDeviceService: DeviceRouteable {
    func getDevices() async throws -> [String : [Cosmo.Device]] {
        try await request(Endpoint.devices)
    }
}
