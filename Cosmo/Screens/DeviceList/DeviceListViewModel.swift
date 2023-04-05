//
//  DeviceListViewModel.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

@MainActor
final class DeviceListViewModel: ObservableObject {
    // Properties
    enum State {
        case loading
        case loaded
        case error
    }
    
    @Published private(set) var devicesList: [Device] = []
    @Published private(set) var state: State = .loading

    private let deviceService: DeviceRouteable
    
    // MARK: - Initializer
    init(deviceService: DeviceRouteable = DeviceService()) {
        self.deviceService = deviceService
    }
}

// MARK: - Methods
extension DeviceListViewModel {
    func fetchDevices() async {
        if state != .loading {
            state = .loading
        }
    
        do {
            let devices = try await deviceService.getDevices()
            devicesList = devices[Device.rootKey] ?? []
            state = .loaded
        } catch {
            state = .error
        }
    }
}
