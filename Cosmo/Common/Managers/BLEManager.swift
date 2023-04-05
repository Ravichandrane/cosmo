//
//  BLEManager.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import CoreBluetooth

protocol BLEManagerDelegate: AnyObject {
    func didUpdateState(_ state: CBManagerState)
    func didDiscover(peripheral: CBPeripheral, advertisementData: [String: Any])
    func didConnect(peripheral: CBPeripheral)
    func didDiscoverServices(_ services: [CBService], for peripheral: CBPeripheral, error: Error?)
    func didDiscoverCharacteristics(_ peripheral: CBPeripheral, characteristics: [CBCharacteristic])
    func didUpdateValue(_ value: String)
}

final class BLEManager: NSObject {
    // Properties
    private var central: CBCentralManager!
    private var currentPeripheral: CBPeripheral?
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
    
    func discoverServices(for peripheral: CBPeripheral, serviceUUIDs: [CBUUID]?) {
        currentPeripheral = peripheral
        currentPeripheral?.delegate = self
        currentPeripheral?.discoverServices(serviceUUIDs)
    }
    
    func discoverCharacteristics(service: CBService) {
        currentPeripheral?.discoverCharacteristics(nil, for: service)
    }
    
    func readValue(characteristic: CBCharacteristic) {
        currentPeripheral?.readValue(for: characteristic)
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
        delegate?.didDiscover(peripheral: peripheral, advertisementData: advertisementData)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didConnect(peripheral: peripheral)
    }
}

// MARK: - CBPeripheralDelegate
extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        delegate?.didDiscoverServices(services, for: peripheral, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        delegate?.didDiscoverCharacteristics(peripheral, characteristics: characteristics)
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard let value = characteristic.value,
              let result = String(bytes: value, encoding: .utf8)
        else { return }
        
        delegate?.didUpdateValue(result)
    }
}
