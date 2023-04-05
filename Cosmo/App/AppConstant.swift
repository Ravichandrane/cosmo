//
//  AppConstant.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import UIKit

enum AppConstant {
    static var baseUrl: String {
        do {
            let url: String = try Configuration.value(for: "API_BASE_URL")
            return "https://\(url)/test"
        } catch {
            fatalError("API base url could not found inside Info.plist")
        }
    }
    
    static func openSettings() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
}
