//
//  DeviceListView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

struct DeviceListView: View {
    // Properties
    enum SheetItem: Hashable, Identifiable {
        var id: Self { self }
        
        case deviceListDetailView(device: Device)
        case discoveryDevice
    }
    
    @StateObject private var viewModel: DeviceListViewModel = .init()
    @State private var activeSheet: SheetItem?
    
    // Body
    var body: some View {
        NavigationView {
            ScrollView {
                deviceList
            }
            .navigation(title: L10n.Navigation.Title.devicesListView, displayMode: .inline)
            .toolbar{
                ToolbarItem(
                    placement: .navigationBarTrailing,
                    content: {
                        Button(action: {
                            activeSheet = .discoveryDevice
                        }, label: {
                            Image(systemName: Asset.connect.rawValue)
                        })
                        .frame(height: Constant.trailingNavigationBarItemHeight, alignment: .trailing)
                    }
                )
            }
            .sheet(item: $activeSheet, content: { activeSheet in
                switch activeSheet {
                case .deviceListDetailView(let device):
                    DeviceDetailView(viewModel: .init(device: device))
                case .discoveryDevice:
                    DiscoveryView()
                }
            })
            .task {
                await viewModel.fetchDevices()
            }
        }
    }
}

// MARK: - UI
private extension DeviceListView {
    enum Constant {
        static let firmwareLabelOpacity: CGFloat = 0.5
        static let trailingNavigationBarItemHeight: CGFloat = 96
    }
    
    @ViewBuilder
    func ItemView(device: Device) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Appearance.Padding.extraSmall) {
                Text(device.model)
                    .font(.system(size: Appearance.FontSize.medium, weight: .bold))
                Text(device.firmwareVersion)
                    .foregroundColor(Color.gray)
                    .opacity(Constant.firmwareLabelOpacity)
                    .font(.system(size: Appearance.FontSize.extraSmall, weight: .medium))
            }
            
            Spacer()
            
            Group {
                if device.lightValue > 0 {
                    Image(systemName: Asset.lightMax.rawValue)
                        .foregroundColor(Color.yellow)
                        .opacity(Double(device.lightValue) / 100)
                } else {
                    Image(systemName: Asset.lightMin.rawValue)
                        .foregroundColor(Color.gray)
                }
            }.font(.system(size: Appearance.FontSize.normal, weight: .black))
        }
    }
    
    var deviceList: some View {
        LazyVStack(alignment: .leading, spacing: Appearance.Padding.small) {
            ForEach(viewModel.devicesList, id: \.id, content: { device in
                ItemView(device: device)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        activeSheet = .deviceListDetailView(device: device)
                    }
                    .padding([.leading, .trailing], Appearance.Padding.normal)
                
                if device != viewModel.devicesList.last {
                    Divider()
                }
            })
        }.padding(.top, Appearance.Padding.small)
    }
}
