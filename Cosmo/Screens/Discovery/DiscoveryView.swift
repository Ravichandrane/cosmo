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
    @State private var isPresentingDetailView: Bool = false
    
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
            }
            .navigation(title: L10n.Navigation.Title.discovery, displayMode: .inline)
            .addDismissToolbar()
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
            Section(content: {
                connectedDevicesContent
            }, header: {
                headerSection(withTitle: L10n.Discovery.Section.Title.myDevices)
            })
            
            Section(content: {
                searchDevicesContent
            }, header: {
                headerSection(withTitle: L10n.Discovery.Section.Title.otherDevices,
                              isSpinning: true)
            })
        }.background(content: {
            NavigationLink(
                destination: DiscoveryDetailView(
                    viewModel: .init(characteristics: viewModel.getCharacteristics())
                ),
                isActive: $isPresentingDetailView,
                label: { EmptyView() }
            )
        })
    }
    
    var connectedDevicesContent: some View {
        ForEach(viewModel.connectPeripherals, id: \.self) { peripheral in
            HStack {
                Text(peripheral.name ?? "")
                Spacer()
                Image(systemName: Asset.info.rawValue)
                    .foregroundColor(Color.blue)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isPresentingDetailView = true
            }
        }
    }
    
    var searchDevicesContent: some View {
        ForEach(viewModel.peripherals, id: \.self) { peripheral in
            Button(action: {
                viewModel.connect(to: peripheral)
            }, label: {
                HStack(spacing: Appearance.Padding.extraSmall) {
                    Text(peripheral.name ?? "")
                        .foregroundColor(Color.black)
                    
                    if viewModel.isConnecting(peripheral) {
                        ProgressView()
                    }
                }
            })
        }
    }
    
    @ViewBuilder
    func headerSection(withTitle title: String, isSpinning: Bool = false) -> some View {
        HStack(spacing: Appearance.Padding.extraSmall) {
            Text(title)
            if isSpinning {
                ProgressView()
            }
        }
    }
}
