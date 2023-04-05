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
    private var selectedPeripheral: CBPeripheral?
    private let bleManager: BLEManager
    
    // MARK: - Initializer
    init(bleManager: BLEManager = .init()) {
        self.bleManager = bleManager
        self.bleManager.delegate = self
    }
    
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
}

// MARK: - BLEManagerDelegate
extension DiscoveryViewModel: BLEManagerDelegate {
    func didUpdateState(_ state: CBManagerState) {
        bleState = state
    }
    
    func didDiscover(peripheral: CBPeripheral) {
        if !peripherals.contains(peripheral) &&
            peripheral.state == .disconnected &&
            peripheral.name != nil {
            peripherals.append(peripheral)
        }
    }
    
    func didConnect(peripheral: CBPeripheral) {
        peripheralState = .connected
        peripherals = peripherals.filter({ $0 != peripheral })
        connectPeripherals.append(peripheral)
    }
}
