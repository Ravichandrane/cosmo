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
        case idle
        case loading
        case loaded
        case error
    }
    
    @Published private(set) var devicesList: [Device] = []
    @Published private(set) var state: State = .idle

    private let deviceService: DeviceService
    
    // MARK: - Initializer
    init(deviceService: DeviceService = .init()) {
        self.deviceService = deviceService
    }
    
    func fetchDevices() async {
        state = .loading
        
        do {
            let devices = try await deviceService.getDevices()
            devicesList = devices[Device.rootKey] ?? []
            state = .loaded
        } catch {
            print("error \(error)")
            state = .error
        }
    }
}
