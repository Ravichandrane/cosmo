//
//  DeviceDetailView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

struct DeviceDetailView: View {
    // Properties
    @Environment(\.presentationMode) private var presentationMode
    @State private var isLongPressed: Bool = false
    
    private let viewModel: DeviceDetailViewModel
    
    // Initializer
    init(viewModel: DeviceDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // Body
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(L10n.DeviceDetail.Section.Title.product)) {
                    rowView(label: L10n.DeviceDetail.Row.Label.model, viewModel.deviceModel)
                }
                
                Section(header: Text(L10n.DeviceDetail.Section.Title.settings)) {
                    if let installationMode = viewModel.installationMode {
                        rowView(label: L10n.DeviceDetail.Row.Label.installationMode, installationMode)
                    }
                    
                    rowView(label: L10n.DeviceDetail.Row.Label.lightIntensity, viewModel.lightValue)
                    rowView(label: L10n.DeviceDetail.Row.Label.brakeLight, "\(viewModel.brakeLight)")
                    
                    if let lightMode = viewModel.lightMode {
                        rowView(label: L10n.DeviceDetail.Row.Label.lightMode, lightMode)
                    }
                    
                    rowView(label: L10n.DeviceDetail.Row.Label.lightAuto, viewModel.lightAuto)
                }
                
                Section(header: Text(L10n.DeviceDetail.Section.Title.information)) {
                    rowView(label: L10n.DeviceDetail.Row.Label.firmware, viewModel.firmwareVersion)
                    rowView(label: L10n.DeviceDetail.Row.Label.macAddress, viewModel.macAddress)
                    
                    if let serial = viewModel.serialNumber {
                        rowView(label: L10n.DeviceDetail.Row.Label.serialNumber, serial)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigation(title: L10n.Navigation.Title.deviceDetailView, displayMode: .inline)
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarLeading,
                    content: {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: Asset.chevronDown.rawValue)
                                .foregroundColor(Color.black)
                        })
                    }
                )
            }
        }
    }
}

// MARK: - UI
private extension DeviceDetailView {
    @ViewBuilder
    func rowView(label: String, _ text: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: Appearance.FontSize.normal, weight: .medium))
            Spacer()
            Text(text)
                .lineLimit(1)
                .font(.system(size: Appearance.FontSize.small))
        }
    }
}
