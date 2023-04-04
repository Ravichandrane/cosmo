//
//  DeviceListItemView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

struct DeviceListItemView: View {
    
    // Properties
    var device: Device
    
    // Body
    var body: some View {
        Text(device.model)
    }
    
}
