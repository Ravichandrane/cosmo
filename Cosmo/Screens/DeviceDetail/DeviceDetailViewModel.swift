//
//  DeviceDetailViewModel.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

final class DeviceDetailViewModel: ObservableObject {
    // Attributes
    var deviceModel: String {
        device.model
    }
    
    var lightValue: String {
        "\(device.lightValue) %"
    }
    
    var installationMode: String? {
        device.installationMode?.rawValue.capitalized
    }
    
    var brakeLight: String {
        "\(device.brakeLight)".capitalized
    }
    
    var lightMode: String? {
        device.lightMode?.rawValue.capitalized
    }
    
    var lightAuto: String {
        "\(device.lightAuto)".capitalized
    }
    
    var firmwareVersion: String {
        device.firmwareVersion
    }
    
    var macAddress: String {
        device.macAddress
    }
    
    var serialNumber: String? {
        device.serial
    }
    
    // Properties
    private let device: Device
    
    // MARK: - Initializer
    init(device: Device) {
        self.device = device
    }
}
