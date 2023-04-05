//
//  BLEManager.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import CoreBluetooth

protocol BLEManagerDelegate: AnyObject {
    func didUpdateState(_ state: CBManagerState)
    func didDiscover(peripheral: CBPeripheral)
    func didConnect(peripheral: CBPeripheral)
}

final class BLEManager: NSObject {
    // Properties    
    private var central: CBCentralManager!
    weak var delegate: BLEManagerDelegate?
    
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
    
    func connectPeripheral(_ peripheral: CBPeripheral) {
        central.connect(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didUpdateState(central.state)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.didDiscover(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didConnect(peripheral: peripheral)
    }
}
