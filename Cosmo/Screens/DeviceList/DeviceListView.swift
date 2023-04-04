//
//  DeviceListView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

struct DeviceListView: View {
    // Properties
    @StateObject private var viewModel: DeviceListViewModel = .init()
    
    // Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.devicesList, id: \.id, content: { device in
                        DeviceListItemView(device: device)
                    })
                }
            }
            .navigation(title: "Cosmo" ,displayMode: .inline)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchDevices()
            }
        }
    }
}
