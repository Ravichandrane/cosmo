//
//  BLEManager.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import CoreBluetooth

final class BLEManager: NSObject {
    // Properties
    @Published private(set) var updateState: CBManagerState = .unknown
    @Published private(set) var peripheral: CBPeripheral?
    
    private var central: CBCentralManager!
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    func requestPermission() {
        central = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForPeripherals(withServices services: [CBUUID]? = nil) {
        central.scanForPeripherals(withServices: services)
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateState = central.state
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            self.peripheral = peripheral
        }
    }
}
