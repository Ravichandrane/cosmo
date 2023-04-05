//
//  DiscoveryViewModel.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation
import Combine
import CoreBluetooth

@MainActor
final class DiscoveryViewModel: ObservableObject {
    // Properties
    @Published private(set) var bleState: CBManagerState = .unknown
    @Published private(set) var peripherals: [CBPeripheral] = []
    
    private let bleManager: BLEManager
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(bleManager: BLEManager = .init()) {
        self.bleManager = bleManager
        sinkUpdateState()
        sinkPeripheral()
    }
    
    func sinkUpdateState() {
        bleManager.$updateState
            .sink {[weak self] state in
                guard let self else { return }
                self.bleState = state
            }
            .store(in: &cancellable)
    }
    
    func sinkPeripheral() {
        bleManager.$peripheral
            .compactMap({ $0 })
            .sink {[weak self] peripheral in
                guard let self else { return }
                if !self.peripherals.contains(peripheral) {
                    self.peripherals.append(peripheral)
                }
            }
            .store(in: &cancellable)
    }
    
    func requestPermission() {
        bleManager.requestPermission()
    }
    
    func scanForPeripherals() {
        bleManager.scanForPeripherals()
    }
}
