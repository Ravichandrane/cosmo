//
//  Colors.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

enum Colors: String {
    case white
    case black
}

extension Colors {
    var color: Color {
        return Color(rawValue, bundle: Bundle.main)
    }
}
