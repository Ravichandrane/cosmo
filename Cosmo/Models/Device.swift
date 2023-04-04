//
//  Device.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

struct Device: Decodable {
    static let rootKey: String = "devices"
    
    enum LightMode: String, Decodable {
        case OFF
        case BOTH
        case WARNING
        case POSITION
    }
    
    enum InstallationMode: String, Decodable {
        case helmet
        case seat
    }
    
    let id: UUID = UUID()
    let macAddress: String
    let model: String
    let product: String?
    let firmwareVersion: String
    let serial: String?
    let installationMode: InstallationMode?
    let brakeLight: Bool
    let lightMode: LightMode?
    let lightAuto: Bool
    let lightValue: Int
    
    enum CodingKeys: CodingKey {
        case macAddress
        case model
        case product
        case firmwareVersion
        case serial
        case installationMode
        case brakeLight
        case lightMode
        case lightAuto
        case lightValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.macAddress = try container.decode(String.self, forKey: .macAddress)
        self.model = try container.decode(String.self, forKey: .model)
        self.product = try container.decodeIfPresent(String.self, forKey: .product)
        self.firmwareVersion = try container.decode(String.self, forKey: .firmwareVersion)
        self.serial = try container.decodeIfPresent(String.self, forKey: .serial)
        self.installationMode = try container.decodeIfPresent(InstallationMode.self, forKey: .installationMode)
        self.brakeLight = try container.decode(Bool.self, forKey: .brakeLight)
        self.lightMode = try container.decodeIfPresent(LightMode.self, forKey: .lightMode)
        self.lightAuto = try container.decode(Bool.self, forKey: .lightAuto)
        self.lightValue = try container.decode(Int.self, forKey: .lightValue)
    }
}

extension Device: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }
    
}
