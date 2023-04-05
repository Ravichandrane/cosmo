//
//  DiscoveryView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import SwiftUI

struct DiscoveryView: View {
    // Properties
    @StateObject private var viewModel: DiscoveryViewModel = .init()
    
    // Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.bleState {
                case .poweredOn:
                    discoveryView
                default:
                    permissionView
                }
            }.navigation(title: "Discovery", displayMode: .inline)
        }
        .onAppear {
            viewModel.requestPermission()
        }
        .onReceive(viewModel.$bleState) { state in
            switch state {
            case.poweredOn:
                viewModel.scanForPeripherals()
            default:
                break
            }
        }
    }
}

// MARK: - UI
private extension DiscoveryView {
    
    var permissionView: some View {
        VStack(spacing: Appearance.Padding.small) {
            Image(systemName: Asset.connect.rawValue)
                .font(.system(size: Appearance.FontSize.big, weight: .bold))
                .foregroundColor(Color.blue)

            Text(L10n.Authorization.Title.bluetooth)
                .font(.system(size: Appearance.FontSize.big, weight: .semibold))

            Text(L10n.Authorization.Message.bluetooth)
                .multilineTextAlignment(.center)
                .font(.system(size: Appearance.FontSize.small, weight: .medium))
                .padding(.bottom, Appearance.Padding.small)
            
            Button(action: { AppConstant.openSettings() }, label: {
                Text(L10n.Button.openSettings)
            })
            .buttonStyle(.borderedProminent)
        }
    }
    
    var discoveryView: some View {
        List {
            Section(header: Text("My devices")) {
                
            }
            
            Section(header: Text("Other devices")) {
                ForEach(viewModel.peripherals, id: \.self) { peripheral in
                    Text(peripheral.name ?? "")
                }
            }
        }
    }
}
