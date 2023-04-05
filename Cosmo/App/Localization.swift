//
//  Localization.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

enum L10n {
    enum Button {
        static let openSettings = L10n.tr("button.openSettings")
    }
    
    enum Navigation {
        enum Title {
            static let devicesListView = L10n.tr("navigation.devicesListView.title")
            static let deviceDetailView = L10n.tr("navigation.deviceDetailView.title")
        }
    }
    
    enum Authorization {
        enum Title {
            static let bluetooth = L10n.tr("authorization.title.bluetooth")
        }
        enum Message {
            static let bluetooth = L10n.tr("authorization.message.bluetooth")
        }
    }
    
    enum DeviceDetail {
        enum Section {
            enum Title {
                static let product = L10n.tr("deviceDetail.section.title.product")
                static let settings = L10n.tr("deviceDetail.section.title.settings")
                static let information = L10n.tr("deviceDetail.section.title.information")
            }
        }
        
        enum Row {
            enum Label {
                static let model = L10n.tr("deviceDetail.row.label.model")
                static let installationMode = L10n.tr("deviceDetail.row.label.installationMode")
                static let lightIntensity = L10n.tr("deviceDetail.row.label.lightIntensity")
                static let brakeLight = L10n.tr("deviceDetail.row.label.brakeLight")
                static let lightMode = L10n.tr("deviceDetail.row.label.lightMode")
                static let lightAuto = L10n.tr("deviceDetail.row.label.lightAuto")
                static let firmware = L10n.tr("deviceDetail.row.label.firmware")
                static let macAddress = L10n.tr("deviceDetail.row.label.macAddress")
                static let serialNumber = L10n.tr("deviceDetail.row.label.serialNumber")
            }
        }
    }
}

private extension L10n {

  static func tr(
    table: String = "Localizable",
    _ key: String,
    _ args: CVarArg...
  ) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, args)
  }
  
}
