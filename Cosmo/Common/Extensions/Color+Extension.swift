//
//  Color+Extension.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

extension SwiftUI.Color {
  
  init(_ color: Colors) {
    self.init(color.rawValue, bundle: Bundle.main)
  }
  
}
