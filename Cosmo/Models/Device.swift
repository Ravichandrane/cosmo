//
//  Device.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

struct Device: Decodable {
    static let rootKey: String = "devices"
    
    let id: UUID = UUID()
    let macAddress: String
    let model: String
    let product: String?
    let firmwareVersion: String
    let serial: String?
    let installationMode: String?
    let brakeLight: Bool
    let lightMode: String?
    let lightAuto: Bool
    let lightValue: Float
    
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
        self.installationMode = try container.decodeIfPresent(String.self, forKey: .installationMode)
        self.brakeLight = try container.decode(Bool.self, forKey: .brakeLight)
        self.lightMode = try container.decodeIfPresent(String.self, forKey: .lightMode)
        self.lightAuto = try container.decode(Bool.self, forKey: .lightAuto)
        self.lightValue = try container.decode(Float.self, forKey: .lightValue)
    }
}
