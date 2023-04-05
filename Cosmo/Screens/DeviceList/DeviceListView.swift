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
        ZStack {
            switch viewModel.state {
            case .loading:
                loadingView
            case .loaded:
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
                }
            case .error:
                errorView
            }
        }.task {
            await viewModel.fetchDevices()
        }
    }
}

// MARK: - UI
private extension DeviceListView {
    enum Constant {
        static let firmwareLabelOpacity: CGFloat = 0.5
        static let trailingNavigationBarItemHeight: CGFloat = 96
        static let sfSymbolsIconSize: CGFloat = 30
        static let errorViewVStack: CGFloat = 10
        static let errorViewTextPadding: CGFloat = 20
        static let errorViewIconSize: CGFloat = 30
        static let errorViewFontSize: CGFloat = 20
    }

    var loadingView: some View {
        ProgressView {
            Text(L10n.Common.loading)
                .font(.title2)
        }
    }
    var errorView: some View {
      VStack(spacing: Constant.errorViewVStack) {
          Image(systemName: Asset.exclamationmark.rawValue)
            .font(.system(size: Constant.sfSymbolsIconSize, weight: .bold))
            .foregroundColor(Color.red)

          Text(L10n.Error.Network.Message.tryAgain)
            .padding([.leading, .trailing], Constant.errorViewTextPadding)
            .multilineTextAlignment(.center)
            .font(.system(size: Constant.errorViewFontSize, weight: .bold))
            .foregroundColor(Color(uiColor: UIColor.darkText))
          
          Button(action: {
              Task {
                await viewModel.fetchDevices()
              }
          }, label: {
              Text(L10n.Common.retry)
          })
          .buttonStyle(.borderedProminent)
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
}
