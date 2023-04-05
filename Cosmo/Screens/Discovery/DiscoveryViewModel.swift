//
//  DiscoveryViewModel.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation
import CoreBluetooth

@MainActor
final class DiscoveryViewModel: ObservableObject {
    // Properties
    @Published private(set) var bleState: CBManagerState = .unknown
    @Published private(set) var peripherals: [CBPeripheral] = []
    @Published private(set) var connectPeripherals: [CBPeripheral] = []
   
    @Published private var peripheralState: CBPeripheralState = .disconnected
    @Published private var characteristics: [String: [String]] = [:]
    
    private var selectedPeripheral: CBPeripheral?
    private let bleManager: BLEManager
    
    // MARK: - Initializer
    init(bleManager: BLEManager = .init()) {
        self.bleManager = bleManager
        self.bleManager.delegate = self
    }
}

// MARK: - Methods
extension DiscoveryViewModel {
    func requestPermission() {
        bleManager.requestPermission()
    }
    
    func scanForPeripherals() {
        bleManager.scanForPeripherals()
    }
    
    func connect(to peripheral: CBPeripheral) {
        peripheralState = .connecting
        selectedPeripheral = peripheral
        bleManager.connectPeripheral(peripheral)
    }
    
    func isConnecting(_ peripheral: CBPeripheral) -> Bool {
        selectedPeripheral != nil &&
        selectedPeripheral == peripheral &&
        peripheralState == .connecting
    }
    
    func getCharacteristics() -> [String] {
        guard let selectedPeripheral,
              let characteristics = characteristics[selectedPeripheral.identifier.uuidString]
        else { return [] }
        
        return characteristics
    }
}

// MARK: - BLEManagerDelegate
extension DiscoveryViewModel: BLEManagerDelegate {
    func didUpdateState(_ state: CBManagerState) {
        bleState = state
    }
    
    func didDiscover(peripheral: CBPeripheral, advertisementData: [String: Any]) {
        if !peripherals.contains(peripheral) &&
            peripheral.state == .disconnected &&
            peripheral.name != nil,
            advertisementData["kCBAdvDataIsConnectable"] as? Bool != false {
            peripherals.append(peripheral)
        }
    }
    
    func didConnect(peripheral: CBPeripheral) {
        peripheralState = .connected
        peripherals = peripherals.filter({ $0 != peripheral })
        connectPeripherals.append(peripheral)
        bleManager.discoverServices(for: peripheral, serviceUUIDs: nil)
    }
    
    func didDiscoverServices(_ services: [CBService], for peripheral: CBPeripheral, error: Error?) {
        for service in services {
            bleManager.discoverCharacteristics(service: service)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheral, characteristics: [CBCharacteristic]) {
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                bleManager.readValue(characteristic: characteristic)
            }
        }
    }
    
    func didUpdateValue(_ value: String) {
        guard !value.isEmpty,
                let selectedPeripheral
        else { return }
        
        if characteristics[selectedPeripheral.identifier.uuidString] != nil {
            characteristics[selectedPeripheral.identifier.uuidString]?.append(value)
        } else {
            characteristics[selectedPeripheral.identifier.uuidString, default: []].append(value)
        }
    }
}
