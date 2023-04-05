//
//  DiscoveryDetailViewModel.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import Foundation

final class DiscoveryDetailViewModel: ObservableObject {
    // Properties
    private(set) var characteristics: [String] = []
    
    // MARK: - Initializer
    init(characteristics: [String]) {
        self.characteristics = characteristics
    }
}
