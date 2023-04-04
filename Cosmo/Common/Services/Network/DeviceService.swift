//
//  DeviceService.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

protocol DeviceRouteable: AnyObject {
    func getDevices() async throws -> [String: [Device]]
}

final class DeviceService: APIRequestable {
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

extension DeviceService: DeviceRouteable {
    func getDevices() async throws -> [String: [Device]] {
        try await request(Endpoint.devices)
    }
}
