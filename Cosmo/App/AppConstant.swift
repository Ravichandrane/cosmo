//
//  AppConstant.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

enum AppConstant {
    static var baseUrl: String {
        do {
            let url: String = try Configuration.value(for: "API_BASE_URL")
            return "https://\(url)/test"
        } catch {
            fatalError("API base url could not found inside Info.plist")
        }
    }
}
